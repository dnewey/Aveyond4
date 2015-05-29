#==============================================================================
# ** Game_Event
#==============================================================================

class Game_Event < Game_Character

  attr_reader   :trigger   
  attr_reader   :list          
  attr_reader   :starting  
  
  attr_reader   :name
  attr_reader   :event
  attr_reader   :icon

  attr_accessor :random

  attr_reader :above
  attr_reader :below

  attr_reader :page_idx

  attr_reader :deleted, :disabled, :erased
      

  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------

  def initialize(event)
    super()

    @event = event
    @id = event.id

    # Hold a random number to be used with @r1
    @random = 0 
    
    @erased = false
    @disabled = $state.disable?(@id)
    @deleted = $state.delete?(@id)

    @starting = false
    @through = true
    @above = false
    @below = false

    @width = 1
    @height = 1

    @page = nil
    @page_idx = -1

    # Name breakdown
    name = @event.name

    clone_ev = nil
    
    # Clone map clone
    if name.include?('::')
      clone = name.delete('::')
      name = $data.clones[clone].name
      clone_ev = $data.clones[clone]
    elsif name.include?(':')
      clone = name.delete(':')
      clone_ev = $scene.map.event_by_name(clone).event
      name = clone_ev.name
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
    if clone_ev
      @pages = clone_ev.pages
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
    refresh
    @starting = true    

  end

  def stop

    $player.looklike($party.leader)
    
    # Enable the second state if there is one
    state(@id,"second_#{@page_idx}") if !is_second?(@page)

  end

  def find_page
    return nil if @erased || @deleted
    page = @pages.count-1
    while page >= 0
      return page if conditions_met?(page)
      page -= 1
    end
  end

  def conditions_met?(idx)
        #return false if page == 0

        page = @pages[idx]
      
        # DANHAX - check super conditions
        page.list.each{ |line|
      
          if line.code == 108
            comment = line.parameters[0]
            if comment[0] == '?'[0]
              data = comment.split(' ')
              if !condition_applies?(data,idx)
                return false
              end
            end
          end        
        }  

        return true
  end

  # Can also be called by script
  def condition_applies?(cond,idx)
      # cond is [code,data1.....]

    case cond[0]

      # Second
      when '?second'
        return false if !conditions_met?(idx-1)
        return false if !state?(@id,"second_#{idx-1}")
       

      # Flag
      when '?flag'
          return false if !flag?(cond[1])
              
      # Progress
      when '?before'
        return false if !$progress.before?(cond[1])
      when '?progress'
        return false if !$progress.progress?(cond[1])
      when '?after'
        return false if !$progress.beyond?(cond[1])

      # States
      when '?state'
        if cond.count > 2
          return false if !$state.state?(gid(cond[1]),cond[2])
        else
          return false if !$state.state?(@id,cond[1])
        end

      # Active Quest
      when '?active'
        return false if !$progress.active?(cond[1])
      when '?inactive'
        return false if $progress.active?(cond[1])
      when '?complete'
        return false if !$progress.complete?(cond[1])
      when '?incomplete'
        return false if $progress.complete?(cond[1])
      when '?quest'
        return false if !$progress.quest?(cond[1])

      # Party member check
      when '?boyle', '?boy'
        return false if !$party.has_member?('boy')
      when '?ingrid', '?ing'
        return false if !$party.has_member?('ing')
      when '?myst', '?mys'
        return false if !$party.has_member?('mys')
      when '?robin', '?rob'
        return false if !$party.has_member?('rob')
      when '?hiberu', '?hib'
        return false if !$party.has_member?('hib')
      when '?rowen', '?row'
        return false if !$party.has_member?('row')
      when '?phye', '?phy'
        return false if !$party.has_member?('phy')

      # Inventory
      when '?gold'
        return false if !$party.has_gold?(cond[1].to_i)

      when '?item'
        cond[2] = 1 if cond.count < 3
        return false if !($party.item_number(cond[1]) >= cond[2].to_i)



    end

    return true

  end

  def label_applies?(label)

    case label.split(":")[0]
      
      when '@first'
        return false if state?(me,"second_#{this.page_idx}")
      when '@second'
        return false if !state?(me,"second_#{this.page_idx}")

      # Char in party
      when '@boy'
        return false if $party.leader != 'boy'      
      when '@ing'
        return false if $party.leader != 'ing'
      when '@mys'
        return false if $party.leader != 'mys'
      when '@rob'
        return false if $party.leader != 'rob'
      when '@hib'
        return false if $party.leader != 'hib'
      when '@row'
        return false if $party.leader != 'row'
      when '@phy'
        return false if $party.leader != 'phy'

      # Choices
      when '@a', '@b', '@c', '@d'
        return false if label.split(":")[0] != $scene.hud.message.last_choice

      # Randoms
      when '@r1'
        return false if @random != 1
      when '@r2'
        return false if @random != 2
      when '@r3'
        return false if @random != 3
      when '@r4'
        return false if @random != 4
      when '@r5'
        return false if @random != 5
      when '@r6'
        return false if @random != 6
      when '@r7'
        return false if @random != 7


    end

    return true

  end

  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    @page_idx = find_page
    new_page = @pages[@page_idx] if @page_idx != nil
    setup_page(new_page) if new_page != @page
  end

  def is_second?(page)

    return if page == nil

    # DANHAX - check super conditions
    page.list.each{ |line|
  
      if line.code == 108
        comment = line.parameters[0]
        if comment[0] == '?'[0]
          data = comment.split(' ')
          return true if data[0] == '?second'
        end
      end        
    }  

    return false

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
    @trigger = @page.trigger
    @list = @page.list
    @interpreter = nil

    # Do things based on the name
    if @character_name == "!!!"
      @through = true
      @trigger = 1 if @trigger == 0
      if @pattern == 0 && @direction == 2
        @icon = 'T'
      end
    end

    # Change enemy gfx
    if @character_name == "!!!Monster"
      @character_name = "Monsters/#{$battle.enemy_types[@pattern]}"
      @trigger = 2
    end

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

          if @character_name.include?("NPC")
            @character_name = "NPCs/"+@character_name.delete("NPC-")+"/"+data[1]
          end

        when "#prop"
          @character_name = "Props/#{data[1]}"

        when "#animal"
          @character_name = "Animals/#{data[1]}"

        when "#object"
          @character_name = "Objects/#{data[1]}"

        when "#door"
          @character_name = "Doors/#{data[1]}"

        when "#icon"
          @character_name = "Icons/#{data[1]}"

        when '#rand-pattern'
          @force_pattern = rand(3)

        when '#rand-dir'
          @direction = [2,4,6].sample

        when '#ox'
          @off_x = data[1].to_i
        when '#oy'
          @off_y = data[1].to_i

        when '#moblin'
          data.push(1) if data.count < 2
          $scene.add_moblin(self,data[1].to_i)

        when '#disable'
          disable

        when '#fxtrail'
          @fxtrail = data[1]

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

    # If trigger is [parallel process]
    if @trigger == 4
      @interpreter = Interpreter.new
      @interpreter.setup(@list, @event.id)
    end


    # If trigger is [auto run]
    if @trigger == 3 || @event.name == 'AUTORUN'
      start
    end
  end


  def check_event_trigger_touch(x, y)
        
    return false if $map.interpreter.running?
      
    if $player.at?(x,y) and [1,2].include?(@trigger)
      start_battle
    end

  end

  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super

    # Automatic event starting determinant
    check_event_trigger_auto if @starting == false

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