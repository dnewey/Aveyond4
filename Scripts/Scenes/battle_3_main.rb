
class Scene_Battle

  def phase_main_init
   	
    # Choose enemy actions
    $battle.enemies.each{ |e|
    	e.choose_action
    }

    # Determine order of attacks
    @battle_queue = $battle.build_attack_queue
    
    # certain attacks always go first, robin's team move with phye for example

	  @active_battler = @battle_queue.shift
	  @phase = :main_prep

  end

  # Prepare attack of next guy to attack, next_actor called before this
  def phase_main_prep

  	# Calculate results now, then play out the anims
  	@attack_plan = $battle.build_attack_plan(@active_battler)

    @attack_round = @attack_plan.next_attack

  	@phase = :main_start

  end

  # Start a round of the attack
  def phase_main_start

    # Calculate damage here and now
    @attack_results = $battle.build_attack_results(@active_battler,@attack_round.skill)

    # Attack anim if there is one
    @phase = :main_attack
    wait(20)

  end

  # Show anim on attacker
  def phase_main_attack

    # x = @active_battler.ev.screen_x
    # y = @active_battler.ev.screen_y
    # add_spark(x,y)

    # Hit anim if there is one
    if @attack_round.anim_a == nil
      @phase = :main_defend # RENAME TO MAIN_ANIM_HIT
      return
    end

    @phase = :main_defend
    wait(20)

  end

  # Show anim on defender
  def phase_main_defend

    @attack_results.each{ |result|
      x = result.target.ev.screen_x
      y = result.target.ev.screen_y
      add_spark('redstar',x,y)
    }

    # Hit anim if there is one
    if @attack_round.anim_b == nil
      @phase = :main_hit # RENAME TO MAIN_ANIM_HIT
      return
    end

  	# Onto the next
  	@phase = :main_hit
    #wait(20)

  end

  def phase_main_hit

    # Show the damage of @attack-result on each guy hit
    # Better figure damage pops
    @attack_results.each{ |result|

        result.target.damage(result.damage)
        pop_num(result.target.ev,result.damage)

    }

    # Onto the next
    @phase = :main_crit
    wait(1)

  end

  def phase_main_crit

    # Onto the next

    @phase = :main_state
    wait(1)

  end

  def phase_main_state

    # Onto the next
    @phase = :main_next
    wait(1)

  end

  def phase_main_next

  	# If a multi stage, go back to attack
    if !@attack_plan.done?
      @active_attack = @attack_plan.next_attack
      @phase = :main_start
      return
    end

  	# Onto the next battler
	  if !@battle_queue.empty?
		
  		# Good place to check for end of battle also
	 	  @active_battler = @battle_queue.shift
	   	@phase = :main_prep
      return

    end

    # Go to next turn, actor select
    @phase = :actor_init

	end

  # NOT CURRENTLY ACTIVATED
  def phase_main_end
    # Remove stats and that before next turn starts
  end

end
