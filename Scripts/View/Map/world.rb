#==============================================================================
# ** Spriteset_Map
#------------------------------------------------------------------------------
#  This class brings together map screen sprites, tilemaps, etc.
#  It's used within the Scene_Map class.
#==============================================================================

class Game_World
  
  # Screen attrs
  attr_reader   :tone                     # color tone
  attr_reader   :flash_color              # flash color
  attr_reader   :weather_type             # weather type
  attr_reader   :weather_max              # max number of weather sprites
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize

    @map = nil
    
    # INit screen
    
    @tone = Tone.new(0, 0, 0, 0)
    @tone_target = Tone.new(0, 0, 0, 0)
    @tone_duration = 0

    # weather in map data
    @weather_type = 0
    @weather_max = 0.0
    @weather_type_target = 0
    @weather_max_target = 0.0
    @weather_duration = 0
    
    # Make viewports
    @viewport1 = Viewport.new(0, 0, $game.width, $game.height)   
    @viewport2 = Viewport.new(0, 0, $game.width, $game.height)
    @viewport3 = Viewport.new(0, 0, $game.width, $game.height)

    @viewport2.z = 200
    @viewport3.z = 5000
    
    # Make tilemap
    @tilemap = Tilemap.new(@viewport1)
    @tileset_id = 0

    # Make panorama plane
    @panorama = Plane.new(@viewport1)
    @panorama.z = -1000

    # Make fog plane
    @fog = Plane.new(@viewport1)
    @fog.z = 3000

  end

  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose

    # Dispose of tilemap    
    @tilemap.dispose
    @panorama.dispose
    @fog.dispose

    @character_sprites.each{ |s| s.dispose }
    @weather.dispose

    # Dispose of viewports
    @viewport1.dispose
    @viewport2.dispose
    @viewport3.dispose

  end

  def refresh_tileset
    @tileset_id = $map.tileset_id
      @tilemap.tileset = Cache.tileset($map.tileset.tileset_name)#+'-big')
      for i in 0..6
        autotile_name = $map.tileset.autotile_names[i]
        next if autotile_name == ''
        @tilemap.autotiles[i] = Cache.autotile(autotile_name)#+'-big')
      end
      @tilemap.map_data = $map.data
      @tilemap.priorities = $map.tileset.priorities

      @character_sprites = []

    for i in $map.events.keys.sort
      sprite = Sprite_Character.new(@viewport1, $map.events[i])
      @character_sprites.push(sprite)
    end
    @character_sprites.push(Sprite_Character.new(@viewport1, $player))

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
  # * Frame Update
  #--------------------------------------------------------------------------
  def update

    # check for changes
    refresh_tileset if $map.tileset_id != @tileset_id
    refresh_panorama if @panorama_name != $map.tileset.panorama_name
    refresh_fog if @fog_name != $map.tileset.fog_name

    # Update tilemap
    @tilemap.ox = $map.display_x / 4
    @tilemap.oy = $map.display_y / 4
    @tilemap.update

    # Update panorama plane
    @panorama.ox = 0 # $map.display_x / 8
    @panorama.oy = 0 # $map.display_y / 8

    # Update fog plane
    @fog.zoom_x = $map.tileset.fog_zoom / 100.0
    @fog.zoom_y = $map.tileset.fog_zoom / 100.0
    @fog.opacity = $map.tileset.fog_opacity
    @fog.ox = $map.display_x / 4
    @fog.oy = $map.display_y / 4
    

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
    @viewport1.tone = @tone
    


    #@viewport1.ox = $game_screen.shake


    # Update viewports
    @viewport1.update
    @viewport3.update

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
