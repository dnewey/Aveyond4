
class Game_Battler


  def refresh_stat_mods

      data = $data.actors[@id]

      if data.mods != ""
      data.mods.split("\n").each{ |m|
        md = m.split("=>")
        @stat_mods[md[0]] = md[1].to_f
      }
    end

    log_info("New stat mods for #{@name}")

  end

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
    #return 1 if val < 1
    return val
  end

  def maxmp
    if @id == 'boy'
      $party.boy_mp_bonus = 0 if $party.boy_mp_bonus == nil
      return 20 + $party.boy_mp_bonus
    else
      stat('mp')
    end
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
  
  def luk
    stat('luk')
  end

  def eva
    stat('eva')
  end

  def res
    stat('res')
  end

  def stat_list

    return [maxhp,maxmp,str,self.def,luk,eva,res]

  end

  def grant_stat(stat,amount)
    @stat_plus[stat] = 0 if !@stat_plus.has_key?(stat)
    @stat_plus[stat] += amount
  end

  def ungrant_stat(stat,amount)
    @stat_plus[stat] = 0 if !@stat_plus.has_key?(stat)
    @stat_plus[stat] -= amount
  end

  #--------------------------------------------------------------------------
  # * Item Usage
  #-------------------------------------------------------------------------- 

  def hp_from_item(item)

    # Can't heal if down, unless cassia
    if @hp == 0
      return item == 'cassia' ? 1 : 0
    end
    return 0 if item == 'cassia' && @hp > 0


    # Do it
    plus = 0
    $data.items[item].action.split("\n").each{ |actn|

      dta = actn.split('=>')
      case dta[0]
        when 'heal'
          plus += dta[1].to_i
        when 'heal-p'
          plus += dta[1].to_f * maxhp
      end
    }
    plus = (maxhp - hp) if plus > (maxhp - hp)
    return plus

  end

  def mp_from_item(item)

    # Could change this if boyle gets a mana upgrade
    return 0 if @id == 'boy'

    # Do it
    plus = 0
    $data.items[item].action.split("\n").each{ |actn|

      dta = actn.split('=>')
      case dta[0]
        when 'mana'
          plus += dta[1].to_i
        when 'mana-p'
          plus += dta[1].to_f * maxmp
      end
    }
    plus = (maxmp - mp) if plus > (maxmp - mp)
    return plus

  end

  def use_item(item)
    @hp += hp_from_item(item)
    @mp += mp_from_item(item)
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
    return val.to_i
  end

  # For menu display
  def stat_pure(stat)
    val = 0
    val += stat_base(stat) # Player base stat from level
    val *= stat_base_mod(stat) # Modify per actor
    val += stat_plus(stat) # Enemy stat or player bonus stat
    return val.to_i
  end

  def stat_gear(stat)
    return stat(stat) - stat_pure(stat)
  end

  def stat_base(stat)
    #return 1
    return 0 if !is_good?
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
      #log_info(e)
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
    total = 1.0
    @equips.values.each{ |e|
      #log_info(e)
      next if e == nil
      $data.items[e].mods.split("/n").each{ |s|
        #log_info(s)
        dta = s.split("=>")
        if dta[0] == stat
          total *= dta[1].to_f
        end
      }
    }
    return total
  end

  def stat_from_states(stat)
    total = 0
    #@states.each{ |e|
      
    #}
    return total
  end

  def stat_mod_from_states(stat)
    total = 1.0
    @states.each{ |e|
        $data.states[e].mods.split("/n").each{ |s|
        #log_info(s)
        dta = s.split("=>")
        if dta[0] == stat
          total *= dta[1].to_f
        end
      }
    }
    return total
  end

  # MAYBE
  def stat_mod_from_difficulty(stat)
    return 1.0 if is_good?
    return 0.9 if $party.difficulty == 'easy'
    return 1.0 if $party.difficulty == 'normal'
    return 1.1 if $party.difficulty == 'hard'
    return 1.0
  end

end