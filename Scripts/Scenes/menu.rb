#==============================================================================
# ** Scene_Menu
#==============================================================================

class Scene_Menu
  
  #--------------------------------------------------------------------------
  # * Set up the scene
  #--------------------------------------------------------------------------
  def initialize

    Graphics.freeze

    $mouse.change_cursor('Default')

    # Vp
    @vp = Viewport.new(0,0,$game.width,$game.height)
    @vp.z = 3500

    # Background
    @bg = Sprite.new(@vp)
    @bg.z = -100
    @bg.bitmap = $cache.menu_background("sample") #$game.snapshot#
    #@bg.do(repeat(sequence(go("x",-50,7000),go("x",50,7000))))

    # Choose background by location

    # The current menu
    case $menu.menu_page

      when "Main"; @menu = Mnu_Main.new(@vp)
      when "Shop"; @menu = Mnu_Shop.new(@vp)
      #when "Wizard"; @menu = Mnu_Shop.new(@vp) # Wizard shop

      when "Quit"; @menu = Mnu_Quit.new(@vp)
      when "Journal"; @menu = Mnu_Journal.new(@vp)
      when "Items"; @menu = Mnu_Items.new(@vp)
      when "Party"; @menu = Mnu_Party.new(@vp)
      when "Options"; @menu = Mnu_Options.new(@vp)
      when "Sound"; @menu = Mnu_Sound.new(@vp)
      when "Save"; @menu = Mnu_Save.new(@vp)

      when "Char"; @menu = Mnu_Char.new(@vp)

    end

    $menu.menu_page = nil

    @sub = nil
    @next_sub = nil

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

    if @sub != nil && @sub.done? # CLOSE SELF
      @sub.dispose
      @sub = nil
      @menu.open
      log_sys("CLOSE SUB")
    end


    if @sub == nil   
      if @next_sub != nil
        case @next_sub
          when "Char"
            open_sub(Mnu_Char.new(@vp))
          when "Equip"
            open_sub(Mnu_Equip.new(@vp))
          when "Skills"
            open_sub(Mnu_Skills.new(@vp))
          when "Status"
            open_sub(Mnu_Status.new(@vp))
          when "Profile"
            open_sub(Mnu_Profile.new(@vp))
          when "Creatures"
            open_sub(Mnu_Creatures.new(@vp))
          when "Witchery"
            open_sub(Mnu_Witchery.new(@vp))
          when "Dreaming"
            open_sub(Mnu_Dreaming.new(@vp))
          when "Demons"
            open_sub(Mnu_Demons.new(@vp))
        end
        @next_sub = nil
      else
        @menu.update    
      end
    else
      @sub.update
    end

    if ($input.cancel? || $input.rclick?) || (@sub == nil && @menu.done?)
      sys('cancel')
      $tweens.clear_all
      $game.pop_scene
    end
    
  end

  def open_sub(menu)
    @menu.close
    @sub = menu
    @sub.open
  end

  def change_sub(menu)
    @next_sub = menu
  end

  # def close_sub
  #   @sub.close
  #   @sub.dispose
  #   @menu.open
  # end

  def close_all
    $tweens.clear_all
    $game.pop_scene
  end


end