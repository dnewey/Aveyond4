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

  attr_reader :events
  attr_reader :map
  attr_reader :zone
  attr_accessor :cam_x, :cam_y

  attr_accessor :skip_music_change

  attr_reader :zone


  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize()

    @id = nil

    @interpreter = Interpreter.new(0,true)

    @cam_x = 0
    @cam_y = 0

    @cam_target = $player
    @cam_xy = [0,0]
    @cam_snap = true
    @cam_ox = 0
    @cam_oy = 0#-16
    @cam_dur = nil

    @cam_hy = 0 # Hiding

    @force_terrains = {}

    #self.do(pingpong("cam_ox",50,70,:quad_in_out))
    #self.do(pingpong("cam_oy",-70,350,:quad_in_out))

    @namecache = {}
    @ev_cache = {}

  end

  def name
    return @map_name
  end

  def nice_name
    name = @map_name
    if ['Indoor','Indoor2','Cave','Cave2'].include?(@map_name.split("#")[0].split("@")[0].rstrip)
      # Parent name
      name = find_parent_name(@id)
    end

    # Force rename from zone
    if @zone.rename != '' && @zone.rename != nil
      name = @zone.rename
    end

    return name.split("#")[0].split("@")[0]
  end

  def resetup
    @zone = nil
    setup(@id)
    setup_audio
  end

  def hide
    @cam_hy = 50000
  end

  def show
    @cam_hy = 0
  end
  
  #--------------------------------------------------------------------------
  # * Setup
  #     map_id : map ID
  #--------------------------------------------------------------------------
  def setup(id)

    # If there was an old map, save the locs
    if @id != nil
      @events.values.each{ |e|
        next if !e.save
        $state.loc(e.id)
      }
      $scene.clear_sparks
    end
 
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

    # if @map_name == 'Indoor'
    #   newzone = '@indoor'
    # end

    if newzone != @zone.id

      #$audio.minimize

      @zone = $data.zones[newzone]

      log_info "Changing Zone: #{newzone}"


      if @zone != nil
        
        $audio.change_mode(@zone.reverb)

        # Init tints and that
        $scene.change_weather(@zone.weather)
        $scene.change_fogs(@zone.fog)
        $scene.change_overlay(@zone.overlay)
        $scene.change_panoramas(@zone.panoramas)

        # Prep enemies for this zone
        $battle.change_enemies(@zone.enemies)
        $battle.change_maps(@zone.battles)

      end

    end

    # Always do overlay change
    $scene.change_overlay(@zone.overlay)

    # Clear forced terrains
    @force_terrains.clear
    $audio.clear_env

    # Set map event data
    @events = {}
    @map.events.keys.each{ |i|

      # Don't respawn
      next if $state.nospawn?(i)

      @events[i] = Game_Event.new(@map.events[i])

      # if @events[i].name == "STAIRS"
      #   @force_terrains[[@events[i].x,@events[i].y]] = 2
      # end

      # Restore loc
      if $state.loc?(i)
        loc = $state.getloc(i)
        @events[i].moveto(loc[0],loc[1])
        @events[i].direction = loc[2]
        @events[i].off_x = loc[3]
        @events[i].off_y = loc[4]
      end
    }

  end

  def add_forced_terrain(e,v)
    x = e.x
    y = e.y
    while x < e.x + e.width
      while y < e.y + e.height
        @force_terrains[[x,y]] = v
        y += 1
      end
      x += 1
      y = e.y
    end
  end

  def remove_forced_terrain(e)
     x = e.x
    y = e.y
    while x < e.x + e.width
      while y < e.y + e.height
        @force_terrains.delete([x,y])
        y += 1
      end
      x += 1
      y = e.y
    end
  end

  def setup_audio

    # Ignore if skip next
    if @skip_music_change
      @skip_music_change = false
      return
    end

    # Fadeout previous
    

    # Play music from the zone
    # No music at night
    $audio.music(@zone.music) if !flag?('night-time')
    $audio.atmosphere(@zone.atmosphere)

  end

  def dispose

  end
  
  def display_x
    # cam_x = @cam_x
    # cam_x = 0 if cam_x < 0
    # w = ($map.width * 128) - ($game.width * 4)
    # cam_x = w if cam_x > w
    return (@cam_x + (@cam_ox*4)).to_i
  end

  def display_y
    
    # cam_y = @cam_y
    # cam_y = 0 if cam_y < 0
    # h = ($map.height * 128) - ($game.height * 4)
    # cam_y = h if cam_y > h
    #log_sys (@cam_y + (@cam_oy*4)).to_i if rand(10) == 4
    return (@cam_y + (@cam_oy*4)).to_i
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

  def start_common(id)
    @interpreter.common_event_id = id
  end

  # For moving events
  def cache_clear(x,y,ev)
    @ev_cache[[x,y]] = []
  end

  def cache_push(x,y,ev)
    return if ev == $player
    @ev_cache[[x,y]] = [] if !@ev_cache.has_key?([x,y])
    @ev_cache[[x,y]].push(ev)
  end

  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update

    # Build event cache
    @ev_cache.clear
    @events.values.each{ |e|
      # Include size of the event
      sx = e.x
      sy = e.y
      (sx..sx+e.width-1).each{ |x| 
        (sy..sy+e.height-1).each{ |y|
          loc = [x,y]
          @ev_cache[loc] = [] if !@ev_cache.has_key?(loc)
          @ev_cache[loc].push(e)
        }
      }

    }

    # If common event is queued, start it
    if $menu.common_event != nil
      @interpreter.common_event_id = $menu.common_event
      $menu.common_event = nil
    end

    @interpreter.update #if @cam_snap
    return if $scene.is_a?(Scene_Menu)
    return if $scene.is_a?(Scene_GameOver)

    update_events

    # Refresh map if necessary
    if @need_refresh
      @events.values.each{ |e| e.refresh }
      @need_refresh = false
    end

    update_camera

    # Mouse update
    # Check what's under, change cursor etc etc, maybe not every frame? only if moving?
    update_mouse    

  end

  def update_events

    # Keep track of starting events and always update those
    @events.values.each{ |e| e.update }

    #  bx = 0#1
    #  by = 0#1

    # x1 = ((display_x/128) - bx).to_i
    # y1 = ((display_y/128) -by).to_i
    # x2 = x1 + 20 + (bx*2)
    # y2 = y1 + 15 + (by*2)

    # updaters = []
    # (x1..x2).each{ |x|
    #   (y1..y2).each{ |y|
    #     evs = events_at(x,y)
    #     if evs != nil
    #       updaters += evs 
    #     end    
    #   }
    # }

    # updaters.uniq.each{ |e| e.update }

  end

  def update_mouse

    if $scene.is_a?(Scene_GameOver) || $scene.hud.busy?
      $mouse.change_cursor('Default')
      return
    end

    if $mouse.y > 448
      $mouse.change_cursor('Default')
      return
    end

    # Mouse position
    mx, my = *$mouse.grid

    # Check 3 x 3 area, use offsets
    ev = event_at(mx,my)
    ev = event_at(mx,my+1) if ev == nil
    ev = event_at(mx,my-1) if ev == nil
    ev = event_at(mx+1,my) if ev == nil
    ev = event_at(mx-1,my) if ev == nil
    ev = event_at(mx-1,my-1) if ev == nil
    ev = event_at(mx-1,my+1) if ev == nil
    ev = event_at(mx+1,my-1) if ev == nil
    ev = event_at(mx+1,my+1) if ev == nil


    # What event is there
    if ev != nil && ev.mousein && ev.character_name != ''

      # Check actual mouse xy to see if inside

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
        when 'C'
          $mouse.change_cursor('Coins')
        when 'R'
          $mouse.change_cursor('Read')
        else
          $mouse.change_cursor('Default')

      end

    else

      if $map.passable?(mx,my,$player.direction)
        $mouse.change_cursor('Default')
      else
        $mouse.change_cursor('Block')
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
      new_target_x = (@cam_xy[0] * 128) - (128 * 9.5)
      new_target_y = (@cam_xy[1] * 128) - (128 * 7)
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
            y_snap = true if @cam_y <= 0 && dy < 0
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
    if $settings.bottombar
      h = (($map.height+1) * 128) - (($game.height) * 4) # Add 32 for bottom bar
    else
      h = (($map.height) * 128) - (($game.height) * 4) # Add 32 for bottom bar
    end

    @cam_x = w if @cam_x > w
    @cam_y = h if @cam_y > h

  end
  #--------------------------------------------------------------------------
  # * Determine if Passable
  #--------------------------------------------------------------------------
  def passable?(x, y, d, self_event = nil, monster=false)

    return false unless valid?(x, y)

    # Change direction (0,2,4,6,8,10) to obstacle bit (0,1,2,4,8,0)
    bit = (1 << (d / 2 - 1)) & 0x0f

    # Loop all events
    evs = events_at(x,y)
    if evs != nil && (self_event == nil || !self_event.sthrough)
      evs.each{ |e| 
        if e != self_event #and e.at?(x,y)
           return true if e.bridge && [4,6].include?(d) && e.width > 1
           return true if e.bridge && [2,8].include?(d) && e.height > 1
           return false if e.bridge && [2,8].include?(d) && e.height == 1
           return false if e.bridge && [4,6].include?(d) && e.width == 1
           return false if !(e.through || e.above || e.below || e.sthrough)
           return false if (monster || e.ysnp) && e.name == "YSNP"
        end
      }
    end

    # Loop searches in order from top of layer
    [2, 1, 0].each{ |i|

      tile_id = data[x, y, i]

      if $party.leader == 'ship'
        return terrain_tag(x,y) == 7
      end

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

    # Check in forced terrains
    if @force_terrains.has_key?([x,y])
      return @force_terrains[[x,y]]
    end

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
  def event_at(x, y) 
    return nil if !@ev_cache.has_key?([x,y])
    return @ev_cache[[x,y]][0]
    #@events.values.find{ |e| e.at?(x,y) } 
  end
  def events_at(x, y) 
    return nil if !@ev_cache.has_key?([x,y])
    return @ev_cache[[x,y]]
    #@events.values.select{ |e| e.at?(x,y) } 
  end
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