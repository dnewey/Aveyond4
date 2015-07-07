
class Game_Battle

  attr_accessor :map, :weather

  attr_reader :enemies
  attr_reader :enemy_types
  attr_reader :enemy_list
  attr_reader :queue2

	def initialize

    @enemy_types = []

    @enemy_list = []    
		@enemies = []

    @props = []

    @actor_index = 0

    @queue2 = nil

    @map = 26#65 #26
	end

  # Enemies for this zone from zone data
  def change_enemies(enemies)
    @enemy_types = enemies.split("\n")
  end

  def clear
    @enemy_list = []
    @enemies = []
    @props = []
    @queue2 = nil
  end

  def add(enemy)
    battler = Game_Battler.new
    battler.init_enemy(enemy)
    @enemy_list.push(enemy)
    @enemies.push(battler)
  end

  def queue(enemy_id,skill)
    @queue2 = [enemy_id,skill]
  end

  def setup(src_event)

    # Find all enemies in the group
    $map.all_by_name(src_event.name).each{ |mon|

      # Add this guy to battle using name
      enemy = mon.monster
      add(enemy)

    }

    start

  end

  def replace_with_loot(src_event)

    $map.all_by_name(src_event.name).each{ |mon|
      # Add this guy to battle using name
      mon.force_clone("loot")
    }

  end

  def xp_total
    total = 0
    log_sys(@enemies)
    @enemies.each{ |enemy|
      total += enemy.xp.to_i if enemy.xp != nil
    }
    return total
  end

  def loot_for(src_event)
    data = $data.enemies[src_event.monster]

    # Check drops first
    if data.drops != nil
      data.drops.split("/n").each{ |item|

        log_sys(item)
        # If possible, give it
        dta = item.split("=>")
        type = dta[1]
        req = dta[2]
        chance = dta[3].to_f
        next if rand > chance
        pass = case type
            when 'q'
              $progress.quest_active?(req)
            when 'f'
              $state.flag?(req)
            when 'i'
              $party.has_item?(req)
          end
        if pass
          return item(dta[0])
        end
      }
    end

    # Check gold
    if data.gold != nil
      dta = data.gold.split("=>")
      golds = dta[0].split("-")
      chance = dta[1].to_f
      log_info(chance)
      if rand <= chance
        if golds.count == 1
          return gold(golds[0].to_i)
        else
          return gold(golds[0].to_i + rand(golds[1].to_i-golds[0].to_i))
        end
      end
    end

    # Check loot
    if data.loot != nil
      possible = []
      data.loot.split("/n").each{ |item| 
        dta = item.split("=>")
        dta[1].to_i.times{
          possible.push(dta[0])
        }
      }
      return item(possible.sample)
    end

    # Nothing!
    pop_nothing    

  end

  def start
    $scene.hud.hide
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

    skill = nil
    if attacker.action == "items"
      skill = $data.items[attacker.item_id]
    else
      skill = $data.skills[attacker.skill_id]
    end

    # How many times does this skill hit
    hits = calc_hits(skill)

    hits.times{ |t|

      round = Attack_Round.new
      round.text = skill.text if skill.text && skill.text.length > 0
      round.anim = skill.anim
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

      # Items have actions, skills have effects, they are the same
      effects = nil
      if skill.is_a?(UsableData)
        effects = skill.action
      else
        effects = skill.effects
      end

      effects.split("\n").each{ |effect|
        data = effect.split("=>")      
        case data[0]
          when 'dmg-base'
            dmg_base = data[1].to_i
          when 'dmg-mod'
            dmg_mod = data[1].to_f
          when 'gain-mana'
            result.gain_mana = data[1].to_i
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
      result.damage -= (t.def) # Remove damage of the defense

      # If there was no attack, don't have a damage amount
      if result.damage == 0
        result.damage = nil
      end

      results.push(result)

    }

    return results    

  end

  def possible_targets(attacker)

    data = nil
    if attacker.action == "items"
      data = $data.items[attacker.item_id]
    else
      data = $data.skills[attacker.skill_id]
    end

    if data.scope == 'one'
      return $battle.enemies
    elsif data.scope == 'ally'
      return $party.active_battlers
    end

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
          return [$party.active_battlers.select{ |b| b.attackable? }.sample]
        end

      when 'two'

        # Random 2
        if attacker.is_actor?
          return @enemies.select{ |b| b.attackable? }.sample(2)
        else
          return $party.active_battlers.select{ |b| b.attackable? }.sample(2)
        end

      when 'three'

        # Random 3
        if attacker.is_actor?
          return @enemies.select{ |b| b.attackable? }.sample(3)
        else
          return $party.active_battlers.select{ |b| b.attackable? }.sample(3)
        end

      when 'all'

        # All enemy
        if attacker.is_actor?
          return @enemies.select{ |b| b.attackable? }
        else
          return $party.active_battlers.select{ |b| b.attackable? }
        end

      when 'party'

        # All allies
        if attacker.is_actor?
          return $party.active_battlers.select{ |b| b.attackable? }
        else          
          return @enemies.select{ |b| b.attackable? }
        end

      when 'self'

        return [attacker]

    end

    return []

  end

  def calc_hits(skill)
    log_sys(skill)
    return 1 if skill.is_a?(UsableData)
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