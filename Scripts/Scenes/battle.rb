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

    @vp.z = 6000  
    @bg = Sprite.new(@vp)
    @bg.z = -100
    @bg.bitmap = Cache.menu("tempback")

    @map = Game_Map.new()
    @map.setup(25)

    @tilemap = Tilemap2.new(@vp,@map.map) 
    #@tilemap.z = 500

    @tilemap.refresh_tileset(@map)
    @tilemap.update

    @character_sprites = []

    # for i in @map.events.keys.sort
    #   sprite = Sprite_Character.new(@vp_main, @map.events[i])
    #   @character_sprites.push(sprite)
    # end

    # @character_sprites.push(Sprite_Character.new(@vp_main, @player))

    Graphics.transition(50,'Graphics/System/trans')  
            
  end
  
  def terminate

    @world.dispose
    @hud.dispose

  end

  #--------------------------------------------------------------------------
  # * Update the map contents and processes input from the player
  #--------------------------------------------------------------------------
  def update
    @tilemap.update
     
    
  end

end