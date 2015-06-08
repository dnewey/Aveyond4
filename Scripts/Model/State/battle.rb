
class Game_Battle

  attr_accessor :map, :weather

  attr_reader :enemies
  attr_reader :enemy_types
  attr_reader :enemy_list

	def initialize
    @enemy_types = []
    @enemy_list = []
		@enemies = []
    @props = []
    @actor_index = 0

    @map = 65 #26
	end

  # Enemies for this zone from zone data
  def change_enemies(enemies)
    @enemy_types = enemies.split("\n")
  end

  def add(enemy)
    battler = Game_Battler.new
    battler.init_enemy(enemy)
    @enemy_list.push(enemy)
    @enemies.push(battler)
  end

  def start
    $game.push_scene(Scene_Battle.new)
  end

  def victory?
    return @enemies.select{ |e| !e.down? }.empty?
  end


  def build_attack_queue

    return ($party.active_battlers + @enemies).shuffle

  end

  def build_attack_plan(attacker)

    plan = Attack_Plan.new

    skill = $data.skills[attacker.skill_id]
    hits = calc_hits(skill)

    hits.times{ |t|

      round = Attack_Round.new
      round.anim_a = skill.anim_a
      round.anim_b = skill.anim_b
      round.skill = skill

      plan.add(round)
    }

    # Add followup attacks


    # Use up the item or mana for the skill used
    # Put it in the attack plan probably


    return plan

  end

  # Happens at the time of using the skill
  # Uses states applied etc realtime
  def build_attack_results(attacker,skill)

    results = []

    # Attack already has skill selected, and targets if scope requires
    targets = build_target_list(attacker,skill)

    # Calculate damage per target i suppose
    targets.each{ |t|

      result = Attack_Result.new

      result.target = t
      # Check damage effects

      dmg_base = 0
      dmg_mod = 0

      skill.effects.split("\n").each{ |effect|
        data = effect.split("=>")      
        case data[0]
          when 'dmg-base'
            dmg_base = data[1].to_i
          when 'dmg-mod'
            dmg_mod = data[1].to_f
          when 'state-add'
            result.state_add = data[1]
          when 'state-remove'
            result.state_remove = data[1]
          when 'transform'
            result.transform = data[1]
        end
      }

      # Build final damage
      result.damage = dmg_base + (attacker.str * dmg_mod)

      results.push(result)

    }

    return results    

  end

  def build_target_list(attacker,skill)

    # Get scope, prepare targets, return list
    case skill.scope

      when 'one', 'ally', 'down'

        # Will be in attacker, already chosen
        targets = [attacker.target]

        # If the target is not attackable, do somethingelse
        # TODO TODO
        return targets

      when 'rand' # Single random target

        if attacker.is_actor?
          return [@enemies.select{ |b| b.attackable? }.sample]
        else
          return [$party.active.select{ |b| b.attackable? }.sample]
        end

      when 'two'

        # Random 2
        if attacker.is_actor?
          return @enemies.select{ |b| b.attackable? }.sample(2)
        else
          return $party.active.select{ |b| b.attackable? }.sample(2)
        end

      when 'three'

        # Random 3
        if attacker.is_actor?
          return @enemies.select{ |b| b.attackable? }.sample(3)
        else
          return $party.active.select{ |b| b.attackable? }.sample(3)
        end

      when 'all'

        # All enemy
        if attacker.is_actor?
          return @enemies.select{ |b| b.attackable? }
        else
          return $party.active.select{ |b| b.attackable? }
        end

      when 'party'

        # All allies
        if attacker.is_actor?
          return $party.active.select{ |b| b.attackable? }
        else          
          return @enemies.select{ |b| b.attackable? }
        end

      when 'self'

        return [attacker]

    end

    return []

  end

  def calc_hits(skill)
    hits = skill.hits
    if hits.include?("-")
      data = hits.split("-")
      low = data[0].to_i
      high = data[0].to_i
      return low + rand(hi-low)
    else
      return skill.hits.to_i
    end
  end



  def get_targetable(attacker)

    case $data.skills(attack.skill_id).scope

      when 'one'

      when 'ally'

      when 'down'

    end

  end

  
end