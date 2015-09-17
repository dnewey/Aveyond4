#==============================================================================
# ** Game_Battler (part 1)
#==============================================================================

class Game_Battler
 
  attr_reader :id, :name, :level

  attr_reader :transform

  attr_accessor :action, :skill_id, :item_id
  attr_accessor :target
  attr_accessor :scope, :target_idx
  attr_accessor :ev, :view

  attr_reader :hp, :mp, :xp

  attr_reader :slots, :equips

  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize

    @type = :actor

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
    @states_counter = {}

    @skills = []
    @cooldowns = {}

    # Skill selection
    @action = nil
    @skill_id = nil
    @item_id = nil

    @target = nil
    @scope = nil # <-- Scope?
    @target_index = -1

    @ev = nil # Mid battle hold event number for easy access
    @view = nil # Hold charview for quick access

    @form = nil # <- fox or frog or etc, maybe for battler? turn enemy to frog he shoot water at you? interesting


  end

  def init_actor(id)

    @type = :actor

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
      }
    end

    recover_all

  end

  def init_enemy(id)

    @type = :enemy

    data = $data.enemies[id]
    @id = id

    @name = data.name

    @xp = data.xp

    # Get stat plus per enemy
    if data.stats != ""
      data.stats.split("\n").each{ |m|
        md = m.split("=>")
        @stat_plus[md[0]] = md[1].to_i
      }
    end

    recover_all

  end

  def init_minion(id)

    @type = :minion

    data = $data.actors[id]
    @id = id

    @name = data.name
    
    @actions = data.actions.split(" | ")

    # Prepare stat mods per character
    if data.mods != ""
      data.mods.split("\n").each{ |m|
        md = m.split("=>")
        @stat_mods[md[0]] = md[1].to_i
      }
    end

    recover_all

  end

  def is_good?
    return !is_enemy?
  end
  
  def is_actor?
    return @type == :actor
  end

  def is_minion?
    return @type == :minion
  end

  def is_enemy?
    return @type == :enemy
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

    @transform = 'x-'+into

    @transform = nil if into == 'nil'

    if @transform != nil
      ev.character_name = "Player/#{@id}-#{@transform}"
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
    @hp = maxhp / 2
    if ['ing','hib'].include?(@id)
      @mp = maxmp
    end
   # for i in @states.clone
   #   remove_state(i)
   # end
  end
  
  def damage(amount)
    @hp -= amount
    @hp = 0 if @hp < 0
  end

  def heal(amount)
    @hp += amount
    @hp = maxhp if @hp > maxhp
  end

  def gain_mana(amount)
    @mp+=amount
    @mp = maxmp if @mp > maxmp
  end

  def lose_mana(amount)
    @mp-=amount
    @mp = 0 if @mp < 0
  end



  # perhamps cut these things
  def down?
    @hp <= 0 
  end
  
  def attackable?
    return !down?
  end

  def can_attack?

    # Any states stopping this?
    return false if !@states.select{ |s| s.stun }.empty?

    return !down?

  end


  def resource

    case id
      when 'boy'
        return :sp
      when 'ing','hib'
        return :mp
      when 'phy'
        return :rp
      else
        return nil
    end

  end


end
