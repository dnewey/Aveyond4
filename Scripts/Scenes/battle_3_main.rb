
class Scene_Battle

  def phase_main_init
   	
    # Choose enemy actions
    $battle.enemies.each{ |e|
    	e.choose_action
    }

    # Choose minion action
    if $battle.minion != nil
      $battle.minion.choose_action
    end

    # Determine order of attacks
    @battle_queue = $battle.build_attack_queue

    log_err(@battle_queue)
    
    # certain attacks always go first, robin's team move with phye for example

	  @active_battler = @battle_queue.shift
	  @phase = :main_prep

  end

  # Prepare attack of next guy to attack, next_actor called before this
  def phase_main_prep

    log_info("GO #{@active_battler.id}")

    # Apply the cooldown for this skill
    if @active_battler.action == :skill
      @active_battler.apply_cooldown(@active_battler.skill_id)
    end

  	# Calculate results now, then play out the anims
  	@attack_plan = $battle.build_attack_plan(@active_battler)
    @attack_round = @attack_plan.next_attack

    # If this player has been defeated, skip
    if @active_battler.down?
      @attack_plan.cancel
      @phase = :main_next
      return
    end

  	@phase = :main_start

  end

  # Start a round of the attack
  def phase_main_start

    # -----------------------------
    # ERROR CORRECTIONS 

    # If specific target, random if down
    if [:one,:ally].include?(@active_battler.scope)

      # If a tranform, cancel
      if @active_battler.skill_id.include("xform")
        @attack_plan.cancel
        @phase = :main_next
        return
      else
        # Doesn't really work, hmmmmm
        @active_battler.scope = :rand
      end

    end

    # If rez, random if up, or cancel
    if [:down].include?(@active_battler.scope)

      # Check if target is down
      if !@active.battler.target.down?

        # Try to find an alternate target, else cancel

      end

      #@attack_plan.cancel
      #@phase = :main_next
      #return
    end

    # -----------------------------

    # Calculate damage here and now
    @attack_results = $battle.build_attack_results(@active_battler,@attack_round.skill)

    @active_battler.ev.flash_dur = 15

    # Show text if there is
    @phase = :main_text
    wait(30)

  end

  # Show text on attacker
  def phase_main_text

    if @attack_round.text
      $scene.message.force_name = @active_battler.name
      $scene.message.start('A.0:'+@attack_round.text)
      #$scene.message.start(@active_battler.ev.name+':'+@attack_round.text)
    end

    @phase = :main_anim
    wait(20)

  end

  # Show anim on defender
  def phase_main_anim

    @attack_results.each{ |result|

      if @attack_round.anim
        if @attack_round.anim.include?("spark")
          # Show the hit animation
          x = result.target.ev.screen_x
          y = result.target.ev.screen_y - 32
          add_spark(@attack_round.anim.split("=>")[1],x,y)
        end
      end

    }

  	# Onto the next
  	@phase = :main_cost

  end

  def phase_main_cost

    # Use up mana or items or add cooldown
    if @active_battler.action == "items"
      # Use up the item now
      $party.lose_item(@active_battler.item_id)
    else
      @active_battler.lose_mana(@attack_round.skill.cost)
    end

    # Onto the next
    @phase = :main_transform
    # Some anims might have a pause before hit
    # Might use the sound delay on the anim
    #wait(20) 

  end

  def phase_main_transform

    @attack_results.each{ |result|      
      if result.transform
        result.target.transform(result.transform)
      end
    }

    # Onto the next
    @phase = :main_hit

  end

  def phase_main_hit

    # Do damage or healing
    @attack_results.each{ |result|
        
        # Damage
        if result.damage > 0
          result.target.damage(result.damage)
          pop_dmg(result.target.ev,result.damage)
          
          if result.target.view != nil
            result.target.view.damage
          end
        end

        # Heal
        if result.heal > 0

          log_sys result.heal

          result.target.heal(result.heal)
          pop_dmg(result.target.ev,result.heal)

          if result.target.view != nil
            result.target.view.grin
          end

        end
    }

    # Onto the next
    @phase = :main_crit
    wait(1)

  end

  def phase_main_crit

    @attack_results.each{ |result|
      if result.critical
        pop_crit(result.target.event)
      end
    }

    # Onto the next
    @phase = :main_gain
    wait(1)

  end

  def phase_main_gain

    # Show gains of hp or mana or darkness
    @attack_results.each{ |result|
        next if result.gain_mana == nil
        @active_battler.gain_mana(result.gain_mana)
        #pop_gain(@active_battler.ev,result.gain_mana,@active_battler.resource)

        # Flash blue


        # Spark effect
        x = @active_battler.ev.screen_x
        y = @active_battler.ev.screen_y - 15
        add_spark('mana-blue',x,y)
        wait(30)
    }

    @phase = :main_state
    wait(1)

  end

  def phase_main_state

    @attack_results.each{ |result|

      if result.state_add

        # Only if a new state, else refresh
        if result.target.state?(result.state_add)
          # refresh it
          next
        end

        result.target.add_state(result.state_add)
        #pop_state(result.target.ev,result.state_add)

        # Show icon?
        result.target.ev.icons.push(result.state_add)
        #result.target.ev.pulse_colors.push($data.states[result.state_add].color)
        result.target.ev.pulse_colors.push(Color.new(0,240,0,120))
        result.target.ev.pulse_colors.push(Color.new(240,0,0,130))

        # case result.state_add 
        #   when "poison"
        #     result.target.ev.pulse_color = Color.new(46,174,43,150)
        # end
      end

    }

    @phase = :main_tick
    wait(30) # Might wait if a state was aded

  end

  def phase_main_tick

    # Take damage from poison states


    # Remove used up states
    # Remove the pulse and icons also

    @phase = :main_fall
    wait(1)

  end

  def phase_main_fall

    # Anybody defeated should leave now
    @attack_results.each{ |result|

      if result.target.down?
        #sys('fall')
        result.target.fall
        result.target.view.down if result.target.view
        #fade(result.target.ev)
        wait(60)
      end

    }

    # Onto the next
    @phase = :main_next

  end

  def phase_main_next

    # If one side has been defeated, that's it
    if $party.defeated?
      # Fade out show defeat screen etc
      $game.push_scene(Scene_GameOver.new)
      @phase = :LOSE
      return
    end

    if $battle.victory?
      @phase = :victory_init
      return
    end

  	# If a multi stage, go back to attack
    if !@attack_plan.done?

      # End multi stage attacks early if user is incapable of attack

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

    # Attack phase done, finalize
    @phase = :main_end    

	end

  def phase_main_end
    
    # Remove states and that before next turn starts

    # Go to next turn, actor select
    @phase = :actor_init

  end

end