#==============================================================================
# ** Scene_Map
#==============================================================================

class Scene_Map

  attr_reader :hud

  attr_reader :overlay

  #--------------------------------------------------------------------------
  # * Set up the scene
  #--------------------------------------------------------------------------
  def initialize

    # Make viewports - Also in the scene
    @vp_main = Viewport.new(0,0,$game.width,$game.height)   
    @vp_overlay = Viewport.new(0,0,$game.width,$game.height)
    @vp_ui = Viewport.new(0,0,$game.width,$game.height)

    # Prep model
    @map = Game_Map.new
    $map = @map
    @map.setup($data.system.start_map_id)

    @player = Game_Player.new
    $player = @player
    @player.moveto($data.system.start_x, $data.system.start_y)

    @map.target = @player




    # Make tilemap
    #@panorama = Plane.new(@vp_main,-1000)
    @tilemap = MapWrap.new(@vp_main)
    @character_sprites = []  

    # weather in map data
    @weather = nil

    @overlay = Sprite.new(@vp_overlay)
    @overlay.bitmap = Bitmap.new($game.width,$game.height)
    @overlay.bitmap.fill(Color.new(0,0,0))
    @overlay.opacity = 0
    @overlay.z = 999
    
    # UI
    @hud = Ui_Screen.new(@vp_ui)

    # TESTING THE SPARKS
    @sparks = []

    Graphics.transition
            
  end
  
  def terminate

    # Dispose of tilemap  
    @panorama.dispose  
    @tilemap.dispose
    @character_sprites.each{ |s| s.dispose }
    @weather.dispose  
    @hud.dispose
    
    # Dispose of viewports
    @vp_main.dispose
    @vp_ui.dispose

  end

  def busy?
    return @hud.busy?
  end

  #--------------------------------------------------------------------------
  # * Update the map contents and processes input from the player
  #--------------------------------------------------------------------------
  def update

    # Update the sparks
    @sparks.each{ |s| 
      s.ox = @map.display_x/4
      s.oy = @map.display_y/4
      s.update 
    }


    @map.update      
    @player.update

    @hud.update

    # check for changes
    refresh_tileset if $map.tileset_id != @tilemap.tileset_id

    #refresh_panorama if @panorama_name != @map.tileset.panorama_name

    # Update tilemap
    @tilemap.ox = @map.display_x / 4
    @tilemap.oy = @map.display_y / 4
    @tilemap.update

    # Update panorama plane
    #@panorama.ox = 0 # $map.display_x / 8
    #@panorama.oy = 0 # $map.display_y / 8

    # # Update character sprites
    @character_sprites.each{ |s|
      s.update
    }

  
    # Set screen color tone and shake position
    #@vp_main.tone = @tone

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

  def add_spark(x,y)

    # Spawn spark
    sprk = Spark.new("magic",@vp_main)
    
    #x = @sprites.x + @cx+size.width
    #y = @sprites.y + @cy

    dx = -@map.display_x/4
    dy = -@map.display_y/4
    sprk.center(x+3-dx,y+3-dy)
    sprk.blend_type = 1
    @sparks.push(sprk)

  end

  #--------------------------------------------------------------------------
  # * Refresh Tileset
  #--------------------------------------------------------------------------
  def refresh_tileset
    
    @tilemap.refresh(@map)

    @character_sprites.each{ |s| s.dispose }
    @character_sprites = []

    @map.events.keys.sort.each{ |i|
      sprite = Sprite_Character.new(@vp_main, @map.events[i])
      @character_sprites.push(sprite)
    }

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

end
