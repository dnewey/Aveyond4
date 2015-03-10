#==============================================================================
# ** Game_Map
#==============================================================================

# class RPG::Tileset
#   def passages
#     return flags
#   end
# end


class Game_Map
  
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :tileset  
  
  # keep these
  attr_reader   :passages                 # passage table
  attr_reader   :priorities               # prioroty table
  attr_reader   :terrain_tags             # terrain tag table
    
  attr_accessor :display_x                # display x-coordinate * 128
  attr_accessor :display_y                # display y-coordinate * 128
  attr_accessor :need_refresh             # refresh request flag
  
  attr_reader   :events                   # events
  
  attr_reader   :fog_ox                   # fog x-coordinate starting point
  attr_reader   :fog_oy                   # fog y-coordinate starting point
  attr_reader   :fog_tone                 # fog color tone
  
  
  attr_reader   :map_name                 # name of the map
    
  attr_accessor :transition_processing    # transition processing flag
  attr_accessor :transition_name          # transition file name
  
  attr_accessor :new_tileset

  attr_reader :interpreter
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @map_id = 0
    @display_x = 0
    @display_y = 0

    @interpreter = Interpreter.new(0,true)
  end

  def id
    return @map_id
  end
  
  #--------------------------------------------------------------------------
  # * Setup
  #     map_id : map ID
  #--------------------------------------------------------------------------
  def setup(map_id)
    @new_tileset = true
    
    # Put map ID in @map_id memory
    @map_id = map_id
    
    # Load map from file and set @map
    @map = load_data(sprintf("Data/Map%03d.rxdata", @map_id))
    @map_name = $data.mapinfos[map_id].name 
        
    # Hold onto the tileset
    @tileset = $data.tilesets[@map.tileset_id]
        
    @passages = @tileset.passages 
    @priorities = @tileset.passages#@tileset.priorities
    @terrain_tags = @tileset.passages#@tileset.terrain_tags
    
    # Initialize displayed coordinates
    @display_x = 0
    @display_y = 0
    
    # Clear refresh request flag
    @need_refresh = false
    
    # Set map event data
    @events = {}
    for i in @map.events.keys
      @events[i] = Game_Event.new(@map.events[i])
    end
    
    # Initialize all fog information
    @fog_ox = 0
    @fog_oy = 0
    @fog_tone = Tone.new(0, 0, 0, 0)
    @fog_tone_target = Tone.new(0, 0, 0, 0)
    @fog_tone_duration = 0
    @fog_opacity_duration = 0
    @fog_opacity_target = 0
    
    # Initialize scroll information
    @scroll_direction = 2
    @scroll_rest = 0
    @scroll_speed = 4
        
    # Clear player path for mouse pathfinding
    #$player.clear_path
    
  end

  #--------------------------------------------------------------------------
  # * Get Tileset ID
  #--------------------------------------------------------------------------
  def tileset_id
    return @map.tileset_id
  end

  #--------------------------------------------------------------------------
  # * Get Map ID
  #--------------------------------------------------------------------------
  def map_id
    return @map_id
  end

  #--------------------------------------------------------------------------
  # * Get Width
  #--------------------------------------------------------------------------
  def width
    return @map.width
  end

  #--------------------------------------------------------------------------
  # * Get Height
  #--------------------------------------------------------------------------
  def height
    return @map.height
  end
  
  #--------------------------------------------------------------------------
  # * Get Map Data
  #--------------------------------------------------------------------------
  def data
    return @map.data
  end
  
  #--------------------------------------------------------------------------
  # * Automatically Change Background Music and Backround Sound
  #--------------------------------------------------------------------------
  def autoplay
    # Zones!
    if @map.autoplay_bgm
      $game_system.bgm_play(@map.bgm)
    end
    if @map.autoplay_bgs
      $game_system.bgs_play(@map.bgs)
    end
  end

  #--------------------------------------------------------------------------
  # * Automatically Change Background Music and Backround Sound
  #--------------------------------------------------------------------------
  def autoplay_bgs
      $game_system.bgs_play(@map.bgs)
  end  
  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    # If map ID is effective
    if @map_id > 0
      # Refresh all map events
      for event in @events.values
        event.refresh
      end
    end

    # Clear refresh request flag
    @need_refresh = false
  end
  
  #--------------------------------------------------------------------------
  # * Scroll Down
  #     distance : scroll distance
  #--------------------------------------------------------------------------
  def scroll_down(distance)
    # agf - changed 15 to 14.  Determines bottom of map.
    @display_y = [@display_y + distance, (self.height - 14) * 128].min
  end

  #--------------------------------------------------------------------------
  # * Scroll Left
  #     distance : scroll distance
  #--------------------------------------------------------------------------
  def scroll_left(distance)
    @display_x = [@display_x - distance, 0].max
  end

  #--------------------------------------------------------------------------
  # * Scroll Right
  #     distance : scroll distance
  #--------------------------------------------------------------------------
  def scroll_right(distance)
    @display_x = [@display_x + distance, (self.width - 20) * 128].min
  end
  #--------------------------------------------------------------------------
  # * Scroll Up
  #     distance : scroll distance
  #--------------------------------------------------------------------------
  def scroll_up(distance)
    @display_y = [@display_y - distance, 0].max
  end

  #--------------------------------------------------------------------------
  # * Determine Valid Coordinates
  #     x          : x-coordinate
  #     y          : y-coordinate
  #--------------------------------------------------------------------------
  def valid?(x, y)
    return (x >= 0 and x < width and y >= 0 and y < height)
  end

  #--------------------------------------------------------------------------
  # * Determine if Passable
  #     x          : x-coordinate
  #     y          : y-coordinate
  #     d          : direction (0,2,4,6,8,10)
  #                  *  0,10 = determine if all directions are impassable
  #     self_event : Self (If event is determined passable)
  #--------------------------------------------------------------------------
  def passable?(x, y, d, self_event = nil)
    # If coordinates given are outside of the map
    unless valid?(x, y)
      # impassable
      return false
    end
    # Change direction (0,2,4,6,8,10) to obstacle bit (0,1,2,4,8,0)
    bit = (1 << (d / 2 - 1)) & 0x0f
    # Loop in all events
    for event in events.values
      # If tiles other than self are consistent with coordinates
      if event.tile_id >= 0 and event != self_event and
         event.x == x and event.y == y and not event.through
        # If obstacle bit is set
        if @passages[event.tile_id] & bit != 0
          # impassable
          return false
        # If obstacle bit is set in all directions
        elsif @passages[event.tile_id] & 0x0f == 0x0f
          # impassable
          return false
        # If priorities other than that are 0
        elsif @priorities[event.tile_id] == 0
          # passable
          return true
        end
      end
    end
    # Loop searches in order from top of layer
    for i in [2, 1, 0]
      # Get tile ID
      tile_id = data[x, y, i]
      # Tile ID acquistion failure
      if tile_id == nil
        # impassable
        return false
      # If obstacle bit is set
      elsif @passages[tile_id] & bit != 0
        # impassable
        return false
      # If obstacle bit is set in all directions
      elsif @passages[tile_id] & 0x0f == 0x0f
        # impassable
        return false
      # If priorities other than that are 0
      elsif @priorities[tile_id] == 0
        # passable
        return true
      end
    end
    # passable
    return true
  end

  #--------------------------------------------------------------------------
  # * Determine Thicket
  #     x          : x-coordinate
  #     y          : y-coordinate
  #--------------------------------------------------------------------------
  def bush?(x, y)
    if @map_id != 0
      for i in [2, 1, 0]
        tile_id = data[x, y, i]
        if tile_id == nil
          return false
        elsif @passages[tile_id] & 0x40 == 0x40
          return true
        end
      end
    end
    return false
  end

  #--------------------------------------------------------------------------
  # * Determine Counter
  #     x          : x-coordinate
  #     y          : y-coordinate
  #--------------------------------------------------------------------------
  def counter?(x, y)
    if @map_id != 0
      for i in [2, 1, 0]
        tile_id = data[x, y, i]
        if tile_id == nil
          return false
        elsif @passages[tile_id] & 0x80 == 0x80
          return true
        end
      end
    end
    return false
  end

  #--------------------------------------------------------------------------
  # * Get Terrain Tag
  #     x          : x-coordinate
  #     y          : y-coordinate
  #--------------------------------------------------------------------------
  def terrain_tag(x, y)
    if @map_id != 0
      for i in [2, 1, 0]
        tile_id = data[x, y, i]
        if tile_id == nil
          return 0
        elsif tile_id > 0   # @terrain_tags[tile_id] > 0
          return @terrain_tags[tile_id]
        end
      end
    end
    return 0
  end

  #--------------------------------------------------------------------------
  # * Get Designated Position Event ID
  #     x          : x-coordinate
  #     y          : y-coordinate
  #--------------------------------------------------------------------------
  def check_event(x, y)
    for event in $map.events.values
      if event.x == x and event.y == y
        return event.id
      end
    end
  end

  #--------------------------------------------------------------------------
  # * Start Scroll
  #     direction : scroll direction
  #     distance  : scroll distance
  #     speed     : scroll speed
  #--------------------------------------------------------------------------
  def start_scroll(direction, distance, speed)
    @scroll_direction = direction
    @scroll_rest = distance * 128
    @scroll_speed = speed
  end
  
  #--------------------------------------------------------------------------
  # * Determine if Scrolling
  #--------------------------------------------------------------------------
  def scrolling?
    return @scroll_rest > 0
  end


  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update

    @interpreter.update

    # GET IT WORKING BETTER
    #return

    # Refresh map if necessary
    if $map.need_refresh
      refresh
    end
    # If scrolling
    if @scroll_rest > 0
      # Change from scroll speed to distance in map coordinates
      distance = 2 ** @scroll_speed
      # Execute scrolling
      case @scroll_direction
      when 2  # Down
        scroll_down(distance)
      when 4  # Left
        scroll_left(distance)
      when 6  # Right
        scroll_right(distance)
      when 8  # Up
        scroll_up(distance)
      end
      # Subtract distance scrolled
      @scroll_rest -= distance
    end
    # Update map event
    for event in @events.values
      # event must be in range to be updated (anti-lag)
      #if (event.inrange_map and event.event.name != ANTI_LAG_EVENT_NAME) or
      #  [3,4].include?event.trigger
        event.update
      #end
    end
    
    # Manage fog scrolling
   # @fog_ox -= @fog_sx / 8.0
   # @fog_oy -= @fog_sy / 8.0
    
    # Manage change in fog color tone
    # if @fog_tone_duration >= 1
    #   d = @fog_tone_duration
    #   target = @fog_tone_target
    #   @fog_tone.red = (@fog_tone.red * (d - 1) + target.red) / d
    #   @fog_tone.green = (@fog_tone.green * (d - 1) + target.green) / d
    #   @fog_tone.blue = (@fog_tone.blue * (d - 1) + target.blue) / d
    #   @fog_tone.gray = (@fog_tone.gray * (d - 1) + target.gray) / d
    #   @fog_tone_duration -= 1
    # end
    # # Manage change in fog opacity level
    # if @fog_opacity_duration >= 1
    #   d = @fog_opacity_duration
    #   @fog_opacity = (@fog_opacity * (d - 1) + @fog_opacity_target) / d
    #   @fog_opacity_duration -= 1
    # end
  end
  
  #--------------------------------------------------------------------------
  # * Event At
  #--------------------------------------------------------------------------
  def event_at(x, y)
    for event in @events.values
        return event if (event.x == x && event.y == y) or
          (event.x == x && event.y == y + 1 && 
          RPG::Cache.character(event.character_name, event.character_hue).height / 4 > 32)
    end
    return nil
  end
  
  #--------------------------------------------------------------------------
  # * Events At (returns multiple events at the same position in an array)
  #--------------------------------------------------------------------------
  def events_at(x, y)
    eventarray = []
    for event in @events.values
      eventarray.push event if (event.x == x && event.y == y) or
        (event.x == x && event.y == y + 1 && 
        RPG::Cache.character(event.character_name, event.character_hue).height / 4 > 32)
    end
    return eventarray if eventarray.size > 0
    return nil
  end
  #--------------------------------------------------------------------------
  # * Lowest Event At (returns frontmost sprite at mouse position)
  #--------------------------------------------------------------------------
  def lowest_event_at(x, y)
    evt = nil
    for event in @events.values
      if (event.x == x && event.y == y) or
        (event.x == x && event.y == y + 1 && 
        RPG::Cache.character(event.character_name, event.character_hue).height / 4 > 32)
        if evt == nil || event.y > evt.y
          evt = event
        end
      end
    end
    return evt
  end

end
