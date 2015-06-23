#==============================================================================
# ** Game_Battler (part 1)
#==============================================================================

# STATS

class Game_Battler
 
  attr_reader :id, :name, :level

  attr_reader :transform

  attr_accessor :action, :skill_id, :item_id
  attr_accessor :target
  attr_accessor :target_type, :target_idx
  attr_accessor :ev

  attr_reader :hp, :mp

  attr_reader :slots, :equips

  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize

    @is_actor = true
    @transform = nil

    # Current values
    @hp = 0
    @mp = 0

    @restype = nil#data.resource

    # Enemy values and also bonus for player
    @stat_plus = {}
    @stat_mods = {}
   
    @xp = 0
    @level = 1

    @equips = {}

    @states = []
    @states_turn = {}

    @skills = []
    @skill_cooldown = {}

    # Skill selection
    @action = nil
    @skill_id = nil
    @item_id = nil

    @target = nil
    @target_type = nil # <-- Scope?
    @target_index = -1

    @ev = nil # Mid battle hold even number for easy access

    @form = nil # <- fox or frog or etc, maybe for battler? turn enemy to frog he shoot water at you? interesting

    recover_all

  end

  def is_actor?
    return @is_actor
  end

  def init_actor(id)

    @is_actor = true

    data = $data.actors[id]
    @id = id

    @looklike = id

    @name = data.name

    @slots = data.slots.split(" | ")

    # Prepare equipment slots
    @slots.each{ |s|
      @equips[s] = nil
    }
    
    @actions = data.actions.split(" | ")

    # Add actions as skills, maybe not now, only when checking
    #@actions.each{ |a| @skills.push(a) }

    # Prepare stat mods per character
    if data.mods != ""
      data.mods.split("\n").each{ |m|
        md = m.split("=>")
        @stat_mods[md[0]] = md[1].to_i
        log_info @stat_mods
      }
    end


  end

  def init_enemy(id)

    @is_actor = false

    data = $data.enemies[id]
    @id = id

    # Get stat plus per enemy
    if data.stats != ""
      data.stats.split("\n").each{ |m|
        md = m.split("=>")
        @stat_plus[md[0]] = md[1].to_i
      }
    end

  end
  
  def is_actor?
    return @is_actor
  end

  def actions
    if !@transform
      return @actions
    else
      return $data.actors[@transform].actions.split(" | ")
    end
  end

  #--------------------------------------------------------------------------
  # * Transform into something
  #--------------------------------------------------------------------------
  
  def transform(into)

    @transform = into

    @transform = nil if @transform == 'nil'
    log_scr("TRANSFORM NOW")

    if @transform != nil

      ev.character_name = "Player/#{@id}-#{into}"
      ev.direction = 4

    else

      ev.character_name = "Player/#{@id}-idle"

    end

  end

  def fall
    ev.character_name = "Player/#{@id}-down"
  end

  #--------------------------------------------------------------------------
  # * Recover All
  #--------------------------------------------------------------------------
  def recover_all
    @hp = maxhp
    @mp = maxmp
   # for i in @states.clone
   #   remove_state(i)
   # end
  end

  
  def damage(amount)
    @hp -= amount
    @hp = 0 if @hp < 0
  end

  def heal(amount)

  end



  # perhamps cut these things
  def down?
    @hp == 0 
  end
  def attackable?
    return !down?
  end

  def can_attack?
    return !down?
  end


end
