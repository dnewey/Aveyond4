#==============================================================================
# ** Scene_Menu
#==============================================================================

class Scene_Menu

  attr_accessor :savequit
  
  #--------------------------------------------------------------------------
  # * Set up the scene
  #--------------------------------------------------------------------------
  def initialize

    #Graphics.freeze

    @closing = false
    @savequit = false

    $mouse.change_cursor('Default')
    sys('open')

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
    @bg.bitmap = $cache.menu_background("sample")
    #@bg.bitmap = $cache.menu_background("witch")
    @bg.opacity = 0
    
    #@bg.y = 30
    #@bg.do(seq(go("y",-50,150,:qio),go("y",20,150,:qio)))

    #self.do(delay(300))

    @next_menu = $menu.menu_page
    $menu.menu_page = nil

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

    @bg.do(go("opacity",255,300)) if @bg.opacity == 0

    if @closing && $tweens.done?(self)
      $tweens.clear_all
      if @savequit
        $game.quit 
      else
        $game.pop_scene
      end
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

      when "Main"; @menu = Mnu_Main.new(@vp)

      when "Quit"; @menu = Mnu_Quit.new(@vp)
      when "Journal"; @menu = Mnu_Journal.new(@vp)
      when "Items"; @menu = Mnu_Items.new(@vp)
      when "Healing"; @menu = Mnu_Healing.new(@vp)
      when "Equipping"; @menu = Mnu_Equipping.new(@vp)
      when "Party"; @menu = Mnu_Party.new(@vp)
      when "Progress"; @menu = Mnu_Progress.new(@vp)
      when "Options"; @menu = Mnu_Options.new(@vp)
      when "Help"; @menu = Mnu_Help.new(@vp)
      when "Sound"; @menu = Mnu_Sound.new(@vp)

      when "Load"; 
        @menu = Mnu_Save.new(@vp)
        @menu.loadmode
      when "Save"; @menu = Mnu_Save.new(@vp)

      when "Char"; @menu = Mnu_Char.new(@vp)

      when "Equip"; @menu = Mnu_Equip.new(@vp)
      when "Skills"; @menu = Mnu_Skills.new(@vp)
      when "Status"; @menu = Mnu_Status.new(@vp)
      when "Profile"; @menu = Mnu_Profile.new(@vp)

      when "Potions"; @menu = Mnu_Potions.new(@vp)
      when "Chooser"; @menu = Mnu_Chooser.new(@vp)

      # Shops

      # Item Shop
      # Smith
      # Magic

      # Cheekis

      when "Shop","Smith","Magic","Chester"
        @menu = Mnu_Shop.new(@vp)
        @menu.setup(@next_menu)

      when "Sell"
        @menu = Mnu_Shop.new(@vp)
        @menu.setup(@next_menu)
        @menu.sellmode

      when "Boyle"; @menu = Mnu_Boyle.new(@vp)
      when "Ingrid"; @menu = Mnu_Ingrid.new(@vp)
      when "Nightwatch"; @menu = Mnu_Nightwatch.new(@vp)
      when "Hiberu"; @menu = Mnu_Hiberu.new(@vp)
      when "Rowen"; @menu = Mnu_Rowen.new(@vp)
      when "Phye"; @menu = Mnu_Phye.new(@vp)

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


end