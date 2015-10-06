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
    @vp = Viewport.new(0,0,$game.width,$game.height)
    #@vp.z = 3500

    # Sprites
    @sky = Sprite.new(@vp)
    @sky.z = -2
    @clouds = Sprite.new(@vp)
    @clouds.z = -2
    @wall = Sprite.new(@vp)
    @wall.z = -2
    @wall.opacity = 0

    @sparks = [] # Update all

    # Higher Sprites
    @char = Sprite.new(@vp)
    @title = Sprite.new(@vp)

    # Overlays
    @mtop = Sprite.new(@vp)
    @mtop.bitmap = $cache.title('cloud-top')
    @mtop.z = 8888
    @mtop.blend_type = 1
    @mbtm = Sprite.new(@vp)
    @mbtm.bitmap = $cache.title('cloud-btm')
    @mbtm.z = 8888
    @mbtm.blend_type = 1
    @mleft = Sprite.new(@vp)
    @mleft.bitmap = $cache.title('cloud-left')
    @mleft.z = 8888
    @mleft.blend_type = 1
    @mright = Sprite.new(@vp)
    @mright.bitmap = $cache.title('cloud-right')
    @mright.z = 8888
    @mist = Sprite.new(@vp)
    @mist.bitmap = $cache.overlay('mist-portal')
    @mist.z = 9999


    # Init 
    init_boy

    d = 600

    # Start the transition in
    @mtop.do(go('opacity',-255,3000))
    @mright.do(go('opacity',-255,3000))
    @mleft.do(go('opacity',-255,3000))
    @mbtm.do(go('opacity',-255,3000))

    @mtop.do(go('y',-380,1500,:qio))
    @mbtm.do(go('y',280,1500,:qio))
    @mright.do(go('x',280,1500,:qio))
    @mleft.do(go('x',-280,1500,:qio))    

    @mist.do(go('opacity',-255,1500))
 
    @next_menu = nil
    @menu = Mnu_Title.new(@vp)

  end
  
  def terminate

    @vp.dispose

  end

  def hide_logo
    @title.opacity = 0
  end

  def show_logo
    @title.opacity = 255
  end

  def hide_char
    @char.opacity = 0
  end

  def show_char
    @char.opacity = 255
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

      when "Title"; @menu = Mnu_Title.new(@vp)

      when "New";
        $game.pop_scene
        $game.push_scene Scene_Map.new()

      when "Continue"; 
        @menu = Mnu_Load_Title.new(@vp)

      when "Options";
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
    @sky.bitmap = $cache.title("test-sky")
    #@sky.opacity = 0

    # Clouds
    @clouds.bitmap = $cache.title("test-clouds")
    @clouds.x -= 50
    #@clouds.opacity = 0
    @clouds.do(pingpong("x",100,6000,:qio))

    # Wall
    @wall.bitmap = $cache.title("test-wall")
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