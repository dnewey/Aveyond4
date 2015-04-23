#==============================================================================
# ** Game_Event
#------------------------------------------------------------------------------
#  This class deals with events. It handles functions including event page 
#  switching via condition determinants, and running parallel process events.
#  It's used within the Game_Map class.
#==============================================================================

class Game_Event < Game_Character
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :trigger                  # trigger
  attr_reader   :list                     # list of event commands
  attr_reader   :starting                 # starting flag
  
  attr_reader   :name
  attr_reader   :event

  attr_reader :above
  attr_reader :below
      
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     event  : event (RPG::Event)
  #--------------------------------------------------------------------------
  def initialize(event)
    super()

    @event = event
    @id = event.id
    
    @erased = false
    @disabled = $state.disable?(@id)
    @deleted = $state.delete?(@id)

    @starting = false
    @through = true
    @above = false
    @below = false

    @width = 1
    @height = 1

    # Name breakdown
    name = @event.name
    if name.include?('::')
      name = name.delete('::')
      clone = name
    end
    if name == '' || name == '#'
      @icon = nil
      @name = 'nil'
    else
      data = name.split('#').first.split('.')
      if data.size > 1
        @icon = data[0].strip
        @name = data[1].strip
      else
        @icon = @name = data[0].strip
      end
    end   
    
    # Set pages from clone or event
    if clone
      @pages = $data.clones[clone]
    else
      @pages = @event.pages 
    end

    # Restore saved location if relevant
    if $state.loc?(@id)
      loc = $state.getloc(@id)
      moveto(loc[0],loc[1])
    else
      moveto(@event.x, @event.y)
    end
    
    refresh
  end

  def at?(x,y)
    return self.x == x && self.y == y
  end

  #--------------------------------------------------------------------------
  # * Clear Starting Flag
  #--------------------------------------------------------------------------
  def clear_starting
    @starting = false
  end

  def icon
    return nil if @erased || @disabled || @deleted
    return @icon
  end

  def collide?(x,y)
    return false if x < @x
    return false if y < @y
    return false if x > @x + @width - 1
    return false if y > @y + @height - 1
    return true
  end

  #--------------------------------------------------------------------------
  # * Determine if Over Trigger
  #    is this event under player
  #--------------------------------------------------------------------------
  def over_trigger?
    # If not through situation with character as graphic
    if @character_name != "" and not @through
      # Starting determinant is face
      return false
    end
    # If this position on the map is impassable
    unless $map.passable?(@x, @y, 0)
      # Starting determinant is face
      return false
    end
    # Starting determinant is same position
    return true
  end

  #--------------------------------------------------------------------------
  # * Start Event
  #--------------------------------------------------------------------------
  def start  
    return if @erased || @deleted || @disabled
    return if !@list || @list.size < 1
    @starting = true    
  end

  def find_page
    return nil if @erased || @deleted
    @pages.reverse.find { |page| 
      conditions_met?(page) 
    } 
  end

  def conditions_met?(page)
      
        # DANHAX - check super conditions
        page.list.each{ |line|
      
          if line.code == 108
            comment = line.parameters[0]
            if comment[0] == '?'[0]
              data = comment.split(' ')
              if !condition_applies?(data)
                return false
              end
            end
          end        
        }  

        return true
  end

  def condition_applies?(cond)
      # cond is [code,data1.....]

    case cond[0]

      # Flag
      when '?flag'
          return false if !flag?(cond[1])
              
        # Progress
      when '?progress'
        return false if !progress?(cond[1])

      # Active Quest
      when '?active'
        return false if !on_quest?(cond[1])
         when '?quest'
        return false if !on_quest?(cond[1])  
              
        # Item Check
      when '?item'
        return false if !$game_party.has_item?(cond[1].to_i)

    end

    return true

  end

  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    new_page = find_page
    setup_page(new_page) if new_page != @page
  end

  
  
  def setup_page(new_page)

    # Set @page as current event page
    @page = new_page
    if @page
      setup_page_settings
      read_comment_data
    else
      clear_page_settings
    end

    # Clear starting flag
    clear_starting
    
    # If trigger is [parallel process]
    if @trigger == 4
      @interpreter = Interpreter.new
      @interpreter.setup(@list, @event.id)
    end

    # Auto event start determinant
    check_event_trigger_auto

  end
  

  def clear_page_settings
      @character_name = ""
      @move_type = 0
      @through = true
      @trigger = nil
      @list = nil
      @interpreter = nil
  end

  def setup_page_settings
    # Set each instance variable
    @character_name = @page.graphic.character_name
    if @original_direction != @page.graphic.direction
      @direction = @page.graphic.direction
      @original_direction = @direction
      @prelock_direction = 0
    end
    if @original_pattern != @page.graphic.pattern
      @pattern = @page.graphic.pattern
      @original_pattern = @pattern
    end
    #XP - VX @opacity = @page.graphic.opacity
    #XP - VX @blend_type = @page.graphic.blend_type
    @move_type = @page.move_type
    @move_speed = @page.move_speed
    @move_frequency = @page.move_frequency
    @move_route = @page.move_route
    @move_route_index = 0
    @move_route_forcing = false
    @walk_anime = @page.walk_anime
    @step_anime = @page.step_anime
    @direction_fix = @page.direction_fix
    @through = @page.through
    #XP - VX @always_on_top = @page.always_on_top
    @trigger = @page.trigger
    @list = @page.list
    @interpreter = nil

  end
  
  def read_comment_data
    comment_data = []

    @list.each{ |line|
      next if line.code != 108
      if line.parameters[0].include?('#')
        comment_data.push(line.parameters[0].split(" "))
      end
    }

    comment_data.each{ |data|
      case data[0]

        when '#above'
          @above = true
        when '#below'
          @below = true

        when '#opacity'
          self.opacity = data[1].to_i
        when '#hide'
          self.opacity = 0

        when '#width'
          @width = data[1].to_i
        when '#height'
          @height = data[1].to_i
        when '#gfx'

          if @character_name == "!!Prop"
            @character_name = "Props/"+data[1]
          end

        when '#ox'
          @off_x = data[1].to_i
        when '#oy'
          @off_y = data[1].to_i

        when '#disable'
          disable

      end
    }
    

  end

  #--------------------------------------------------------------------------
  # * Automatic Event Starting Determinant
  #--------------------------------------------------------------------------
  def check_event_trigger_auto
    # # If trigger is [touch from event] and consistent with player coordinates
    # if @trigger == 2 and @x == $player.x and @y == $player.y
    #   # If starting determinant other than jumping is same position event
    #   if not jumping? and over_trigger?
    #     start
    #   end
    # end
    # If trigger is [auto run]
    if @trigger == 3 || @event.name == 'AUTORUN'
      start
    end
  end

  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    # Automatic event starting determinant
    check_event_trigger_auto

    # If parallel process is valid
    if @interpreter != nil
      @interpreter.update
    end

  end
    
  #--------------------------------------------------------------------------
  # * Save Position
  #--------------------------------------------------------------------------
  def saveloc
    $state.loc!(@event.id)
  end

  #--------------------------------------------------------------------------
  # * Temporarily Erase
  #--------------------------------------------------------------------------
  def erase
    @erased = true
    self.opacity = 0
    refresh
  end

  def disable
    @disabled = true
    $state.disable(@id)
    refresh
  end

  def enable
    @disabled = false
    $state.enable(@id)
    refresh
  end

  def delete
    @deleted = true
    $state.delete(@id)
    self.opacity = 0
    refresh
  end

end