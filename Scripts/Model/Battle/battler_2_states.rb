
class Game_Battler


  #--------------------------------------------------------------------------
  # * States
  #--------------------------------------------------------------------------

  def state?(state_id)
    return @states.include?(state_id)
  end

  def states
    return @states
  end

  def add_state(state_id)
    @states.push(state_id)
    @states_counter[state_id] = 0
  end

  def remove_state(id)
    @states.delete(id)
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
  # * Remove Battle States
  #--------------------------------------------------------------------------
  def remove_states_battle

    # Break transforms
    @transform = nil

    # Remove states
    @states.delete_if{ |s| $data.states[s].rmv_battle }
    
  end

  #--------------------------------------------------------------------------
  # * State Removed by Shock
  #--------------------------------------------------------------------------
  def remove_states_shock
    @states.delete_if{ |s| $data.states[s].rmv_shock }
  end

  #--------------------------------------------------------------------------
  # * Natural Removal of States
  #--------------------------------------------------------------------------
  def remove_states_turn
    
    # Add a turn to the counter
    @states_counter.values.each{ |v| v += 1 }

    # If done
    #@states.delete_if{ |s| @states_counter[s] >= $states[s].rmv_turn }

  end

 end