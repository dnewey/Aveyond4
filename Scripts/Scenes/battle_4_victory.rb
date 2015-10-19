
class Scene_Battle

  def phase_victory_init

  	# Everybody grin
  	@hud.all_win
    sys 'fall'
    wait(15)
    music 'victory2'

    # Choose a dialogue
    if $battle.victory_text != nil

       data = $battle.victory_text.split(": ")
       speaker = data[0]
  	   text = data[1]

    else

      # Get dialogue for a party member currently active
      speaker = $party.alive_members.sample.id

      # What will they say?
      idx = rand(3) + 1
      text = $data.victories["#{speaker}-#{idx}"].dialogue

    end

    force = $party.get(speaker).name
    speaker = "A.#{$party.active.index(speaker)}"
    
    $scene.message.force_name = force
    $scene.message.start(speaker+": "+text)
    
  	@phase = :victory_xp  	

  end

  def phase_victory_xp

    xp = $battle.xp_total
    $scene.message.force_name = nil
    $party.alive_members.each{ |b| b.gain_xp(xp) }
  	$scene.message.start("sys:#{xp} XP gained!")

  	@phase = :victory_level
    music_fadeout

  end

  def phase_victory_level    

    # Only show level ups in active party?
    $party.alive_battlers.each{ |b|
      
      if b.level_up?
        b.view.box.wallpaper = $cache.menu_wallpaper("green")        
        $scene.message.start("sys:#{b.name} is now level #{b.level}!")
      end

    }

	  @phase = :victory_end

  end

  def phase_victory_end

    $battle.all_battlers.each{ |b| b.remove_states_battle }

    Graphics.freeze

    $battle.clear
  	$game.pop_scene
    music_restore
    $scene.hud.show

    t = 'Graphics/Transitions/battle'
    Graphics.transition(30,t) 
    
  end

  def phase_victory_lose

          # Fade out show defeat screen etc
      Graphics.freeze
      $game.pop_scene
      $game.push_scene(Scene_GameOver.new)
      t = 'Graphics/Transitions/battle'
      Graphics.transition(30,t) 

  end


end