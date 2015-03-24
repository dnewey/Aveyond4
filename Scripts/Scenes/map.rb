#==============================================================================
# ** Scene_Map
#==============================================================================

class Scene_Map

  attr_reader   :tone                     # color tone
  attr_reader   :weather_type             # weather type
  attr_reader   :weather_max              # max number of weather sprites
  
  attr_reader :message

  #--------------------------------------------------------------------------
  # * Set up the scene
  #--------------------------------------------------------------------------
  def initialize

    @map = Game_Map.new
    $map = @map
    @map.setup($data.system.start_map_id)

    @player = Game_Player.new
    $player = @player
    @player.moveto($data.system.start_x, $data.system.start_y)

    # Make viewports - Also in the scene
    @vp_main = Viewport.new(0, 0, $game.width, $game.height)   

    # Make tilemap
    @tilemap = Tilemap2.new(@vp_main)    
    #@panorama = Plane.new(@vp_main,-1000)
    #@fog = Plane.new(@vp_main,3000)

    @character_sprites = []

    @tileset_id = 0 # move to tilemap? or cut stupid system

    @hud = Ui_Screen.new

    @message = Ui_Message.new


    @tone = Tone.new(0, 0, 0, 0)
    @tone_target = Tone.new(0, 0, 0, 0)
    @tone_duration = 0

    # weather in map data
    @weather_type = 0
    @weather_max = 0.0
    @weather_type_target = 0
    @weather_max_target = 0.0
    @weather_duration = 0    

    Graphics.transition
            
  end
  
  def terminate    

    # Dispose of tilemap    
    @tilemap.dispose
    @panorama.dispose
    @fog.dispose
    @hud.dispose

    @character_sprites.each{ |s| s.dispose }
    @weather.dispose

    # Dispose of viewports
    @vp_main.dispose

  end

  def busy?
    return @hud.busy? || @message.busy?
  end

  #--------------------------------------------------------------------------
  # * Update the map contents and processes input from the player
  #--------------------------------------------------------------------------
  def update

    @map.update      
    @player.update

    @hud.update
    @message.update

    # check for changes
    refresh_tileset if $map.tileset_id != @tileset_id
    #refresh_panorama if @panorama_name != @map.tileset.panorama_name
    #refresh_fog if @fog_name != @map.tileset.fog_name

    # Update tilemap
    @tilemap.ox = @map.display_x / 4
    @tilemap.oy = @map.display_y / 4
    @tilemap.update

    # Update panorama plane
    #@panorama.ox = 0 # $map.display_x / 8
    #@panorama.oy = 0 # $map.display_y / 8

    # Update fog plane
    # @fog.zoom_x = @map.tileset.fog_zoom / 100.0
    # @fog.zoom_y = @map.tileset.fog_zoom / 100.0
    # @fog.opacity = @map.tileset.fog_opacity
    # @fog.ox = @map.display_x / 4
    # @fog.oy = @map.display_y / 4    

    # # Update character sprites
    @character_sprites.each{ |s|
      s.update
    }

    if @tone_duration >= 1
      d = @tone_duration
      @tone.red = (@tone.red * (d - 1) + @tone_target.red) / d
      @tone.green = (@tone.green * (d - 1) + @tone_target.green) / d
      @tone.blue = (@tone.blue * (d - 1) + @tone_target.blue) / d
      @tone.gray = (@tone.gray * (d - 1) + @tone_target.gray) / d
      @tone_duration -= 1
    end

    if @weather_duration >= 1
      d = @weather_duration
      @weather_max = (@weather_max * (d - 1) + @weather_max_target) / d
      @weather_duration -= 1
      if @weather_duration == 0
        @weather_type = @weather_type_target
      end
    end

    # Update weather graphic
    # @weather.type = $game_screen.weather_type
    # @weather.max = $game_screen.weather_max
    # @weather.ox = $map.display_x / 4
    # @weather.oy = $map.display_y / 4
    # @weather.update

    # Set screen color tone and shake position
    @vp_main.tone = @tone

    # Open Menu at player's request
    unless @map.interpreter.running? or @hud.busy?

      # Check inputs
      if Input.trigger?(Input::F7)
        $game.push_scene(Scene_Menu.new)
      end

      if Input.trigger?(Input::F8)
        $game.push_scene(Scene_Battle.new)
      end
        
    end
    
  end

  #--------------------------------------------------------------------------
  # * Refresh Tileset
  #--------------------------------------------------------------------------
  def refresh_tileset
    @tileset_id = $map.tileset_id
    @tilemap.refresh_tileset(@map)

    @character_sprites.each{ |s| s.dispose }
    @character_sprites = []

    for i in @map.events.keys.sort
      sprite = Sprite_Character.new(@vp_main, @map.events[i])
      @character_sprites.push(sprite)
    end

    @character_sprites.push(Sprite_Character.new(@vp_main, @player))

  end

  def refresh_panorama
      @panorama_name = $map.tileset.panorama_name
      if @panorama.bitmap != nil
        @panorama.bitmap.dispose
        @panorama.bitmap = nil
      end
      if @panorama_name != ""
        @panorama.bitmap = Cache.panorama(@panorama_name)
      end
      Graphics.frame_reset
  end


  def refresh_fog
      @fog_name = $map.tileset.fog_name
      if @fog.bitmap != nil
        @fog.bitmap.dispose
        @fog.bitmap = nil
      end
      if @fog_name != ""
        @fog.bitmap = Cache.fog(@fog_name)
      end
      Graphics.frame_reset
  end


  #--------------------------------------------------------------------------
  # * Start Changing Color Tone
  #     tone : color tone
  #     duration : time
  #--------------------------------------------------------------------------
  def start_tone_change(tone, duration)
    @tone_target = tone.clone
    @tone_duration = duration
    if @tone_duration == 0
      @tone = @tone_target.clone
    end
  end

  #--------------------------------------------------------------------------
  # * Set Weather
  #--------------------------------------------------------------------------
  def weather(type, power, duration)
    @weather_type_target = type
    if @weather_type_target != 0
      @weather_type = @weather_type_target
    end
    if @weather_type_target == 0
      @weather_max_target = 0.0
    else
      @weather_max_target = (power + 1) * 4.0
    end
    @weather_duration = duration
    if @weather_duration == 0
      @weather_type = @weather_type_target
      @weather_max = @weather_max_target
    end
  end

end