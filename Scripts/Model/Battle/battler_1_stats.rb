
class Game_Battler

  # For displays
  def hp_percent
    return @hp / maxhp
  end

  def mp_percent 
    return @mp / maxmp
  end

  #--------------------------------------------------------------------------
  # * Stat Calcs
  #--------------------------------------------------------------------------

  def maxhp
    val = stat('hp')
    return val
  end

  def maxmp
    stat('mp')
  end

  def str
  	stat('str')
  end

  def def
    stat('def')
  end

  #--------------------------------------------------------------------------
  # * Secondary Calculated Stats
  #--------------------------------------------------------------------------
  def eva
    stat('eva')
  end

  def crit
    stat('crit')
  end

  def miss
    stat('miss')
  end

  #--------------------------------------------------------------------------
  # * Stat values
  #--------------------------------------------------------------------------
 
  def stat(stat)
    val = 0
    val += stat_base(stat) # Player base stat from level
    val *= stat_base_mod(stat) # Modify per actor
    val += stat_plus(stat) # Enemy stat or player bonus stat
    val += stat_from_equip(stat) 
    val *= stat_mod_from_equip(stat) 
    val += stat_from_states(stat)   
    val *= stat_mod_from_states(stat)   
    val *= stat_mod_from_difficulty(stat) 
    return val
  end

  def stat_base(stat)
    #return 1
    return 0 if !is_actor?
    $data.numbers["#{stat}-base"].value + ($data.numbers["#{stat}-per"].value * (@level-1))
  end

  def stat_base_mod(stat)
    @stat_mods[stat] || 1.0
  end

  def stat_plus(stat)
    @stat_plus[stat] || 0
  end  

  def stat_from_equip(stat)
    total = 0
    @equips.values.each{ |e|
      next if e == nil
      $data.items[e].stats.split("/n").each{ |s|
        dta = s.split("=>")
        if dta[0] == stat
          total += dta[1].to_i
        end
      }
    }
    return total
  end

  def stat_mod_from_equip(stat)
    return 1.0
  end

  def stat_from_states(stat)
    total = 0
    @states.each{ |e|
      
    }
    return total
  end

  def stat_mod_from_states(stat)
    return 1.0
  end

  # MAYBE
  def stat_mod_from_difficulty(stat)
    return 1.0
  end

end