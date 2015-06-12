

class Scene_Battle

  #==============================================================================
  # ** actor_init
  #==============================================================================

  def phase_actor_init
    @actor_idx = -1  
    @phase = :actor_next
  end

  #==============================================================================
  # ** actor_action
  #==============================================================================

  def phase_actor_action

    @actor_cmd.update

    if $input.cancel?
      if @actor_idx != 0
        @actor_idx -= 1
        @active_battler = $party.actor_by_index(@actor_idx)
        @actor_cmd.setup(@active_battler)
      end
    end

    # Player command inputs section
    if $input.action?

      action = @actor_cmd.get_action
      @active_battler.action = action
      @actor_cmd.close

      case action 

        when "items"

          @item_cmd.setup
          @phase = :actor_item

        when "skills", "spells", "witchery", "team", "transform", "demon", "dream"

          @skill_cmd.setup(@active_battler)
          @phase = :actor_skill

        else

          @active_battler.skill_id = action
          @phase = :actor_strategize

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
      @skill_cmd.close
    end

    if $input.action?
      @skill_cmd.close
      @active_battler.skill_id = @skill_cmd.get_skill
      @phase = :actor_strategize
    end

  end

  #==============================================================================
  # ** actor_item
  #==============================================================================

  def phase_actor_item

    @item_cmd.update

    if $input.cancel?
      @actor_idx -= 1
      @phase = :actor_next
      @item_cmd.close
    end

    if $input.action?
      @item_cmd.close
      @active_battler.item_id = @item_cmd.get_item
      @phase = :actor_strategize
    end

  end

  #==============================================================================
  # ** actor_strategize
  #==============================================================================

  def phase_actor_strategize

    # Get the skill or item

    # If single, targetable?
    if ["one","ally"].include?($data.skills[@active_battler.skill_id].scope)
      targets = $battle.possible_targets(@active_battler)
      @target_cmd.setup(targets)
      @phase = :actor_target      
    else
      @phase = :actor_next
    end

  end

  #==============================================================================
  # ** actor_target
  #==============================================================================

  def phase_actor_target

    @target_cmd.update

    if $input.cancel?
      @target_cmd.close
      @actor_idx -= 1
      @phase = :actor_next
    end

    if $input.action?
      @active_battler.target = @target_cmd.active
      @target_cmd.close
      @phase = :actor_next
    end

  end  

  #==============================================================================
  # ** actor_next
  #==============================================================================

  def phase_actor_next

    @actor_idx += 1
    if @actor_idx >= $party.active.count
      @phase = :main_init
    else
      @active_battler = $party.actor_by_index(@actor_idx)
      @actor_cmd.setup(@active_battler)
      @phase = :actor_action 
    end
    
  end

end