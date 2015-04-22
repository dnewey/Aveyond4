#==============================================================================
# ** Game_Map
#==============================================================================

class Game_Map

  # Keep the zone? 
  
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :tileset  
  
  # Drawing
  attr_accessor :display_x                # display x-coordinate * 128 # camera pos
  attr_accessor :display_y                # display y-coordinate * 128
  attr_accessor :target

  attr_accessor :need_refresh             # refresh request flag

  attr_reader   :map_name                 # name of the map

  attr_reader :interpreter

  attr_reader :id

  # Try to cut this
  attr_reader :events

  attr_reader :map

  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @interpreter = Interpreter.new(0,true)
  end
  
  #--------------------------------------------------------------------------
  # * Setup
  #     map_id : map ID
  #--------------------------------------------------------------------------
  def setup(id)
    
    # Put map ID in @map_id memory
    @id = id
    
    # Load map from file and set @map
    @map = load_data(sprintf("Data/Map%03d.rxdata", @id))
    @map_name = $data.mapinfos[id].name 
        
    # Hold onto the tileset
    @tileset = $data.tilesets[@map.tileset_id]        
    @passages = @tileset.passages 
    
    # Initialize displayed coordinates
    @display_x = 0
    @display_y = 0
    @target = nil
    
    @need_refresh = false
    
    # Set map event data
    @events = {}
    @map.events.keys.each{ |i|
      @events[i] = Game_Event.new(@map.events[i])
    }

    # Disregard if battle map? or use battle zone?
    # Or various battle zones?

    # What is the zone
    autoplay = false
    newzone = get_zone(@id)
    if newzone != @zone.id

      @zone = $data.zones[newzone]
      log_info "Changing Zone: #{newzone}"

      if @zone.id == "@clear"
        $audio.bgm_stop
        $audio.bgs_stop
        autoplay = true
      elsif @zone.id == "@nil"
        # Play nothing do nothing
        autoplay = true
      else
        # Play music from the zone
        $audio.play(@zone.bgm)
        $audio.play(@zone.bgs)
        # Init tints and that
      end

    end
    
    # If a null or clear zone
    if autoplay
      $audio.bgm_play(@map.bgm) if @map.autoplay_bgm
      $audio.bgs_play(@map.bgs) if @map.autoplay_bgs
    end
    
  end

  #--------------------------------------------------------------------------
  # * Get Tileset ID
  #--------------------------------------------------------------------------
  def tileset_id() return @map.tileset_id end
  def width() return @map.width end
  def height() return @map.height end
  def data() return @map.data end

  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update

    @interpreter.update

    # Anti lag here
    @events.values.each{ |e| e.update }

    # Refresh map if necessary
    if @need_refresh
      @events.values.each{ |e| e.refresh }
      @need_refresh = false
    end

    # Camera update
    @target = $player

    # Camera update, maybe split to camera class
    if @target != nil

      @target_x = @target.real_x- (128 * 9.5)
      @target_y = @target.real_y- (128 * 7)

      if @target_x != @display_x
        @display_x += (@target_x-@display_x) * 0.5
      end

      if @target_y != @display_y
        @display_y += (@target_y-@display_y) * 0.5
      end

      @display_x = @target_x
      @display_y = @target_y

    end

    # Limit cam to screen
    @display_x = 0 if @display_x < 0
    @display_y = 0 if @display_y < 0

    w = ($map.width * 32) - $game.width
    h = ($map.height * 32) - $game.height

    #@display_x = w if @display_x > w
    #@display_y = w if @display_y > h



  end

  #--------------------------------------------------------------------------
  # * Determine if Passable
  #--------------------------------------------------------------------------
  def passable?(x, y, d, self_event = nil)

    return false unless valid?(x, y)

    # Change direction (0,2,4,6,8,10) to obstacle bit (0,1,2,4,8,0)
    bit = (1 << (d / 2 - 1)) & 0x0f

    # Loop in all events
    events.values.each{ |e| 
      if e != self_event and e.at?(x,y)
         return false if !(e.through || e.above || e.below)
      end
    }

    # Loop searches in order from top of layer
    [2, 1, 0].each{ |i|

      tile_id = data[x, y, i]

      # If obstacle bit is set
      return false if @passages[tile_id] & bit != 0
        
      # If obstacle bit is set in all directions
      return false if @passages[tile_id] & 0x0f == 0x0f
        
      # If priorities other than that are 0
      return true if @tileset.priorities[tile_id] == 0

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
    [2,1,0].each{ |i| return @tileset.terrain_tags[data[x, y, i]] if data[x, y, i] != nil }
    return 0
  end

  #--------------------------------------------------------------------------
  # * Event At
  #--------------------------------------------------------------------------
  def valid?(x, y) x >= 0 and x < width and y >= 0 and y < height end
  def event_at(x, y) @events.values.find{ |e| e.at?(x,y) } end
  def events_at(x, y) @events.values.select{ |e| e.at?(x,y) } end
  def lowest_event_at(x, y) nil end #events_at(x,y).min_by{ |e| e.y } end
  def starting_events() @events.values.select{ |e| e.starting } end

  def event_by_name(name)
    @events.values.find{ |e| e.event.name == name }
  end

  #--------------------------------------------------------------------------
  # Find the zone name for this map
  #--------------------------------------------------------------------------
  def get_zone(id)
    return $data.mapinfos[id].name if $data.mapinfos[id].name.include?('@')
    return map_zone_or_nil(id)
  end

  def map_zone_or_nil(id)
    return $data.mapinfos[id].name if $data.mapinfos[id].name.include?('@')
    return '@nil' if $data.mapinfos[id].parent_id == 0
    return map_zone_or_nil($data.mapinfos[id].parent_id)
  end

end