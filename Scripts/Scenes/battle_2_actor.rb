

class Scene_Battle

  # Could auto do next actor
  def phase_actor_init
    @actor_idx = -1  
    @phase = :actor_next
    return
  end

  def phase_actor_action

    @actor_cmd.update

    if $input.cancel?
      return actor_prev
    end

    # Player command inputs section
    if $input.action?

      action = @actor_cmd.get_action
      @actor_cmd.close

      log_info "ACTIOn"
      log_info action

      # HMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
      if action == "items"

      else
        skills = @active_battler.skills_for(action)
      end

      log_info(skills)

      # If a multi-skill open the menu
      if skills.count > 1

        # Open skill_cmd

      else

        select_skill(skills[0])        

      end

    end 

  end

  #==============================================================================
  # ** actor_skill
  #==============================================================================

  def phase_actor_skill

    @skill_cmd.update

    if $input.cancel?
      @actor_idx -= 1
      @phase = :actor_next
      return
    end

    if $input.action?

    end

  end

  #==============================================================================
  # ** actor_item
  #==============================================================================

  def phase_actor_item

    @skill_cmd.update

    if $input.cancel?
      @actor_idx -= 1
      @phase = :actor_next
      return
    end

    if $input.action?

    end

  end

  #==============================================================================
  # ** actor_target
  #==============================================================================

  def phase_actor_target

    @target_cmd.update

    if $input.cancel?
      @target_cmd.close
      # Switch to actor_action instead
      # Then actor prev could combine into a actor_skill that could do items also
      @actor_idx -= 1
      @phase = :actor_next
      return
    end

    if $input.action?
      @active_battler.target = @target_cmd.active
      @target_cmd.close
      @phase = :actor_next
      return
    end

  end  

  def phase_actor_next

    @actor_idx += 1
    if @actor_idx >= $party.active.count
      @actor_cmd.close
      @phase = :main_init
      return
    end

    @phase = :actor_action 
    @active_battler = $party.actor_by_index(@actor_idx)
    @actor_cmd.setup(@active_battler)
    
  end

  #==============================================================================
  # ** select_skill
  #==============================================================================
  # Select a skill and decide whether targeting phase is needed

  def select_skill(id)

    @active_battler.skill_id = id

    log_info(id)

    # If single, targetable?
    if ["one","ally"].include?($data.skills[id].scope)
      targets = $battle.enemies #$battle.build_target_list(@active_battler)
      @target_cmd.setup(targets)
      @phase = :actor_target      
    else
      @phase = :actor_next
      return
    end

  end



  def actor_prev
    return if @actor_idx == 0
    @actor_idx -= 1
    @active_battler = $party.actor_by_index(@actor_idx)
    @actor_cmd.setup(@active_battler)
  end

end