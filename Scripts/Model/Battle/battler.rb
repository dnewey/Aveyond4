#==============================================================================
# ** Game_Battler (part 1)
#==============================================================================

# STATS

class Game_Battler
 
  attr_reader :id
  attr_reader :actions

  attr_accessor :action, :skill_id, :item_id
  attr_accessor :target
  attr_accessor :target_type, :target_idx
  attr_accessor :ev
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize

    @is_actor = true

    # Current values
    @hp = 0
    @mp = 0

    @restype = nil#data.resource

    # Stats - enemy base and player bonus    
    @hp_init, @mp_init, @atk_init, @def_init = 0, 0, 0, 0
    @hp_rate, @mp_rate, @atk_rate, @def_rate = 0, 0, 0, 0
    @hp_plus,  @mp_plus, @atk_plus, @def_plus = 0, 0, 0, 0

    @xp = 0
    @level = 1

    @equips = {}

    @states = []
    @states_turn = {}

    @skills = []
    @skill_cooldown = {}

    # Skill selection
    @action = 0
    @skill_id = 0

    @target = nil
    @target_type = nil # <-- Scope?
    @target_index = -1

    @ev = nil # Mid battle hold even number for easy access

    @form = nil # <- fox or frog or etc, maybe for battler? turn enemy to frog he shoot water at you? interesting

  end

  def init_actor(id)

    @is_actor = true

    data = $data.actors[id]
    @id = id

    @name = data.name

    # Prepare equipment slots
    data.slots.split(" | ").each{ |s|
      @equips[s] = nil
    }
    
    @actions = data.actions.split(" | ")

    # Add actions as skills, maybe not now, only when checking
    @actions.each{ |a| @skills.push(a) }

  end

  def init_enemy(id)

    @is_actor = false

  end
  
  def is_actor?
    return @is_actor
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

  # perhamps cut these things
  def down?
    @hp == 0 
  end
  def attackable?
    return !down?
  end

  def inputable?() restriction <= 1 end
  def movable?() restriction < 4 end  


  # PROBABLY DON'T HAVE THIS HERE
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


end
