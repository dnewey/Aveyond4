
class Scene_Battle

  def phase_victory_init

  	# Everybody grin
  	@hud.all_win
    music_fadeout

    # Choose a dialogue
    if $battle.victory_text != nil

       data = $battle.victory_text.split(": ")
       speaker = data[0]
  	   text = data[1]

    else

      # Get dialogue for a party member currently active
      speaker = $party.alive_members.sample

      # What will they say?
      idx = 1#rand(1)
      text = $data.victories["#{speaker}-#{idx}"].dialogue

    end

    log_info(speaker)

    force = $party.get(speaker).name
    speaker = "A.#{$party.active.index(speaker)}"
    
    $scene.message.force_name = force
    $scene.message.start(speaker+": "+text)
    
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

    $battle.all_battlers.remove_states_battle

    $battle.clear
  	$game.pop_scene
  end


end