#==============================================================================
# ** Game_Battler (part 1)
#==============================================================================

class Game_Battler
 
  attr_reader :id, :name, :level

  attr_accessor :action, :skill_id, :item_id
  attr_accessor :target
  attr_accessor :scope, :target_idx
  attr_accessor :ev, :view

  attr_reader :hp, :mp, :xp

  attr_reader :slots, :equips

  #-------------------------------------------------------------------------
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
        @stat_mods[md[0]] = md[1].to_f
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

    @actions = data.actions.split(" | ")

    # Get stat plus per enemy
    if data.stats != ""
      data.stats.split("\n").each{ |m|
        md = m.split("=>")
        @stat_plus[md[0]] = md[1].to_i
      }
    end

    recover_all

  end

  def init_ally(id)

    @type = :ally

    data = $data.enemies[id]
    @id = id

    @name = data.name

    @xp = data.xp

    @actions = data.actions.split(" | ")

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

  def get_actions
    if !@transform
      if @id == 'hib'

        case @equips['book']
          when 'hib-book-ice'
            return ['chant','bk-ice-1','bk-ice-2','items']
          when 'hib-book-dmg'
            return ['chant','bk-dmg-1','bk-dmg-2','items']
          when 'hib-book-heal'
            return ['chant','bk-heal-1','bk-heal-2','items']
          when 'hib-book-help'
            return ['chant','bk-help-1','bk-help-2','items']
          when 'hib-book-sleep'
            return ['chant','bk-sleep-1','bk-sleep-2','items']
        end

      else

        return @actions

      end

    else

      return $data.actors[@transform].actions.split(" | ")

    end

  end



  #--------------------------------------------------------------------------
  # * Transform into something
  #--------------------------------------------------------------------------
  
  def get_transform
    return @transform
  end

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
    @hp = maxhp
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


  # Return priority of current attack
  def attack_priority

    if @action == "items"
      return $data.items[@item_id].priority
    else
      return $data.skills[@skill_id].priority
    end

  end


  def attack_sfx

    if @transform

      case @transform

        when 'x-fox'
          sfx ['mys1','mys2'].sample

      end

      return

    end

    # Normal noise
    case @id

      # Players
      when 'mys'

      # Minions
      when 'minion-fang'
        sfx ['fang-1','fang-2'].sample
      when 'minion-colby'
        sfx 'rat'        





      # Enemies      



    end

  end

end
