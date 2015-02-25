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
  attr_reader   :name                     # agf - name of event
  attr_reader   :pages                    # shaz - for monster loot
  
  # for mouse system
  attr_reader   :erased
  attr_accessor :mouse_autostart
  attr_accessor :mouse_cursor_icon
  attr_accessor :mouse_cursor_desc
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     map_id : map ID
  #     event  : event (RPG::Event)
  #--------------------------------------------------------------------------
  def initialize(map_id, event)
    super()
    @map_id = map_id
    
    # Check for cloned event
    clone_map = nil
    clone_event = nil
    if event && event.pages[0].list != nil && event.pages[0].list[0].code == 108
      event.pages[0].list[0].parameters.to_s.downcase.gsub!(/clone (.*) (.*)/) do
        clone_map = $1.to_i
        clone_event = $2.to_i
      end
    end
    @event = event
    if clone_map != nil && clone_event != nil
      e = $game_temp.clone_event(clone_map, clone_event)
      @event.id = event.id
      @event.name = event.name
      @event.x = event.x
      @event.y = event.y
      @event.pages = Array.new(e.pages)
    end
    
    @id = event.id # @event.id
    @event.id = event.id
    @erased = false
    @starting = false
    @through = true
    @name = event.name # agf init name # @event.name
    @pages = @event.pages 
    
    # New savelocs
    # if !$game_system.event_positions.has_key?([map_id, @id])
      moveto(@event.x, @event.y)
    # else
    #   mvx, mvy, mvdir = $game_system.event_positions[[map_id, @id]]
    #   moveto(mvx, mvy)
    #   @direction = mvdir if mvdir != nil
    #   @stop_count = 0
    # end


    refresh
  end
  #--------------------------------------------------------------------------
  # * Clear Starting Flag
  #--------------------------------------------------------------------------
  def clear_starting
    @starting = false
  end
  #--------------------------------------------------------------------------
  # * Determine if Over Trigger
  #    (whether or not same position is starting condition)
  #--------------------------------------------------------------------------
  def over_trigger?
    # If not through situation with character as graphic
    if @character_name != "" and not @through
      # Starting determinant is face
      return false
    end
    # If this position on the map is impassable
    unless $game_map.passable?(@x, @y, 0)
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
    #clear the name message box
    $game_system.name = ""
    # If list of event commands is not empty
    if @list && @list.size > 1
      @starting = true
    end
  end
  #--------------------------------------------------------------------------
  # * Temporarily Erase
  #--------------------------------------------------------------------------
  def erase
    @erased = true
    refresh
  end
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    # Initialize local variable: new_page
    new_page = nil
    
    # If not temporarily erased
    unless @erased
      # Check in order of large event pages
      for page in @event.pages.reverse
        
        condition_failed = false
        
        # DANHAX - check super conditions
        page.list.each{ |line|
      
          if line.code == 108
            comment = line.parameters[0]
            if comment[0] == '?'[0]
              data = comment.split(' ')
              if !condition_applies?(data)
                condition_failed = true
                break
              end
            end
          end
        
        }  
        
        next if condition_failed
        
        # If survived then switch the page
        
        # Set local variable: new_page
        new_page = page
        # Remove loop
        break
      end
    end
    
    setup_new_page(new_page)
    
  end
  
  def setup_new_page(new_page)
        # If event page is the same as last time
    if new_page == @page
      # End method
      return
    end
    # Set @page as current event page
    @page = new_page
    # Clear starting flag
    clear_starting
    # If no page fulfills conditions
    if @page == nil
      # Set each instance variable
      @tile_id = 0
      @character_name = ""
      @character_hue = 0
      @move_type = 0
      @through = true
      @trigger = nil
      @list = nil
      @interpreter = nil
      # End method
      return
    end
    # Set each instance variable
    @tile_id = @page.graphic.tile_id
    @character_name = @page.graphic.character_name
    @character_hue = @page.graphic.character_hue
    if @original_direction != @page.graphic.direction
      @direction = @page.graphic.direction
      @original_direction = @direction
      @prelock_direction = 0
    end
    if @original_pattern != @page.graphic.pattern
      @pattern = @page.graphic.pattern
      @original_pattern = @pattern
    end
    @opacity = @page.graphic.opacity
    @blend_type = @page.graphic.blend_type
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
    @always_on_top = @page.always_on_top
    @trigger = @page.trigger
    @list = @page.list
    @interpreter = nil
    # If trigger is [parallel process]
    if @trigger == 4
      # Create parallel process interpreter
      @interpreter = Interpreter.new
    end
    # Auto event start determinant
    check_event_trigger_auto
    
    # Set up mouse variables
    @mouse_autostart = [0, 1, 2].include?(@trigger)
    @mouse_cursor_icon = MouseCursor::Event_Cursor
    @mouse_cursor_desc = nil
  end
  
  
  
  #--------------------------------------------------------------------------
  # * Touch Event Starting Determinant
  #--------------------------------------------------------------------------
  def check_event_trigger_touch(x, y)
    # If event is running
    if $game_system.map_interpreter.running?
      return
    end
    # If trigger is [touch from event] and consistent with player coordinates
    if @trigger == 2 and x == $game_player.x and y == $game_player.y
      # If starting determinant other than jumping is front event
      if not jumping? and not over_trigger?
        start
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Automatic Event Starting Determinant
  #--------------------------------------------------------------------------
  def check_event_trigger_auto
    # If trigger is [touch from event] and consistent with player coordinates
    if @trigger == 2 and @x == $game_player.x and @y == $game_player.y
      # If starting determinant other than jumping is same position event
      if not jumping? and over_trigger?
        start
      end
    end
    # If trigger is [auto run]
    if @trigger == 3
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
      # If not running
      unless @interpreter.running?
        # Set up event
        @interpreter.setup(@list, @event.id)
      end
      # Update interpreter
      @interpreter.update
    end
  end
    
  #--------------------------------------------------------------------------
  # * Save Position
  #--------------------------------------------------------------------------
  def save_pos(x = @x, y = @y, dir = @direction)
    $game_system.event_positions[[$game_map.map_id, @event.id]] = [x, y, dir]
  end
    
  #--------------------------------------------------------------------------
  # * Forget Position
  #--------------------------------------------------------------------------
  def forget_pos
    $game_system.event_positions.delete([$game_map.map_id, @event.id])
  end
end
