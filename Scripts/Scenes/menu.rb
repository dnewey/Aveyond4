#==============================================================================
# ** Scene_Menu
#==============================================================================

class Scene_Menu
  
  #--------------------------------------------------------------------------
  # * Set up the scene
  #--------------------------------------------------------------------------
  def initialize

    Graphics.freeze

    # Vp
    @vp = Viewport.new(0,0,$game.width,$game.height)
    @vp.z = 5000

    # Background
    @bg = Sprite.new(@vp)
    @bg.z = -100
    @bg.bitmap = $cache.menu_background("sample")
    #@bg.do(repeat(sequence(go("x",-50,7000),go("x",50,7000))))

    # Choose background by location

    # The current menu
    @menu = Mnu_Main.new(@vp)
    @sub = nil

    Graphics.transition(20,'Graphics/Transitions/trans')     

  end
  
  def terminate

    @menu.dispose if @menu != nil
    @sub.dispose if @sub != nil
    @bg.dispose

    @vp.dispose

  end

  #--------------------------------------------------------------------------
  # * Update 
  #--------------------------------------------------------------------------
  def update

    if @sub == nil || @sub.closed
      @menu.update
    else
      @sub.update
    end
    
  end

  def open_sub(menu)
    @menu.close
    @sub = menu
    @sub.open
  end

  def close_sub
    @sub.close
    @sub.dispose
    @menu.open
  end

  def close_all

  end

end