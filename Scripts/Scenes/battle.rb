#==============================================================================
# ** Scene_Map
#==============================================================================

# Could hold phase here

class Scene_Battle
  
  #--------------------------------------------------------------------------
  # * Set up the scene
  #--------------------------------------------------------------------------
  def initialize

    Graphics.freeze

    @vp = Viewport.new(0, 0, $game.width, $game.height)
    @vp_hud = Viewport.new(0, 0, $game.width, $game.height)

    @vp.z = 6000  
    @vp_hud.z = 75000

        @bg = Sprite.new(@vp)
    @bg.z = -100
    @bg.bitmap = Cache.menu("tempback")

    @map = Game_Map.new()
    @map.setup(26)


    @player = Game_Player.new
    $player = @player
    @player.moveto(5,5)

        @map.update
        @player.update
        @map.update

        #@map.target = @player

    @tilemap = Tilemap.new(@vp) 
    #@tilemap.z = 500

    
    @tilemap.update

    refresh_tileset

    @hud = BattleHud.new(@vp_hud)

    # @character_sprites.push(Sprite_Character.new(@vp_main, @player))

    # Prepare characters
    (1..4).each{ |c|
      @map.events[c].direction = 4
    }


    Graphics.transition(50,'Graphics/System/trans')  
            
  end
  
  def terminate
    @character_sprites.each{ |s| s.dispose }
    
  end

  def busy?
    return false
  end

  #--------------------------------------------------------------------------
  # * Update the map contents and processes input from the player
  #--------------------------------------------------------------------------
  def update


    @player.update

    $battle.update
        @tilemap.ox = @map.display_x / 4
    @tilemap.oy = @map.display_y / 4
    @tilemap.update

    @map.display_x = 0
    @map.display_y = 0

    # Update character sprites
    @character_sprites.each{ |s|
      #log_info s.character.character_name
      s.update
      #s.x = 50
      #s.y = 50
    }

  end



  #--------------------------------------------------------------------------
  # * Refresh Tileset
  #--------------------------------------------------------------------------
  def refresh_tileset
    @tileset_id = $map.tileset_id
    
          @tileset_id = $map.tileset_id
          @tilemap.tileset = Cache.tileset(@map.tileset.tileset_name)#+'-big')
      i = 0 
      @map.tileset.autotile_names.each{ |a|
        next if a == ''
        @tilemap.autotiles[i] = Cache.autotile(a)#+'-big')
        i+=1
      }
      @tilemap.map_data = @map.data
      @tilemap.priorities = @map.tileset.priorities

    #@character_sprites.each{ |s| s.dispose }
     @character_sprites = []

    for i in @map.events.keys.sort
      sprite = Sprite_Character.new(@vp_hud, @map.events[i])
      @character_sprites.push(sprite)
      sprite.x = 50
      sprite.y = 50
    end

    @character_sprites.push(Sprite_Character.new(@vp_hud, @player))

    # @character_sprites.push(Sprite_Character.new(@vp_main, @player))

  end

end