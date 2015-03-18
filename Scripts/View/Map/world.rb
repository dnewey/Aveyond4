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
    
    # INit screen
    
    @tone = Tone.new(0, 0, 0, 0)
    @tone_target = Tone.new(0, 0, 0, 0)
    @tone_duration = 0
    @flash_color = Color.new(0, 0, 0, 0)
    @flash_duration = 0

    # weather in map data
    @weather_type = 0
    @weather_max = 0.0
    @weather_type_target = 0
    @weather_max_target = 0.0
    @weather_duration = 0

    
    # Make viewports
    # agf - make viewport shorter to allow for HUD
    if ACE_MODE
    @viewport1 = Viewport.new(0, 0, Graphics.width, Graphics.height)         # Was 448 for hud
    @viewport2 = Viewport.new(0, 0, Graphics.width, Graphics.height)
    @viewport3 = Viewport.new(0, 0, Graphics.width, Graphics.height)
  else
        @viewport1 = Viewport.new(0, 0, 640,448)         # Was 448 for hud
    @viewport2 = Viewport.new(0, 0, 640,480)
    @viewport3 = Viewport.new(0, 0, 640,480)
  end
    @viewport2.z = 200
    @viewport3.z = 5000


    
    # Make tilemap
    @tilemap = Tilemap.new(@viewport1)

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
    @tilemap.tileset.dispose
    for i in 0..6
      @tilemap.autotiles[i].dispose
    end
    @tilemap.dispose
    @panorama.dispose
    @fog.dispose
    for sprite in @character_sprites
      sprite.dispose
    end
    @weather.dispose

    # Dispose of viewports
    @viewport1.dispose
    @viewport2.dispose
    @viewport3.dispose

  end

  def refresh_tileset
      @tilemap.tileset = Cache.tileset($map.tileset.tileset_name)#+'-big')
      @tilemap.priorities = $map.priorities
      for i in 0..6
        autotile_name = $map.tileset.autotile_names[i]
        next if autotile_name == ''
        @tilemap.autotiles[i] = Cache.autotile(autotile_name)#+'-big')
      end
      $map.new_tileset = false
      @tilemap.map_data = $map.data
      @tilemap.priorities = $map.priorities

      @character_sprites = []
    for i in $map.events.keys.sort
      sprite = Sprite_Character.new(@viewport1, $map.events[i])
      @character_sprites.push(sprite)
    end
    @character_sprites.push(Sprite_Character.new(@viewport1, $player))

  end

  def refresh_panorama
      @panorama_name = $map.panorama_name
      @panorama_hue = $map.panorama_hue
      if @panorama.bitmap != nil
        @panorama.bitmap.dispose
        @panorama.bitmap = nil
      end
      if @panorama_name != ""
        @panorama.bitmap = Cache.panorama(@panorama_name, @panorama_hue)
      end
      Graphics.frame_reset
  end


  def refresh_fog
      @fog_name = $map.fog_name
      @fog_hue = $map.fog_hue
      if @fog.bitmap != nil
        @fog.bitmap.dispose
        @fog.bitmap = nil
      end
      if @fog_name != ""
        @fog.bitmap = Cache.fog(@fog_name, @fog_hue)
      end
      Graphics.frame_reset
  end


  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update

    update_screen

    # if swapping tilesets
    if $map.new_tileset == true
      refresh_tileset
    end

    
    # If panorama is different from current one
    # if @panorama_name != $map.panorama_name or @panorama_hue != $map.panorama_hue
    #   refresh_panorama
    # end

    # # If fog is different than current fog
    # if @fog_name != $map.fog_name or @fog_hue != $map.fog_hue
    #   refresh_fog
    # end




    # Update tilemap
    @tilemap.ox = $map.display_x / 4
    @tilemap.oy = $map.display_y / 4
    @tilemap.update

    # Update panorama plane
    #@panorama.ox = 0 # $map.display_x / 8
    #@panorama.oy = 0 # $map.display_y / 8

    # Update fog plane
    # @fog.zoom_x = $map.fog_zoom / 100.0
    # @fog.zoom_y = $map.fog_zoom / 100.0
    # @fog.opacity = $map.fog_opacity
    # @fog.blend_type = $map.fog_blend_type
    # @fog.ox = $map.display_x / 4 + $map.fog_ox
    # @fog.oy = $map.display_y / 4 + $map.fog_oy
    # @fog.tone = $map.fog_tone
    # # Update character sprites
    for sprite in @character_sprites
      # only update if in range (anti-lag)
      sprite.update# if in_range?(sprite.character)
    end
    # Update weather graphic
    # @weather.type = $game_screen.weather_type
    # @weather.max = $game_screen.weather_max
    # @weather.ox = $map.display_x / 4
    # @weather.oy = $map.display_y / 4
    # @weather.update
    # Set screen color tone and shake position
    #@viewport1.tone = $game_screen.tone
    #@viewport1.ox = $game_screen.shake
    # Set screen flash color
    #@viewport3.color = $game_screen.flash_color
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
  # * Start Flashing
  #     color : color
  #     duration : time
  #--------------------------------------------------------------------------
  def start_flash(color, duration)
    @flash_color = color.clone
    @flash_duration = duration
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

  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update_screen
    if @tone_duration >= 1
      d = @tone_duration
      @tone.red = (@tone.red * (d - 1) + @tone_target.red) / d
      @tone.green = (@tone.green * (d - 1) + @tone_target.green) / d
      @tone.blue = (@tone.blue * (d - 1) + @tone_target.blue) / d
      @tone.gray = (@tone.gray * (d - 1) + @tone_target.gray) / d
      @tone_duration -= 1
    end
    if @flash_duration >= 1
      d = @flash_duration
      @flash_color.alpha = @flash_color.alpha * (d - 1) / d
      @flash_duration -= 1
    end

    if @weather_duration >= 1
      d = @weather_duration
      @weather_max = (@weather_max * (d - 1) + @weather_max_target) / d
      @weather_duration -= 1
      if @weather_duration == 0
        @weather_type = @weather_type_target
      end
    end
  end

end
