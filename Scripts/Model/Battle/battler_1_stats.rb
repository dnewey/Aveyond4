
class Game_Battler

  #--------------------------------------------------------------------------
  # * Stat Calcs
  #--------------------------------------------------------------------------
  def maxhp

  end

  def maxsp

  end

  def str
  	val = @str_init + (@str_rate * @level) + @str_plus
	val += stat_from_equip('str')
	val += stat_from_state('str')
  end

  def atk
    n = base_atk
    for i in @states
      n *= $data_states[i].atk_rate / 100.0
    end
    return Integer(n)
  end

  def def
    n = base_pdef
    for i in @states
      n *= $data_states[i].pdef_rate / 100.0
    end
    return Integer(n)
  end

  #--------------------------------------------------------------------------
  # * Secondary Calculated Stats
  #--------------------------------------------------------------------------
  def eva
    n = base_eva
    for i in @states
      n += $data_states[i].eva
    end
    return n
  end

  def hit
    n = 100
    for i in @states
      n *= $data_states[i].hit_rate / 100.0
    end
    return Integer(n)
  end

end