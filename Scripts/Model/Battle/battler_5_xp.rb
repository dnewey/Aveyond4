
class Game_Battler

  #--------------------------------------------------------------------------
  # * XP Calcs
  #--------------------------------------------------------------------------
  def exp_percent
    return @xp / next_exp
  end

  def level_up?
  	if @xp > next_exp
  		while @xp > next_exp
	  		@xp -= next_exp
	  		@level += 1
        # If boyle, level up minions
        if @id == 'boy'
          ['cannon','rat','crab','crow','fang','skull','magic'].each{ |m|
            $party.get('minion-'+m).set_level(@level)
          }
        end
	  	end
      if $party.difficulty != 'hard'
        self.recover_all
      end
  		return true
  	end
  	return false
  end

  def set_level(lvl)
    @level = lvl
  end

  def grant_level(reset_xp = true)
    @level += 1
    @xp = 0 if reset_xp
  end

  def gain_xp(gain)
  	# Add trinket access to xp here if smart
  	@xp += gain
  end
  
  def next_exp 
     return xp_for_level(@level+1)
  end

  def xp_for_level(i)

  	base = $data.numbers['xp-base'].value
  	inflation = $data.numbers['xp-inflation'].value

  	# Different calc above 40, taper off to increase by 1 per level by 50

	pow_i = 2.4 + inflation / 100.0
    n = base * ((i + 3) ** pow_i) / (5 ** pow_i)
    return n.to_i

  end

end