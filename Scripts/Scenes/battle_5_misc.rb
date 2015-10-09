
class Scene_Battle

  def phase_misc_text

  	data = @texts.shift


  	# Get speaker name
  	speaker = data.split(":")[0]
  	text = data.split(":")[1]

  	force = speaker

  	# If speaker is enemy, get name somehow
  	if speaker.include?("E.")
  		force = $battle.enemies[speaker.split(".")[1].to_i].name
  	end

  	if $party.active.include?(speaker)
  		force = $party.get(speaker).name
  		speaker = "A.#{$party.active.index(speaker)}"
  	end

	$scene.message.force_name = force

	# Convert actor speaker to event format

	#speaker = $scene.

	#if $party.active.include?()
    $scene.message.start(speaker+": "+text)

    wait(1)

  	@phase = :misc_check

  end

  def phase_misc_check

  	
  	if !@texts.empty?

  		# If text still going, allow it
  		@phase = :misc_text

  	elsif @skill == true

  		# If a skill is queued, start it
  		@phase = :main_prep

  	else

  		# Else back to main
  		@phase = :start_turn

  	end

  end

  def phase_misc_escape

    $battle.all_battlers.each{ |b| b.remove_states_battle }

    $battle.clear
    Graphics.freeze
    $game.pop_scene
    music_restore
    $scene.hud.show

    t = 'Graphics/Transitions/battle'
    Graphics.transition(30,t) 

  end

 end
