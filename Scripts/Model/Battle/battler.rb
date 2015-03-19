#==============================================================================
# ** Game_Battler (part 1)
#==============================================================================

# STATS

class Game_Battler
 
  attr_reader   :battler_name             # battler file name

  attr_reader   :hp                       # HP
  attr_reader   :mp                       # MP

  attr_reader   :states                   # states

  attr_accessor :immortal                 # immortal flag


  attr_accessor :critical                 # critical flag
  
  attr_accessor :collapsing               # collapsing


  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize

    @hp = 0
    @sp = 0

    @states = []
    @states_turn = {}

    @maxhp_plus = 0
    @maxsp_plus = 0
    @str_plus = 0
    @def_plus = 0


    @damage = nil
    @critical = false

    # Current action, remembers for next time also
    @skill_id = 0
    @item_id = 0
    @target_index = -1

  end

  #--------------------------------------------------------------------------
  # * Get Current Experience Points
  #--------------------------------------------------------------------------
  def now_exp 
    return @exp - @exp_list[@level] 
  end
  
  #--------------------------------------------------------------------------
  # * Get Needed Experience Points
  #--------------------------------------------------------------------------
  def next_exp 
    return @exp_list[@level+1] > 0 ? @exp_list[@level+1] - @exp_list[@level] : 0 
  end

  #--------------------------------------------------------------------------
  # * Get Maximum HP
  #--------------------------------------------------------------------------
  def maxhp
    n = [[base_maxhp + @maxhp_plus, 1].max, 999999].min
    for i in @states
      n *= $data_states[i].maxhp_rate / 100.0
    end
    n = [[Integer(n), 1].max, 999999].min
    return n
  end

  #--------------------------------------------------------------------------
  # * Get Maximum SP
  #--------------------------------------------------------------------------
  def maxsp
    n = [[base_maxsp + @maxsp_plus, 0].max, 9999].min
    for i in @states
      n *= $data_states[i].maxsp_rate / 100.0
    end
    n = [[Integer(n), 0].max, 9999].min
    return n
  end

  #--------------------------------------------------------------------------
  # * Get Strength (STR)
  #--------------------------------------------------------------------------
  def str
    n = [[base_str + @str_plus, 1].max, 999].min
    for i in @states
      n *= $data_states[i].str_rate / 100.0
    end
    n = [[Integer(n), 1].max, 999].min
    return n
  end

  #--------------------------------------------------------------------------
  # * Set Maximum HP
  #     maxhp : new maximum HP
  #--------------------------------------------------------------------------
  def maxhp=(maxhp)
    @maxhp_plus += maxhp - self.maxhp
    @maxhp_plus = [[@maxhp_plus, -9999].max, 9999].min
    @hp = [@hp, self.maxhp].min
  end

  #--------------------------------------------------------------------------
  # * Set Maximum SP
  #     maxsp : new maximum SP
  #--------------------------------------------------------------------------
  def maxsp=(maxsp)
    @maxsp_plus += maxsp - self.maxsp
    @maxsp_plus = [[@maxsp_plus, -9999].max, 9999].min
    @sp = [@sp, self.maxsp].min
  end
  #--------------------------------------------------------------------------
  # * Set Strength (STR)
  #     str : new Strength (STR)
  #--------------------------------------------------------------------------
  def str=(str)
    @str_plus += str - self.str
    @str_plus = [[@str_plus, -999].max, 999].min
  end
 
  #--------------------------------------------------------------------------
  # * Get Hit Rate
  #--------------------------------------------------------------------------
  def hit
    n = 100
    for i in @states
      n *= $data_states[i].hit_rate / 100.0
    end
    return Integer(n)
  end

  #--------------------------------------------------------------------------
  # * Get Attack Power
  #--------------------------------------------------------------------------
  def atk
    n = base_atk
    for i in @states
      n *= $data_states[i].atk_rate / 100.0
    end
    return Integer(n)
  end
  #--------------------------------------------------------------------------
  # * Get Physical Defense Power
  #--------------------------------------------------------------------------
  def pdef
    n = base_pdef
    for i in @states
      n *= $data_states[i].pdef_rate / 100.0
    end
    return Integer(n)
  end
  #--------------------------------------------------------------------------
  # * Get Magic Defense Power
  #--------------------------------------------------------------------------
  def mdef
    n = base_mdef
    for i in @states
      n *= $data_states[i].mdef_rate / 100.0
    end
    return Integer(n)
  end
  #--------------------------------------------------------------------------
  # * Get Evasion Correction
  #--------------------------------------------------------------------------
  def eva
    n = base_eva
    for i in @states
      n += $data_states[i].eva
    end
    return n
  end

  #--------------------------------------------------------------------------
  # * Change HP
  #     hp : new HP
  #--------------------------------------------------------------------------
  def hp=(hp)
    @hp = [[hp, maxhp].min, 0].max
    # add or exclude incapacitation
    for i in 1...$data_states.size
      if $data_states[i].zero_hp
        if self.dead?
          add_state(i)
        else
          remove_state(i)
        end
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Change SP
  #     sp : new SP
  #--------------------------------------------------------------------------
  def sp=(sp)
    @sp = [[sp, maxsp].min, 0].max
  end
  #--------------------------------------------------------------------------
  # * Recover All
  #--------------------------------------------------------------------------
  def recover_all
    @hp = maxhp
    @sp = maxsp
    for i in @states.clone
      remove_state(i)
    end
  end


  def dead?() (@hp == 0 and not @immortal) end
  def exist?() (@hp > 0 or @immortal) end
  def hp0?() @hp == 0 end
  def inputable?() restriction <= 1 end
  def movable?() restriction < 4 end



  #--------------------------------------------------------------------------
  # * Check State
  #     state_id : state ID
  #--------------------------------------------------------------------------
  def state?(state_id)
    return @states.include?(state_id)
  end
  #--------------------------------------------------------------------------
  # * Add State
  #     state_id : state ID
  #     force    : forcefully added flag (used to deal with auto state)
  #--------------------------------------------------------------------------
  def add_state(state_id)
    @states.push(state_id)
  end
  #--------------------------------------------------------------------------
  # * Remove State
  #     state_id : state ID
  #     force    : forcefully removed flag (used to deal with auto state)
  #--------------------------------------------------------------------------
  def remove_state(id)
    @states.delete(id)
  end
  #--------------------------------------------------------------------------
  # * Get State Animation ID
  #--------------------------------------------------------------------------
  def state_anim
    # If no states are added
    if @states.size == 0
      return 0
    end
    # Return state animation ID with maximum rating
    return $data_states[@states[0]].animation_id
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

  #--------------------------------------------------------------------------
  # * Apply Skill Effects
  #     user  : the one using skills (battler)
  #     skill : skill
  #--------------------------------------------------------------------------
  def skill_effect(user, skill)
    # Clear critical flag
    self.critical = false
    # If skill scope is for ally with 1 or more HP, and your own HP = 0,
    # or skill scope is for ally with 0, and your own HP = 1 or more
    if ((skill.scope == 3 or skill.scope == 4) and self.hp == 0) or
       ((skill.scope == 5 or skill.scope == 6) and self.hp >= 1)
      # End Method
      return false
    end
    # Clear effective flag
    effective = false
    # Set effective flag if common ID is effective
    effective |= skill.common_event_id > 0
    # First hit detection
    hit = skill.hit
    if skill.atk_f > 0
      hit *= user.hit / 100
    end
    hit_result = (rand(100) < hit)
    # Set effective flag if skill is uncertain
    effective |= hit < 100
    # If hit occurs
    if hit_result == true
      # -------------------------------------------------------------------
      # AGF - See if a weapon can enhance a hero's attack -----------------
      # -------------------------------------------------------------------
      @userid = user.id
      @skillpower = skill.power     

      # Calculate power
      #agf - replaced skill.power with @skillpower for Lydia above
      power = @skillpower + user.atk * skill.atk_f / 100 
      if power > 0
        power -= self.pdef * skill.pdef_f / 200
        power -= self.mdef * skill.mdef_f / 200
        power = [power, 0].max
      end
      # Calculate rate
      rate = 20
      rate += (user.str * skill.str_f / 100)
      rate += (user.agi * skill.agi_f / 100)
      rate += (user.int * skill.int_f / 100)
      # Calculate basic damage
      self.damage = power * rate / 20
      # Element correction
      self.damage *= elements_correct(skill.element_set)
      self.damage /= 100
      # If damage value is strictly positive
      if self.damage > 0
        # Guard correction
        if self.guarding?
          self.damage /= 2
        end
      end
      # Dispersion
      if skill.variance > 0 and self.damage.abs > 0
        amp = [self.damage.abs * skill.variance / 100, 1].max
        self.damage += rand(amp+1) + rand(amp+1) - amp
      end
      # Second hit detection
      eva = 8 * self.agi / user.agi + self.eva
      hit = self.damage < 0 ? 100 : 100 - eva * skill.eva_f / 100
      hit = self.cant_evade? ? 100 : hit
      hit_result = (rand(100) < hit)
      # Set effective flag if skill is uncertain
      effective |= hit < 100
    end
    # If hit occurs
    if hit_result == true
      # If physical attack has power other than 0
      if skill.power != 0 and skill.atk_f > 0
        # State Removed by Shock
        remove_states_shock
        # Set to effective flag
        effective = true
      end
      # Substract damage from HP
      last_hp = self.hp
      # agf: check difficulty level and adjust strength of attack
      mode_adjustment(user)
      
      self.hp -= self.damage
      effective |= self.hp != last_hp
      # State change
      @state_changed = false
      effective |= states_plus(skill.plus_state_set)
      effective |= states_minus(skill.minus_state_set)
      # If power is 0
      if skill.power == 0
        # Set damage to an empty string
        self.damage = ""
        # If state is unchanged (agf - added steal logic)
        unless @state_changed or skill.id == STEAL_SKILL_ID
          # Set damage to "Miss"
          self.damage = "Miss"
        end
      end
    # If miss occurs
    else
      # Set damage to "Miss"
      self.damage = "Miss"
    end
    # If not in battle
    unless $game_temp.in_battle
      # Set damage to nil
      self.damage = nil
    end
    # End Method
    self.critical = false if self.damage == "Miss"
    return effective
  end
  #--------------------------------------------------------------------------
  # * Application of Item Effects
  #     item : item
  #--------------------------------------------------------------------------
  def item_effect(item)
    # Clear critical flag
    self.critical = false
    # If item scope is for ally with 1 or more HP, and your own HP = 0,
    # or item scope is for ally with 0 HP, and your own HP = 1 or more
    if ((item.scope == 3 or item.scope == 4) and self.hp == 0) or
       ((item.scope == 5 or item.scope == 6) and self.hp >= 1)
      # End Method
      return false
    end
    # Clear effective flag
    effective = false
    # Set effective flag if common ID is effective
    effective |= item.common_event_id > 0
    # Determine hit
    hit_result = (rand(100) < item.hit)
    # Set effective flag is skill is uncertain
    effective |= item.hit < 100
    # If hit occurs
    if hit_result == true
      # Calculate amount of recovery
      recover_hp = maxhp * item.recover_hp_rate / 100 + item.recover_hp
      recover_sp = maxsp * item.recover_sp_rate / 100 + item.recover_sp
      if recover_hp < 0
        recover_hp += self.pdef * item.pdef_f / 20
        recover_hp += self.mdef * item.mdef_f / 20
        recover_hp = [recover_hp, 0].min
      end
      # Element correction
      recover_hp *= elements_correct(item.element_set)
      recover_hp /= 100
      recover_sp *= elements_correct(item.element_set)
      recover_sp /= 100
      # Dispersion
      if item.variance > 0 and recover_hp.abs > 0
        amp = [recover_hp.abs * item.variance / 100, 1].max
        recover_hp += rand(amp+1) + rand(amp+1) - amp
      end
      if item.variance > 0 and recover_sp.abs > 0
        amp = [recover_sp.abs * item.variance / 100, 1].max
        recover_sp += rand(amp+1) + rand(amp+1) - amp
      end
      # If recovery code is negative
      if recover_hp < 0
        # Guard correction
        if self.guarding?
          recover_hp /= 2
        end
      end
      # Set damage value and reverse HP recovery amount
      self.damage = -recover_hp
      # HP and SP recovery
      last_hp = self.hp
      last_sp = self.sp
      self.hp += recover_hp
      self.sp += recover_sp
      effective |= self.hp != last_hp
      effective |= self.sp != last_sp
      # State change
      @state_changed = false
      effective |= states_plus(item.plus_state_set)
      effective |= states_minus(item.minus_state_set)
      # If parameter value increase is effective
      # Shaz - don't allow SP increase for non-SP characters
      if item.parameter_type > 0 and item.parameter_points != 0 and
        (item.parameter_type != 2 or self.maxsp > 0)
        # Branch by parameter
        case item.parameter_type
        when 1  # Max HP
          @maxhp_plus += item.parameter_points
        when 2  # Max SP
          @maxsp_plus += item.parameter_points
        when 3  # Strength
          @str_plus += item.parameter_points
        when 4  # Dexterity
          #@dex_plus += item.parameter_points
        when 5  # Agility
          @agi_plus += item.parameter_points
        when 6  # Intelligence
          @int_plus += item.parameter_points
        end
        # Set to effective flag
        effective = true
      end
      # If HP recovery rate and recovery amount are 0
      if item.recover_hp_rate == 0 and item.recover_hp == 0
        # Set damage to empty string
        self.damage = ""
        # If SP recovery rate / recovery amount are 0, and parameter increase
        # value is ineffective.
        if item.recover_sp_rate == 0 and item.recover_sp == 0 and
           (item.parameter_type == 0 or item.parameter_points == 0)
          # If state is unchanged
          unless @state_changed
              self.damage = "Miss"
          end
        end
      end
    # If miss occurs
    else
      # Set damage to "Miss"
      self.damage = "Miss"
    end
    # If not in battle
    unless $game_temp.in_battle
      # Set damage to nil
      self.damage = nil
    end
    # End Method
    self.critical = false if self.damage == "Miss"
    return effective
  end

  #--------------------------------------------------------------------------
  # * Application of Slip Damage Effects
  #--------------------------------------------------------------------------
  def slip_damage_effect
    # Set damage
    self.damage = self.maxhp / 20 # 10
    # Dispersion
    if self.damage.abs > 0
      amp = [self.damage.abs * 15 / 100, 1].max
      self.damage += rand(amp+1) + rand(amp+1) - amp
    end
    # Subtract damage from HP
    self.hp -= self.damage
    # End Method
    return true
  end
  #--------------------------------------------------------------------------
  # * Calculating Element Correction
  #     element_set : element
  #--------------------------------------------------------------------------
  def elements_correct(element_set)
    # If not an element
    if element_set == []
      # Return 100
      return 100
    end
    # Return the weakest object among the elements given
    # * "element_rate" method is defined by Game_Actor and Game_Enemy classes,
    #    which inherit from this class.
    weakest = -100
    for i in element_set
      weakest = [weakest, self.element_rate(i)].max
    end
    return weakest
  end

end
