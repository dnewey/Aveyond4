#==============================================================================
# ** Scene_Title
#==============================================================================

class Scene_Title
  
  #--------------------------------------------------------------------------
  # * Set up the scene
  #--------------------------------------------------------------------------
  def initialize

    #Graphics.freeze

    @closing = false

    $mouse.change_cursor('Default')

    # Vp
    @vp = Viewport.new(0,0,$game.width,$game.height)
    @vp.z = 3500

    @snap = Sprite.new(@vp)
    @snap.z = -101
    @snap.bitmap = $game.snapshot

    # Background
    @bg = Sprite.new(@vp)
    @bg.z = -100
    #@bg.bitmap = Bitmap.new(640,480)
    #@bg.bitmap.fill(Color.new(0,0,0,180))
    @bg.bitmap = $cache.menu_background("boyle")
    #@bg.bitmap = $cache.menu_background("witch")
    @bg.opacity = 0
    @bg.do(go("opacity",255,300))
    #@bg.y = 30
    #@bg.do(seq(go("y",-50,150,:qio),go("y",20,150,:qio)))

    #self.do(delay(300))

    @next_menu = "Title"

    @menu = nil

    #Graphics.transition(20,'Graphics/Transitions/trans')     

  end
  
  def terminate

    @menu.dispose if @menu != nil

    @bg.dispose
    @snap.dispose

    @vp.dispose

  end

  #--------------------------------------------------------------------------
  # * Update 
  #--------------------------------------------------------------------------
  def update

    if @closing && $tweens.done?(self)
      $tweens.clear_all
      $game.pop_scene
      $game.push_scene(Scene_Map.new)
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

    # The current menu
    case @next_menu

      when "Title"; 
        @menu = Mnu_Title.new(@vp)

      when "New"

      when "Load"
        @menu = Mnu_TitleLoad.new(@vp)

      when "Options"
        @menu = Mnu_TitleOptions.new(@vp)

      when "Quit"
        $game.pop_scene


      #when "Title"; @menu = Mnu_Title.new(@vp)
      

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
    @closing = true
    @bg.do(go("opacity",-255,300))
    self.do(delay(300))
  end


end