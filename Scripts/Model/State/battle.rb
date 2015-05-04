
class Game_Battle

  attr_accessor :map, :weather

  attr_reader :enemies

	def initialize
		@enemies = []
    @props = []
    @actor_index = 0

    @map = 26
	end

  def add(enemy)
    battler = Game_Battler.new
    battler.init_enemy(enemy)
    @enemies.push(battler)
  end

  def start
    $game.push_scene(Scene_Battle.new)
  end

  def win?
    return false
  end


  def build_attack_queue

    return [$party.actor_by_id("boy")]

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


    return plan

  end

  def build_attack_results(attacker,skill)

    results = []

    # Attack already has skill selected, and targets if scope requires
    targets = build_target_list(attacker,skill)

    # Calculate damage per target i suppose
    targets.each{ |t|

      result = Attack_Result.new

      result.target = t
      result.damage = 154


      results.push(result)

    }

    return results    

  end

  def build_target_list(attacker,skill)

    # Get scope, prepare targets, return list
    case skill.scope

      when 'one', 'ally', 'down'

        # Will be in attacker, already chosen
        return [attacker.target]

      when 'random'

        if attacker.is_actor?
          return @enemies.select{ |b| b.attackable? }.sample
        else
          return $party.active.select{ |b| b.attackable? }.sample
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


# BATTLE SYSTEM!!!!!!!!

# THEN START BUILDING THE ACTIONS ARRAY
# WILL BE EASY AS
  
# Can't calc damage or anything yet
# Can only make a list of skills
# [hit,hit,heal]

# Then play it out
# Cacl the results at the start of each attack
# Instead of at the start of the whole thing