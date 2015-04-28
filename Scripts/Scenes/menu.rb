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

    # The current menu
    @menus = [Mnu_Main.new(@vp)]
    #@menu = Mnu_Items.new(@vp)

    Graphics.transition(50,'Graphics/System/trans')            
  end
  
  def terminate

    @menu.dispose
    @bg.dispose

  end

  #--------------------------------------------------------------------------
  # * Update 
  #--------------------------------------------------------------------------
  def update

    $game.pop_scene if Input.trigger?(Input::F7)

    @menus[-1].update
    
  end

  def push_menu(menu)
    @menus[-1].close
    @menus.push(menu)
  end

  def pop_menu
    @menus.shift.dispose
  end

end