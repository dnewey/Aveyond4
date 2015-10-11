class Game_Battler

  def learn(skill)
  	@skills.push(skill)
  end

  def replace_skill(os,ns)

    # Find pretty close old skill
    idx = 0
    @skills.each_index{ |i|
      if @skills[i].include?(os)
        idx = i
      end
    }

    @skills[idx] = ns

  end

  def has_skill?(skill)
    return @skills.include?(skill)
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

    targets = is_enemy? ? $party.attackable_battlers : $battle.attackable_enemies

  	@action = 'attack'

    if @actions.count == 1

      @skill_id = @actions[0]

    elsif @actions.count == 2

      if rand < 0.65
        @skill_id = @actions[0]
      else
        @skill_id = @actions[1]
      end

    elsif @actions.count == 3

      if rand < 0.65
        @skill_id = @actions[0]
      else
        if rand < 0.5
          @skill_id = @actions[1]
        else
          @skill_id = @actions[2]
        end
      end

    elsif @action.count == 4

      if rand < 0.5
        @skill_id = @actions[0]
      else
        if rand < 0.6
          if rand < 0.5
            @skill_id = @actions[1]
          else
            @skill_id = @actions[2]
          end
        else
          @skill_id = @actions[3]
        end
      end

    end

    log_sys @skill_id
    sk = $data.skills[@skill_id]

    @scope = sk.scope

    if @scope == 'rand' || @scope == 'one'
      @target = targets.sample
    end

  end  

  def get_actions

    if @id == 'hib'

      case @equips['book']
        when 'hib-book-ice'
          return ['chant','bk-ice-1','bk-ice-2','items']
        when 'hib-book-dmg'
          return ['chant','bk-dmg-1','bk-dmg-2','items']
        when 'hib-book-heal'
          return ['chant','bk-heal-1','bk-heal-2','items']
        when 'hib-book-help'
          return ['chant','bk-help-1','bk-help-2','items']
        when 'hib-book-sleep'
          return ['chant','bk-sleep-1','bk-sleep-2','items']
      end
    else
      return @actions
    end
  end

  def set_action(skill)
    @action = 'attack'
    @skill_id = skill
  end

  def reduce_cooldowns
    @cooldowns.each_key{ |k| 
      @cooldowns[k] -= 1
    }
    @cooldowns.delete_if{ |k,v| v <= 0 }
  end

  def get_cooldown(skill_id)
    return 0 if !@cooldowns.has_key?(skill_id)
    return @cooldowns[skill_id]
  end

  def clear_cooldowns
    @cooldowns = {}
  end

  def apply_cooldown(skill_id)
    return if $data.skills[skill_id].cooldown == nil
    @cooldowns[skill_id] = $data.skills[skill_id].cooldown
  end

  def can_use_skill?(skill_id)

    # Not enough mana
    if $data.skills[skill_id].cost > @mp
      return false
    end

    # Currently on cooldown
    if @cooldowns.has_key?(skill_id)
      return false
    end
    
    # Other requirements, such as under X% hp

    return true

  end

end