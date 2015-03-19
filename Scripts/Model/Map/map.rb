#==============================================================================
# ** Game_Map
#==============================================================================

class Game_Map
  
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :tileset  
  
  # Drawing
  attr_accessor :display_x                # display x-coordinate * 128 # camera pos
  attr_accessor :display_y                # display y-coordinate * 128
  
  # Camera
  attr_accessor :target_x
  attr_accessor :target_y
  attr_accessor :target

  attr_accessor :need_refresh             # refresh request flag
  
  attr_reader   :fog_ox                   # fog x-coordinate starting point
  attr_reader   :fog_oy                   # fog y-coordinate starting point

  
  attr_reader   :map_name                 # name of the map


  attr_reader :interpreter

  attr_reader :id

  # Try to cut this
  attr_reader :events

  # used slackly in world
  attr_accessor :new_tileset
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @id = 0
    @display_x = 0
    @display_y = 0
    @interpreter = Interpreter.new(0,true)
  end
  
  #--------------------------------------------------------------------------
  # * Setup
  #     map_id : map ID
  #--------------------------------------------------------------------------
  def setup(id)
    @new_tileset = true
    
    # Put map ID in @map_id memory
    @id = id
    
    # Load map from file and set @map
    @map = load_data(sprintf("Data/Map%03d.rxdata", @id))
    @map_name = $data.mapinfos[id].name 
        
    # Hold onto the tileset
    @tileset = $data.tilesets[@map.tileset_id]
        
    @passages = @tileset.passages 
    @priorities = @tileset.priorities
    @terrain_tags = @tileset.terrain_tags
    
    # Initialize displayed coordinates
    @display_x = 0
    @display_y = 0

    @target_x = 0
    @target_y = 0

    # Camera
    @target = nil
    
    @need_refresh = false
    
    # Set map event data
    @events = {}
    for i in @map.events.keys
      @events[i] = Game_Event.new(@map.events[i])
    end
    
    # Initialize all fog information
    @fog_ox = 0
    @fog_oy = 0
    @fog_opacity_duration = 0
    @fog_opacity_target = 0
        
    # Clear player path for mouse pathfinding
    $player.clear_path
    
  end

  #--------------------------------------------------------------------------
  # * Get Tileset ID
  #--------------------------------------------------------------------------
  def tileset_id() return @map.tileset_id end
  def width() return @map.width end
  def height() return @map.height end
  def data() return @map.data end
  
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
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    @events.values.each{ |e| e.refresh }
    @need_refresh = false
  end

  #--------------------------------------------------------------------------
  # * Determine if Passable
  #--------------------------------------------------------------------------
  def passable?(x, y, d, self_event = nil)

    return false unless valid?(x, y)

    # Change direction (0,2,4,6,8,10) to obstacle bit (0,1,2,4,8,0)
    bit = (1 << (d / 2 - 1)) & 0x0f

    # Loop searches in order from top of layer
    [2, 1, 0].each{ |i|

      tile_id = data[x, y, i]

      # If obstacle bit is set
      return false if @passages[tile_id] & bit != 0
        
      # If obstacle bit is set in all directions
      return false if @passages[tile_id] & 0x0f == 0x0f
        
      # If priorities other than that are 0
      return true if @priorities[tile_id] == 0

    }

    # passable
    return true

  end

  #--------------------------------------------------------------------------
  # * Determine Thicket

  #--------------------------------------------------------------------------
  def bush?(x, y) ![0,1,2].select{ |i| @passages[data[x,y,i]] & 0x40 == 0x40 }.empty? end
  def counter?(x, y) ![0,1,2].select{ |i| @passages[data[x,y,i]] & 0x80 == 0x80 }.empty? end

  def terrain_tag(x, y)
    [2,1,0].each{ |i| return @terrain_tags[data[x, y, i]] if data[x, y, i] != nil }
    return 0
  end

  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update

    @interpreter.update

    # Refresh map if necessary
    refresh if $map.need_refresh

    # Camera update, maybe split to camera class
    @target = $player if @target == nil

    if @target != nil
    @target_x = @target.real_x- (128 * 9.5)
    @target_y = @target.real_y- (128 * 7)

    if @target_x > @display_x
      @display_x += (@target_x-@display_x) * 0.2
    end
    if @target_x < @display_x
      @display_x -= (@display_x-@target_x) * 0.2
    end

    if @target_y > @display_y
      @display_y += 3
    end
    if @target_y < @display_y
      @display_y -= 3
    end

  end

    # Anti lag here
    @events.values.each{ |e| e.update }
    
    # Manage fog scrolling
   # @fog_ox -= @fog_sx / 8.0
   # @fog_oy -= @fog_sy / 8.0
    
    # # Manage change in fog opacity level
    # if @fog_opacity_duration >= 1
    #   d = @fog_opacity_duration
    #   @fog_opacity = (@fog_opacity * (d - 1) + @fog_opacity_target) / d
    #   @fog_opacity_duration -= 1
    # end

  end
  
  def valid?(x, y) x >= 0 and x < width and y >= 0 and y < height end

  #--------------------------------------------------------------------------
  # * Event At
  #--------------------------------------------------------------------------
  def event_at(x, y) @events.values.find{ |e| e.at?(x,y) } end
  def events_at(x, y) @events.values.select{ |e| e.at?(x,y) } end
  def lowest_event_at(x, y) events_at(x,y).min_by{ |e| e.y } end

  def starting_events() @events.values.select{ |e| e.starting } end

end
