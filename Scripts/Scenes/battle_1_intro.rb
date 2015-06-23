
class Scene_Battle

  def phase_intro_init

  	# If there is a queue skill, start with that
  	if $battle.queue2 != nil

  		$battle.enemies[$battle.queue2[0]].set_action($battle.queue2[1])

  		  @battle_queue = []
		  @active_battler = $battle.enemies[$battle.queue2[0]]
		  @phase = :main_prep
		  return

	 end

    @phase = :actor_init

  end

end