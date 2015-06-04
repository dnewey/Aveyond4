#==============================================================================
# ** Scene_GameOver
#==============================================================================

class Scene_GameOver

  #--------------------------------------------------------------------------
  # * Set up the scene
  #--------------------------------------------------------------------------
  def initialize

    $scene = self

    # Make viewports - Also in the scene
    @vp = Viewport.new(0,0,$game.width,$game.height)
    @vp.z = 3999

    @bg = Sprite.new(@vp)
    @bg.z = -100
    @bg.bitmap = $cache.menu_background("game-over")
               
  end
  
  def terminate


  end

  def update

  end

end
