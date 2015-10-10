#==============================================================================
# ** Scene_GameOver
#==============================================================================

class Scene_GameOver
  
  attr_accessor :next_menu

  #--------------------------------------------------------------------------
  # * Set up the scene
  #--------------------------------------------------------------------------
  def initialize

    @closing = false

 
    music('sad')

    $scene = self

    # Make viewports - Also in the scene
    @vp = Viewport.new(0,0,$game.width,$game.height)
    @vp.z = 3999

    @bg = Sprite.new(@vp)
    @bg.z = -100
    @bg.bitmap = $cache.gameover("sky")

    # Char
    @char = Sprite.new(@vp)
    @char.x += 50
    @char.bitmap = $cache.gameover('char-mys')
    @char.do(go('x',-50,700,:qo))

    @message = Ui_Message.new(@vp)

    @message.start("vn-mys: Now we'll never save my brother.")


    @next_menu = "Title"
    @menu = nil#Mnu_GameOver.new(@vp)

  end
  
  def terminate

    @vp.dispose

  end

  def hide_logo
    #@title.opacity = 0
  end

  def show_logo
    #@title.opacity = 255
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

    if @message.busy?
      @message.update
      return
    else
      #@message.hide
    end

    #@sparks.each{ |s| s.update }

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

      when "Title"; @menu = Mnu_GameOver.new(@vp)

      when "Continue"; 
        @menu = Mnu_Load_Title.new(@vp)

      when "Load";
        @menu = Mnu_Load_Title.new(@vp)

      when "Quit"; $game.quit

    end

    @next_menu = nil

  end

  def queue_menu(menu)

    @next_menu = menu

  end

  def busy?
    return true
  end

  def close
    sys('close')
    @closing = true
    @bg.do(go("opacity",-255,300))
    self.do(delay(300))
  end




  # def init_boy

  #   # Sky
  #   @sky.bitmap = $cache.title("test-sky")
  #   #@sky.opacity = 0

  #   # Clouds
  #   @clouds.bitmap = $cache.title("test-clouds")
  #   @clouds.x -= 50
  #   #@clouds.opacity = 0
  #   @clouds.do(pingpong("x",100,6000,:qio))

  #   # Wall
  #   @wall.bitmap = $cache.title("test-wall")
  #   #@wall.opacity = 0

  #   sprk = Spark.new('evil-aura',270,60,@vp)
  #   sprk.zoom_x = 2.0
  #   sprk.zoom_y = 2.0
  #   #sprk.opacity = 0
  #   sprk.z = -1
  #   @sparks.push(sprk)

  #   sprk = Spark.new('evil-aura',420,60,@vp)
  #   sprk.zoom_x = 2.0
  #   sprk.zoom_y = 2.0
  #   #sprk.opacity = 0
  #   sprk.z = -1
  #   @sparks.push(sprk)

  #   # Boy
  #   @char.bitmap = $cache.title("test-boy")
  #   #@char.opacity = 0

  #   # Title
  #   @title.bitmap = $cache.title("test-title")
  #   #@title.opacity = 0

  # end

end