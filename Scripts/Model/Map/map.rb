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
  attr_accessor :cam_x, :cam_y

  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @interpreter = Interpreter.new(0,true)

    @cam_x = 0
    @cam_y = 0

    @cam_target = $player
    @cam_xy = [0,0]
    @cam_snap = true
    @cam_ox = 0
    @cam_oy = 0#-16
    @cam_dur = nil

    #self.do(pingpong("cam_ox",50,70,:quad_in_out))
    #self.do(pingpong("cam_oy",-70,350,:quad_in_out))

    @namecache = {}
  end

  def name
    return @map_name
  end

  def resetup
    @zone = nil
    setup(@id)
    setup_audio
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
    @cam_x = 0
    @cam_y = 0
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
        $scene.change_fogs(@zone.fog)
        $scene.change_tint(@zone.tint)
        $scene.change_panoramas(@zone.panoramas)

        # Prep enemies for this zone
        $battle.change_enemies(@zone.enemies)
        $battle.change_zones(@zone.battles)

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

    # Fadeout previous
    

    # Play music from the zone
    $audio.music(@zone.music)
    $audio.atmosphere(@zone.atmosphere)

  end

  def dispose

  end
  
  def display_x
    # cam_x = @cam_x
    # cam_x = 0 if cam_x < 0
    # w = ($map.width * 128) - ($game.width * 4)
    # cam_x = w if cam_x > w
    return @cam_x + (@cam_ox*4)
  end

  def display_y
    # cam_y = @cam_y
    # cam_y = 0 if cam_y < 0
    # h = ($map.height * 128) - ($game.height * 4)
    # cam_y = h if cam_y > h
    return @cam_y + (@cam_oy*4)
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
  def camera_to(ev,dur=nil)
    @cam_target = ev
    @cam_snap = false
    @cam_dur = dur
  end

  def camera_xy(x,y,dur=nil)
    @cam_xy = [x,y]
    @cam_target = nil
    @cam_snap = false
    @cam_dur=dur
  end

  def camera_moving?
    return !$tweens.done?(self)
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

    if $mouse.y > 448
      $mouse.change_cursor('Default')
      return
    end

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
        when 'U'
          $mouse.change_cursor('Use')
        when 'B'
          $mouse.change_cursor('Battle')
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



    # if @target_x != @display_x
    #   @display_x += [(@target_x-@display_x) * 0.15,cam_speed].min
    # end

    # if @target_y != @display_y
    #   @display_y += [(@target_y-@display_y) * 0.15,cam_speed].min
    # end

    if @cam_target != nil
      new_target_x = @cam_target.real_x- (128 * 9.5)
      new_target_y = @cam_target.real_y- (128 * 7)
    else
      new_target_x = @cam_xy[0] * 64
      new_target_y = @cam_xy[1] * 64
    end


    # If the target has changed
    if !@cam_snap    

      if (new_target_x != @target_x) || (new_target_y != @target_y)

          @target_x = new_target_x
          @target_y = new_target_y

          #@target_x = 0 if @target_x < 0
          #@target_y = 0 if @target_y < 0

          dx = @target_x - @cam_x
          dy = @target_y - @cam_y

          # Check if close
          x_snap = dx.abs < 10
          y_snap = dy.abs < 10

          if !x_snap
            x_snap = true if @cam_x <= 0 && dx < 0
          end

          if !y_snap
            y_snap = true if @cam_x <= 0 && dx < 0
          end

          can_snap = true if x_snap && y_snap
          

          if can_snap

            @cam_x = @target_x
            @cam_y = @target_y
            @cam_snap = true

          else

            # slide it
            $tweens.clear(self)     

            # Compensate for cam_x or cam_y being off screen, that is, jump to 0
            if @cam_x + dx < 0
              dx = -@cam_x
            end

            if @cam_y + dy < 0
              dy = -@cam_y
            end
            

            dur = (dx.abs + dy.abs) / 2
            if @cam_dur != nil
              dur = @cam_dur
              @cam_dur = nil
            end

            # Limit movement if will go off edge of map

            self.do(go("cam_x",dx,dur,:qio))
            self.do(go("cam_y",dy,dur,:qio))


          end

        end

    end

    if @cam_snap

      @cam_x = new_target_x
      @cam_y = new_target_y

    end

    # Limit cam to screen
    # Maybe do this with display_x
    @cam_x = 0 if @cam_x < 0
    @cam_y = 0 if @cam_y < 0

    w = ($map.width * 128) - ($game.width * 4)
    h = (($map.height+1) * 128) - (($game.height) * 4) # Add 32 for bottom bar

    @cam_x = w if @cam_x > w
    @cam_y = h if @cam_y > h

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

  def find_other(name,id)
    @events.values.find{ |e| e.name == name && e.id != id }
  end  

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

  def all_by_name(name)
     return @events.values.select{ |e| e.name == name }
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