
class Game_Battler


  #--------------------------------------------------------------------------
  # * States
  #--------------------------------------------------------------------------

def state?(state_id)
    return @states.include?(state_id)
  end

  def add_state(state_id)
    @states.push(state_id)
  end

  def remove_state(id)
    @states.delete(id)
  end

  #--------------------------------------------------------------------------
  # * Get Restriction
  #--------------------------------------------------------------------------
  def restriction
    restriction_max = 0
    # Get maximum restriction from currently added states
    for i in @states
      if $data_states[i].restriction >= restriction_max
        restriction_max = $data_states[i].restriction
      end
    end
    return restriction_max
  end

  #--------------------------------------------------------------------------
  # ● Has Restriction
  #   Determines if battler has a special restriction
  #--------------------------------------------------------------------------
  def has_restriction?(restriction)
    for i in @states
      if $data_states[i].restriction == restriction
        return true
      end
    end
    
    return false
  end

  #--------------------------------------------------------------------------
  # * Determine [Slip Damage] States
  #--------------------------------------------------------------------------
  def slip_damage?
    for i in @states
      if $data_states[i].slip_damage
        return true
      end
    end
    return false
  end

  #--------------------------------------------------------------------------
  # * Remove Battle States (called up during end of battle)
  #--------------------------------------------------------------------------
  def remove_states_battle
    for i in @states.clone
      if $data_states[i].battle_only
        remove_state(i)
      end
    end
  end

  #--------------------------------------------------------------------------
  # * Natural Removal of States (called up each turn)
  #--------------------------------------------------------------------------
  def remove_states_auto
    for i in @states_turn.keys.clone
      if @states_turn[i] > 0
        @states_turn[i] -= 1
      elsif rand(100) < $data_states[i].auto_release_prob
        remove_state(i)
      end
    end
  end

  #--------------------------------------------------------------------------
  # * State Removed by Shock (called up each time physical damage occurs)
  #--------------------------------------------------------------------------
  def remove_states_shock
    for i in @states.clone
      if rand(100) < $data_states[i].shock_release_prob
        remove_state(i)
      end
    end
  end

 end