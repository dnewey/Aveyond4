

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

    if !@active_battler.can_attack?
      @phase = :actor_next
      return
    end

    # Clear previous
    @active_battler.action = nil
    @active_battler.skill_id = nil
    @active_battler.item_id = nil

    @actor_cmd.update

    if $input.cancel? || $input.rclick?
      if @actor_idx != 0
        @actor_idx -= 1
        @active_battler = $party.actor_by_index(@actor_idx)
        
        $scene.hud.deselect_all
        @actor_cmd.setup(@active_battler)
        @active_battler.view.select
      end
    end

    # Player command inputs section
    if $input.action? || $input.click?

      sys 'action'

      action = @actor_cmd.get_action
      @active_battler.action = action
      @actor_cmd.close

      case action 

        when "items"

          @item_cmd.setup
          @phase = :actor_item

        when "skills", "spells", "witchery", "team", "transform", "demon", "dream"

          @skill_cmd.setup(@active_battler,action)
          @phase = :actor_skill

        when "two-legs", "four-legs"
          @last_action = action
          @phase = :actor_transform

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

    if $input.cancel? || $input.rclick?
      @actor_idx -= 1
      @phase = :actor_next
      @skill_cmd.close
    end

    if $input.action? || $input.click?
      if @active_battler.can_use_skill?(@skill_cmd.get_skill)
        @skill_cmd.close
        @active_battler.item_id = nil
        @active_battler.skill_id = @skill_cmd.get_skill
        @phase = :actor_strategize
      else
        sys("buzz")
      end
    end

  end

  #==============================================================================
  # ** actor_item
  #==============================================================================

  def phase_actor_item

    @item_cmd.update

    if $input.cancel? || $input.rclick?
      @actor_idx -= 1
      @phase = :actor_next
      @item_cmd.close
    end

    if $input.action? || $input.click?
      @item_cmd.close
      @active_battler.skill_id = nil
      @active_battler.item_id = @item_cmd.get_item
      $party.lose_item(@active_battler.item_id)
      @phase = :actor_strategize
    end

  end

  #==============================================================================
  # ** actor_transform
  #==============================================================================

  # Special myst transform
  def phase_actor_transform

    x = @active_battler.ev.screen_x
    y = @active_battler.ev.screen_y - 24
    add_spark('myst',x,y)

    if @last_action == "four-legs"
      @active_battler.transform('fox')
    else
      @active_battler.transform('nil')
    end

    # Repeat back to myst turn
    wait(40)
    @phase = :actor_re_action 

  end

  def phase_actor_re_action

    @active_battler = $party.actor_by_index(@actor_idx)
    @actor_cmd.setup(@active_battler)
    @phase = :actor_action 

  end

  #==============================================================================
  # ** actor_strategize
  #==============================================================================

  def phase_actor_strategize

    data = nil

    # Get the skill or item
    if @active_battler.action == "items"
      data = $data.items[@active_battler.item_id]
    else
      data = $data.skills[@active_battler.skill_id]
    end

    @active_battler.scope = data.scope

    # If single, targetable?
    if ["one","ally"].include?(data.scope)
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

    if $input.cancel? || $input.rclick?
      @target_cmd.close
      $party.add_item(@active_battler.item_id) if @active_battler.item_id != nil
      @actor_idx -= 1
      @phase = :actor_next
    end

    if $input.action? || $input.click?
      sys('open')
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
      if @active_battler.down?
        return # Get the next one, this actor is done
      else
        $scene.hud.deselect_all
        @actor_cmd.setup(@active_battler)
        @active_battler.view.select
        @phase = :actor_action 
      end
    end
    
  end

end