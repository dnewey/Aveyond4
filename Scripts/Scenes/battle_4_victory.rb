
class Scene_Battle

  def phase_victory_init

  	

  	# Everybody grin
  	@hud.all_grin

  	$scene.message.start("sys:Battle Victory")

  	@phase = :victory_xp  	

  end

  def phase_victory_xp

    xp = $battle.xp_total
    $party.alive_members.each{ |b| b.gain_xp(xp) }
  	$scene.message.start("sys:#{xp} XP GAINED!")

  	@phase = :victory_level

  end

  def phase_victory_level

    $party.alive_battlers.each{ |b|
      @hud.chars.each{ |c| c.box.wallpaper = $cache.menu_wallpaper("green")}
    }

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