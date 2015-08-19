class Game_Battler

  def learn(skill)
  	@skills.push(skill)
  end

  def skill_list(action)
    result = @skills.select{ |s| $data.skills[s].book == action }
    if action == "team"
      result = result.select{ |s|
        $party.active.include?(s.split("-")[1])
      }
    end
    return result
  end

  def all_skill_list
    result = @skills
    return result
  end


  def skills_for(action)

    return @skills.select{ |s| 
      #log_info s
      $data.skills[s].id == action || 
      $data.skills[s].book == action
    }
  end

  def choose_action
    if is_enemy?
  	  @action = 'attack'
      @skill_id = 'attack'
      @target = $party.attackable_battlers.sample
    elsif is_minion?
      @action = 'attack'
      @skill_id = 'attack'
      @target = $battle.attackable_enemies.sample
    end
  end  

  def set_action(skill)
    @action = 'attack'
    @skill_id = skill
  end

  #--------------------------------------------------------------------------
  # * Determine Usable Skills
  #     skill_id : skill ID
  #--------------------------------------------------------------------------
  def skill_can_use?(skill_id)
    # If there's not enough SP, the skill cannot be used.
    if $data.skills[skill_id].sp_cost > self.sp
      return false
    end
    
    # If silent, only physical skills can be used
    if $data_skills[skill_id].atk_f == 0 and self.has_restriction?(1)
      return false
    end

    return true
  end

end