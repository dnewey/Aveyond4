
class Scene_Battle

  def phase_main_init

    wait(15)

    # Play nice noise
    # sys 'join'
   	
    # Choose enemy actions
    $battle.enemies.each{ |e|
    	e.choose_action
    }
    
    if $battle.allies != nil
      $battle.allies.each{ |a| 
        a.choose_action
      }
    end

    # Choose minion action
    if $party.active.include?('boy') && $battle.minion != nil
      $battle.minion.choose_action
    end


    # Determine order of attacks
    @battle_queue = $battle.build_attack_queue
    
    # certain attacks always go first, robin's team move with phye for example

	  @active_battler = @battle_queue.shift
	  @phase = :main_prep

  end

  # Prepare attack of next guy to attack, next_actor called before this
  def phase_main_prep

    # Apply the cooldown for this skill
    if @active_battler.action != 'items'
      @active_battler.apply_cooldown(@active_battler.skill_id)
    end

  	# Calculate results now, then play out the anims
  	@attack_plan = $battle.build_attack_plan(@active_battler)
    @attack_round = @attack_plan.next_attack

    # If this player has been defeated, skip
    if !@active_battler.can_attack?
      @attack_plan.cancel
      @phase = :main_next
      return
    end

    # If nothing attack
    if @active_battler.skill_id == 'nothing'
      @attack_plan.cancel
      @phase = :main_next
      return
    end

    # Show attack name
    if @active_battler.action == "items"
      it = $data.items[@active_battler.item_id]
      @hud.set_help(it.name)
    else
      sk = $data.skills[@active_battler.skill_id]
      @hud.set_help(sk.name)
    end

    @last_attack = nil

  	@phase = :main_start
    @wait = 15

  end

  # Start a round of the attack
  def phase_main_start

    # Play nice noise
    #sys 'talk2'

      # -----------------------------
    # ERROR CORRECTIONS 

    # If specific target, random if down
    if ['one','ally'].include?(@active_battler.scope) && @active_battler.target.down?

      # If a tranform, cancel
      if @active_battler.skill_id != nil
        if @active_battler.skill_id.include?("xform")
          @attack_plan.cancel
          @phase = :main_next
          return
        else
          # Doesn't really work, hmmmmm
          @active_battler.scope = 'rand'
        end
      end

    end

    # -----------------------------

    # Calculate damage here and now
    @attack_results = $battle.build_attack_results(@active_battler,@attack_round.skill)

    # For multi hits, only flash and wait the first time
    if @attack_round.skill != @last_attack
      @active_battler.ev.flash_dur = 15
      wait(15)
      

      # Mana cost
      if @active_battler.action != "items"
        if @attack_round.skill != @last_attack
          @active_battler.lose_mana(@attack_round.skill.cost)
        end
      end

      # Remember attack to avoid double mana use
      @last_attack = @attack_round.skill

    else
      wait(5)
    end

    @active_battler.attack_sfx

    # Show text if there is
    @phase = :main_text
    

  end

  # Show text on attacker
  def phase_main_text

    if @attack_round.text
      $scene.message.force_name = @active_battler.name
      speaker = "A.#{$party.active.index(@active_battler.id)}"
      $scene.message.start(speaker+': '+@attack_round.text)
      #$scene.message.start(@active_battler.ev.name+':'+@attack_round.text)
      wait(15)
    end

    @attack_results.each{ |result|
      if result.escape
        @phase = :misc_escape
        return
      end
    }

    @phase = :main_anim
    

  end

  # Show anim on defender
  def phase_main_anim

    # Face at target of attack - CUT
    # if @active_battler.target != nil && @active_battler.target.is_enemy?
    #   @active_battler.ev.direction = 10 - @active_battler.target.ev.direction
    #   #@active_battler.ev.turn_toward_event(@active_battler.target.ev.id)      
    # end

    @attack_results.each{ |result|

      # Target face attacker
      #result.target.ev.turn_toward_event(@active_battler.ev.id)
      # if @active_battler.is_enemy?
      #   result.target.ev.direction = 10 - @active_battler.ev.direction
      # end

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
  	@phase = :main_transform

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

          # Remove state by damage
          result.target.remove_states_shock

          result.target.damage(result.damage)
          pop_dmg(result.target.ev,result.damage)
          
          if result.target.view != nil
            result.target.view.damage
          end

          if result.target.is_enemy? && result.target.down?
            result.target.ev.color = Color.new(0,0,0,200)
          end

        end

        # Heal
        if result.heal > 0

          if result.revive
            result.target.revive
            result.target.view.revive if result.target.view
          end

          result.target.heal(result.heal)
          pop_dmg(result.target.ev,result.heal)

          if result.target.view != nil
            result.target.view.grin
          end

        end

    }

    # Onto the next
    @phase = :main_crit
    #wait(1)

  end

  def phase_main_crit

    @attack_results.each{ |result|
      if result.critical
        
        # Play nice noise
        sys 'attack'
        pop_crit(result.target.ev)
        wait(10)

      end

      # Evade
      if result.evade

        # Play nice noise
        sfx 'whoosh2'
        pop_evade(result.target.ev)
        wait(10)

      end

      # Resist
      if result.resist

        # Play nice noise
        sfx 'whoosh2'
        pop_resist(result.target.ev)
        wait(10)

      end

    }

    # Onto the next
    @phase = :main_gain
    #wait(1)

  end

  def phase_main_gain

    # Show gains of hp or mana or darkness
    @attack_results.each{ |result|

        if result.steal
          item('cheese',1,'rat')
        end

        if result.pocket
          gold(result.target.gold.to_s.split("-")[-1].to_i,'row')
        end

        if result.gain_mana != nil
          @active_battler.gain_mana(result.gain_mana)
          #pop_gain(@active_battler.ev,result.gain_mana,@active_battler.resource)

          # Spark effect
          x = @active_battler.ev.screen_x
          y = @active_battler.ev.screen_y - 15
          add_spark('mana-blue',x,y)
          wait(15)
        end
    }

    @phase = :main_state
    #wait(1)

  end

  def phase_main_state

    @attack_results.each{ |result|

      # Empower minion
      if result.empower
        $battle.minion.add_state('empower')
        $battle.minion.ev.character_name = $battle.minion.ev.character_name + '-wild'
        x = $battle.minion.ev.screen_x
        y = $battle.minion.ev.screen_y - 16
        add_spark('redstar',x,y)
        wait(20) # Might wait only if a state was aded
      end

      if result.state_remove

        #log_sys(result.state_remove)

          if result.target.state?(result.state_remove)
            result.target.remove_state(result.state_remove)            
            wait(20) # Might wait only if a state was aded
            #result.target.ev.icons.delete(result.state_remove)
          end

      end

      if result.state_add

        result.target.add_state(result.state_add)
        wait(20) # Might wait only if a state was aded
        #pop_state(result.target.ev,result.state_add)
        
        #result.target.ev.pulse_colors.push($data.states[result.state_add].color)
        #result.target.ev.pulse_colors.push(Color.new(0,240,0,120))

      end

    }

    @phase = :main_tick
    

  end

  def phase_main_tick

    # Take damage from poison states
    # This would be after all attacks, then another fall?




    @phase = :main_fall
    wait(1)

  end

  def phase_main_fall

    # Anybody defeated should leave now
    @attack_results.each{ |result|

      if result.target.down?
        if result.target.is_actor?
          #sys('fall')
          if result.target.id == 'mys'
            x = result.target.ev.screen_x
            y = result.target.ev.screen_y - 32
            add_spark("myst",x,y)
          end
          result.target.fall
          result.target.clear_states
          result.target.view.down if result.target.view
          #fade(result.target.ev)
        else
          fade(result.target.ev)
        end
        wait(30)
      end

    }

    # Onto the next
    @phase = :main_next

  end

  def phase_main_next

    # If one side has been defeated, that's it
    if $party.defeated?
      music_fadeout
      wait(120)
      @phase = :victory_lose
      return
    end

    if $battle.victory?
      @phase = :victory_init
      return
    end

  	# If a multi stage, go back to attack
    if !@attack_plan.done?

      # End multi stage attacks early if user is incapable of attack

      @attack_round = @attack_plan.next_attack
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
    
    # Play nice noise
    sys 'open'

    # Remove states and that before next turn starts
    $battle.all_battlers.each{ |b| b.reduce_cooldowns }
    $battle.all_battlers.each{ |b| b.remove_states_turn }

    # Go to next turn
    @phase = :start_turn

  end

end