#==============================================================================
# ** Game_Map
#==============================================================================

class Game_Map

  # Keep the zone? 
  
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :tileset  
  
  # Camera offsets
  attr_accessor :cam_ox, :cam_oy


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

    @cam_target = $player
    @cam_xy = [0,0]
    @cam_snap = false
    @cam_ox = 0
    @cam_oy = 0#-16
    @cam_speed = 'mid'

    #self.do(pingpong("cam_ox",50,70,:quad_in_out))
    #self.do(pingpong("cam_oy",-70,350,:quad_in_out))

    @namecache = {}
  end

  def cam_speed
    case @cam_speed
      when 'slow'
        return 10
      when 'mid'
        return 20
      when 'fast'
        return 30
    end
    return 50
  end

  def name
    return @map_name
  end
  
  #--------------------------------------------------------------------------
  # * Setup
  #     map_id : map ID
  #--------------------------------------------------------------------------
  def setup(id)
    
    # Put map ID in @map_id memory
    @id = id
    @namecache = {} # reset each map
    
    # Load map from file and set @map
    @map = load_data(sprintf("Data/Map%03d.rxdata", @id))
    @map_name = $data.mapinfos[id].name 
        
    # Hold onto the tileset
    @tileset = $data.tilesets[@map.tileset_id]        
    @passages = @tileset.passages 
    
    # Initialize displayed coordinates
    @display_x = 0
    @display_y = 0
    @target = $player
    
    @need_refresh = false
    

        # Disregard if battle map? or use battle zone?
    # Or various battle zones?

    # What is the zone
    autoplay = false
    newzone = get_zone(@id)
    newzone = "@" + newzone.split("@")[1]
    if newzone != @zone.id

      @zone = $data.zones[newzone]

      log_info "Changing Zone: #{newzone}"


      if @zone.id == "@clear"
        $audio.bgm_stop
        $audio.bgs_stop
        autoplay = true
      elsif @zone.id == "@nil" || @zone == nil
        # Don't change anything
        # Load the map music if you like
        autoplay = true
      else

        
        $audio.change_mode(@zone.reverb)

        # Init tints and that
        $scene.change_weather(@zone.weather)
        $scene.change_fog(@zone.fog)
        $scene.change_tint(@zone.tint)
        $scene.change_panoramas(@zone.panoramas)

        # Prep enemies for this zone
        $battle.change_enemies(@zone.enemies)

      end

    end
    
    # If a null or clear zone
    if autoplay
      $audio.bgm_play(@map.bgm) if @map.autoplay_bgm
      $audio.bgs_play(@map.bgs) if @map.autoplay_bgs
    end

        # Set map event data
    @events = {}
    @map.events.keys.each{ |i|
      @events[i] = Game_Event.new(@map.events[i])
    }

  end

  def setup_audio

    # Play music from the zone
    $audio.music(@zone.music)
    $audio.atmosphere(@zone.atmosphere)

  end
  
  def display_x
    return @display_x + (@cam_ox*4)
  end

  def display_y
    return @display_y + (@cam_oy*4)
  end

  #--------------------------------------------------------------------------
  # * Get Tileset ID
  #--------------------------------------------------------------------------
  def tileset_id() return @map.tileset_id end
  def width() return @map.width end
  def height() return @map.height end
  def data() return @map.data end

  #--------------------------------------------------------------------------
  # * Camera
  #--------------------------------------------------------------------------
  def camera_to(ev,spd=0.15)
    @cam_target = ev
    @cam_snap = false
    @cam_speed = spd
  end

  def camera_xy(x,y,spd=0.15)
    @cam_xy = [x,y]
    @cam_target = nil
    @cam_snap = false
    @cam_speed = spd
  end

  def camera_snap
    @cam_snap = true
  end

  def refresh
    @events.values.each{ |e| e.refresh }
      @need_refresh = false
    end

  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update

    update_camera

    @interpreter.update
    return if $scene.is_a?(Scene_Menu)

    # Anti lag here
    @events.values.each{ |e| e.update }

    # Refresh map if necessary
    if @need_refresh
      @events.values.each{ |e| e.refresh }
      @need_refresh = false
    end

    # Mouse update
    # Check what's under, change cursor etc etc, maybe not every frame? only if moving?
    update_mouse

    

  end

  def update_mouse

    # Mouse position
    mx, my = *$mouse.grid

    # What event is there
    if event_at(mx,my) != nil

      ev = event_at(mx,my)
      case ev.icon

        when 'S'
          $mouse.change_cursor('Speak')
        when 'I'
          $mouse.change_cursor('Inspect')
        when 'T'
          $mouse.change_cursor('Transfer')
        else
          $mouse.change_cursor('Default')

      end

    else
      if $map.passable?(mx,my,$player.direction)
        $mouse.change_cursor('Default')
      else
        $mouse.change_cursor('Battle')
      end
    end

  end

  def update_camera

    if @cam_target != nil
      @target_x = @cam_target.real_x- (128 * 9.5)
      @target_y = @cam_target.real_y- (128 * 7)
    else
      @target_x = @cam_xy[0] * 64
      @target_y = @cam_xy[1] * 64
    end

    # if @target_x != @display_x
    #   @display_x += [(@target_x-@display_x) * 0.15,cam_speed].min
    # end

    # if @target_y != @display_y
    #   @display_y += [(@target_y-@display_y) * 0.15,cam_speed].min
    # end

    # calc dx and dx
    dx = @target_x - @display_x
    dy = @target_y - @display_y

    dist = dx+dy

    # calc ratio
    if (dx - dy).abs < 5
      r = 0.5
    else
      if dy == 0
        r = 1
      else
        r = dx/dy
      end
    end

    # Limit
    dist *= 0.15
    dist = 40 if dist > 40

    # move by speed
    sx = dist * r 
    sy = dist * (1-r)

    @display_x += sx
    @display_y += sy


    if (dx) < 5 && (dx) < 5
      #@cam_snap = true
      @display_x = @target_x
      @display_y = @target_y
    end

    # if @cam_snap
       @display_x = @target_x
       @display_y = @target_y
    # end


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
  def bush?(x, y) return false
   ![0,1,2].select{ |i| @passages[data[x,y,i]] & 0x40 == 0x40 }.empty? end
  def counter?(x, y) ![0,1,2].select{ |i| @passages[data[x,y,i]] & 0x80 == 0x80 }.empty? end
  def terrain_tag(x, y)

    if @map_id != 0
      for i in [2, 1, 0]
        tile_id = data[x, y, i]
        if tile_id == nil
          return 0
        elsif tile_id > 0   # @terrain_tags[tile_id] > 0
          return @tileset.terrain_tags[tile_id]
        end
      end
    end
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
    return @namecache[name] if @namecache.has_key?(name)
    ev = @events.values.find{ |e| e.name == name }
    @namecache[name] = ev
    return ev
  end

  def event_by_evname(name)
    return @namecache[name] if @namecache.has_key?(name)
    ev = @events.values.find{ |e| e.event.name == name }
    @namecache[name] = ev
    return ev
  end

  #--------------------------------------------------------------------------
  # Find the zone name for this map
  #--------------------------------------------------------------------------
  def get_zone(id)
    return $data.mapinfos[id].name if $data.mapinfos[id].name.include?('@')
    return map_zone_or_nil(id)
  end

  # Return zone name, parent map or @nil if top map
  def map_zone_or_nil(id)
    return $data.mapinfos[id].name if $data.mapinfos[id].name.include?('@')
    return '@nil' if $data.mapinfos[id].parent_id == 0
    return map_zone_or_nil($data.mapinfos[id].parent_id)
  end

end