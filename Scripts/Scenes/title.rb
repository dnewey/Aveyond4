#==============================================================================
# ** Scene_Title
#==============================================================================

class Scene_Title
  
  attr_accessor :next_menu

  #--------------------------------------------------------------------------
  # * Set up the scene
  #--------------------------------------------------------------------------
  def initialize

    @closing = false

    # Vp
    @vp_base = Viewport.new(0,0,$game.width,$game.height)
    @vp_mid = Viewport.new(0,0,$game.width,$game.height)
    @vp = Viewport.new(0,0,$game.width,$game.height)
    #@vp.z = 3500

    # Sprites
    @sky = Sprite.new(@vp_base)
    @sky.z = -2
    @weather = Weather_MenuDots.new(@vp_mid)
    @clouds = Sprite.new(@vp)
    @clouds.z = -2
    @wall = Sprite.new(@vp)
    @wall.z = -2
    #@wall.opacity = 0

    @sparks = [] # Update all

    # Higher Sprites
    @char = Sprite.new(@vp)
    @title = Sprite.new(@vp)

    # Overlays
    @mist = Sprite.new(@vp)
    @mist.bitmap = $cache.overlay('mist-portal')
    @mist.z = 9999

    @beta = Sprite.new(@vp)
    @beta.bitmap = $cache.menu_common('beta-1')
    @beta.x = 320
    @beta.y = 220
    @beta.ox = 320
    @beta.oy = 240

    @beta.do(repeat(seq(go("zoom_x",0.3,700,:qio),go("zoom_x",-0.3,700,:qio))))
    @beta.do(repeat(seq(go("zoom_y",-0.5,800,:qio),go("zoom_y",0.5,800,:qio))))

    @beta.do(repeat(seq(go("y",-50,600,:qio),go("y",50,600,:qio))))




    # Init 
    init_boy

    @idx = 0
    @idx = 1 if $files.any_save_files?

    @next_menu = nil
    @menu = Mnu_Title.new(@vp,@idx)

    Graphics.freeze
    @mist.opacity = 0
    src = "Graphics/Transitions/Cave_inv"
        Graphics.transition(20,src)
 


  end
  
  def terminate

    @vp.dispose

  end

  def hide_logo
    @title.opacity = 255
    @title.do(go('opacity',-255,500,:qio))
    @title.do(go('y',25,500,:qio))
  end

  def show_logo
    @title.opacity = 0
    @title.do(go('opacity',255,700,:qio))
    @title.do(go('y',-25,700,:qio))
  end

  def hide_char
    @char.opacity = 255
    @char.do(go('opacity',-255,500,:qio))
    @char.do(go('x',25,500,:qio))
  end

  def show_char
    @char.opacity = 0
    @char.do(go('opacity',255,700,:qio))
    @char.do(go('x',-25,700,:qio))
  end


  def inviz
    @map.hide
  end

  def viz
    @map.show
  end

  #--------------------------------------------------------------------------
  # * Update 
  #--------------------------------------------------------------------------
  def update

    @weather.update
    @sparks.each{ |s| s.update }

    #@bg.do(go("opacity",255,300)) if @bg.opacity == 0

    if @closing && $tweens.done?(self)
      $tweens.clear_all
      $game.pop_scene
    end

    return if @closing


    if @menu == nil

      # Open next menu if not fading in
      if @next_menu == nil
        close
      else
        if $tweens.done?(self)
          open_next_menu
        end
      end

    else

      @menu.update
      if @menu.done?
        
        if @next_menu == nil
          @menu = nil
          close
        else
          open_next_menu
        end
      end

    end



    # if ($input.cancel? || $input.rclick?) #|| (@next_menu == nil && @menu.done?)
    #   close
    # end
    
  end


  def open_next_menu

    if @menu != nil
      @menu.dispose
      @menu = nil
    end

    if @next_menu == "Main"
      @next_menu = nil if $menu.sub_only
    end    

    # The current menu
    case @next_menu

      when "Title"; 
        @menu = Mnu_Title.new(@vp,@idx)

      when "New";
        $game.pop_scene
        $game.push_scene Scene_Map.new()

      when "Continue"; 
        @idx = 1
        @menu = Mnu_Load_Title.new(@vp)

      when "Options";
        @idx = 2
        @menu = Mnu_Options_Title.new(@vp)

      when "Quit"; @menu = Mnu_Main.new(@vp)

    end

    @next_menu = nil

  end

  def queue_menu(menu)

    @next_menu = menu

  end



  # def open_sub(menu)
  #   @menu.close
  #   @sub = menu
  #   @sub.open
  # end

  # def change_sub(menu)
  #   @next_sub = menu
  # end

  # def close_sub
  #   @sub.close
  #   @sub.dispose
  #   @menu.open
  # end

  def close
    sys('close')
    @closing = true
    @bg.do(go("opacity",-255,300))
    self.do(delay(300))
  end




  def init_boy

    # Sky
    @sky.bitmap = $cache.title("sky")
    #@sky.opacity = 0

    # Clouds
    @clouds.bitmap = $cache.title("clouds")
    #@clouds.y = 220
    @clouds.x -= 800
    @clouds.opacity = 220
    @clouds.do(pingpong("x",800,26000,:sine_io))

    # Wall
    @wall.bitmap = $cache.title("wall")
    #@wall.opacity = 0

    sprk = Spark.new('evil-aura',270,60,@vp)
    sprk.zoom_x = 2.0
    sprk.zoom_y = 2.0
    #sprk.opacity = 0
    sprk.z = -1
    @sparks.push(sprk)

    sprk = Spark.new('evil-aura',420,60,@vp)
    sprk.zoom_x = 2.0
    sprk.zoom_y = 2.0
    #sprk.opacity = 0
    sprk.z = -1
    @sparks.push(sprk)

    # Boy
    @char.bitmap = $cache.title("test-boy")
    #@char.opacity = 0

    # Title
    @title.bitmap = $cache.title("test-title")
    #@title.opacity = 0

  end

end