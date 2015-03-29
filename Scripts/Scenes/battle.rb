#==============================================================================
# ** Scene_Map
#==============================================================================

class Scene_Battle
  
  #--------------------------------------------------------------------------
  # * Set up the scene
  #--------------------------------------------------------------------------
  def initialize

    Graphics.freeze

    @vp = Viewport.new(0, 0, $game.width, $game.height)
    @vp_hud = Viewport.new(0, 0, $game.width, $game.height)

    @vp.z = 6000  
    @vp_hud.z = 7000

    @bg = Sprite.new(@vp)
    @bg.z = -100
    @bg.bitmap = Cache.menu("tempback")

    @map = Game_Map.new()
    @map.setup(25)

    @tilemap = Tilemap.new(@vp) 
    #@tilemap.z = 500

    refresh_tileset
    @tilemap.update

    @hud = BattleHud.new(@vp_hud)

    @character_sprites = []

    # Will there be any sprites? Maybe if they have the name ###
    # Otherwise create as battler sprites
    # Which are what exactly?
    # Just sprites, just make them all as sprites, assign the idle animation

    # for i in @map.events.keys.sort
    #   sprite = Sprite_Character.new(@vp_main, @map.events[i])
    #   @character_sprites.push(sprite)
    # end

    # @character_sprites.push(Sprite_Character.new(@vp_main, @player))

    Graphics.transition(50,'Graphics/System/trans')  
            
  end
  
  def terminate
    @world.dispose
    
  end

  def busy?
    return true
  end

  #--------------------------------------------------------------------------
  # * Update the map contents and processes input from the player
  #--------------------------------------------------------------------------
  def update
    $battle.update
    @tilemap.update    
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
    # @character_sprites = []

    # for i in @map.events.keys.sort
    #   sprite = Sprite_Character.new(@vp_main, @map.events[i])
    #   @character_sprites.push(sprite)
    # end

    # @character_sprites.push(Sprite_Character.new(@vp_main, @player))

  end

end