
class Scene_Battle

  def phase_victory_init

  	# Everybody grin
  	@hud.all_win
    music_fadeout

    # Choose a dialogue
    if $battle.victory_text != nil

  	   text = $battle.victory_text

    else

      # Get dialogue for a party member currently active
      speaker = $party.alive_members.sample

    end

    $scene.message.force_name = 'Boyle'
    $scene.message.start('A.0:'+text)

    # @map.do(
    #     go("cam_oy",70,500,:quad_out)
    # )   
    # $game.sub_scene.black.do(to("opacity",255,255/30))
    # wait(31)
    # music_fadeout
    
  	@phase = :victory_xp  	

  end

  def phase_victory_xp

    xp = $battle.xp_total
    $party.alive_members.each{ |b| b.gain_xp(xp) }
  	$scene.message.start("sys:#{xp} XP GAINED!")

    $party.alive_battlers.each{ |b|
      @hud.chars.each{ |c| c.box.wallpaper = $cache.menu_wallpaper("green")}
    }

  	@phase = :victory_level

  end

  def phase_victory_level

    

    # Only show level ups in active party?
    $party.alive_battlers.each{ |b|
      
      if b.level_up?
        $scene.message.start("sys:#{b.name} is now level #{b.level}!")
      end

    }

	  @phase = :victory_end

  end

  def phase_victory_end

    $battle.clear
  	$game.pop_scene
  end


end