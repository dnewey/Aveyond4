
# TO DO!!!!!!!!!!

# sample enemy attacks
# battle orders

# player and enemy stats
# action result class


class Scene_Battle

  def phase_main_init
   	
    # Choose enemy actions
    $battle.enemies.each{ |e|
    	e.choose_action
    }

    # Determine order of attacks
    @battle_order = []
    
    # certain attacks always go first, robin's team move with phye for example

	@active_battler = @battle_order.shift
	@phase = :main_prep

  end

  # Prepare attack of next guy to attack, next_actor called before this
  def phase_main_prep

  	# Calculate results now, then play out the anims
  	@action_result = $battle.build_action_result(@active_battler)

  	# targets: evs
  	# damage
  	# critical
  	# state added
  	# state removed

  	# If a multi stage attack, queue that up


  	@phase = :main_attack

  end

  # Show anim on attacker
  def phase_main_attack

  	# Onto the next
  	@phase = :main_defend

  end

  # Show anim on defender
  def phase_main_defend


  	# Onto the next
  	@phase = :main_result

  end

  def phase_main_hit

  end

  def phase_main_crit

  end

  def phase_main_state

  end

  def phase_main_next

  	# If a multi stage, go back to attack
  	# But won't always show more anims, that will be in @action_result

  	# Onto the next
	if @battle_orders.empty?
		# Go to next turn, actor select
		@phase = :actor_init

		# Good place to check for end of battle also
	else
		@active_battler = @battle_order.shift
		@phase = :main_prep
	end

  end

end