
class Game_Battle

  attr_accessor :map, :weather

  attr_reader :enemies
  attr_reader :minion

  attr_reader :allies

  attr_reader :enemy_types # Enemies for the current zone
  attr_reader :enemy_list # 

  attr_reader :queue # Battle actions, texts and skills

  attr_accessor :next_map

  attr_accessor :victory_text

	def initialize

    @enemy_types = []

    @enemy_list = []
		@enemies = []

    @allies = []

    @props = []

    @actor_index = 0

    @queue = {} # Should it have turn #?

    @skip_minion = false # Don't have minion next battle

    @default_map = 65
    @zone_maps = []
    @next_map = nil

    @victory_text = nil

	end

  # Enemies for this zone from zone data
  def change_enemies(enemies)
    @enemy_types = enemies.split("\n")
  end

  def clear
    @skip_minion = false # Put minion back on
    @enemy_list = []
    #@enemies.each{ |e| e.dispose }
    @enemies = []
    #@props.each{ |p| p.dispose }
    @allies = []
    @props = []
    @queue = {}
    $party.all_battlers.each{ |a| a.ev = nil; a.view = nil }
  end

  def change_maps(maps)
    @zone_maps = maps
  end

  def add(enemy)
    battler = Game_Battler.new
    battler.init_enemy(enemy)
    @enemy_list.push(enemy)
    @enemies.push(battler)
  end

  def add_ally(ally)
    battler = Game_Battler.new
    battler.init_ally(ally)
    @allies.push(battler)
  end

  def skip_minion
    @skip_minion = true
  end

  # Queue up skills to use before battle starts
  def queue_skill(enemy_id,skill_id,turn=1)
    @queue[turn] = [] if !@queue.has_key?(turn)
    @queue[turn].push([:skill,enemy_id,skill_id])
  end

  # Queue up text for scene before battle
  def queue_text(txt,turn=1)
    @queue[turn] = [] if !@queue.has_key?(turn)
    @queue[turn].push([:text,txt])
  end

  def queue_escape(turn=1)
    @queue[turn] = [] if !@queue.has_key?(turn)
    @queue[turn].push([:escape])
  end

  def queue_join(who,turn=1)
    @queue[turn] = [] if !@queue.has_key?(turn)
    @queue[turn].push([:join,who])
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
      $state.nospawn(mon.id) if !src_event.name.include?("*")
      mon.force_clone("loot")
    }

  end

  def xp_total
    total = 0
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

    # Cutting gold chance
    chance = rand

    if chance < 0.12

        # Nothing!
        return pop_nothing         

    end

    if chance < 0.6 && data.loot != nil && data.loot != ''
      possible = []
      data.loot.split("/n").each{ |item| 
        dta = item.split("=>")
        dta[1].to_i.times{
          possible.push(dta[0])
        }
      }
      log_info(possible)
      return item(possible.sample)
    end

    # Check gold
    if data.gold != nil && data.gold != ''
      golds = data.gold.split("-")
      return gold(golds[0].to_i + rand(1+golds[1].to_i-golds[0].to_i))
    end


    return pop_nothing 

  end

  def start

    # Prep the minion
    min = $party.get('boy').slot('minion')
    min = nil if @skip_minion
    if min == nil
      @minion = nil
    else
      @minion = $party.get(min.sub("boy-",""))
    end

    # Set the map for this battle, whether custom or from zone data
    if @next_map
      @map = @next_map
      @next_map = nil
    else
      if @zone_maps
        @map = @zone_maps.split(",").sample.to_i
      else
        @map = @default_map
      end
    end

    $scene.hud.hide
    $scene.overlay.opacity = 0
    $game.push_scene(Scene_Battle.new)

    # Fade in from black
    $scene.black.opacity = 255
    $scene.black.do(to("opacity",0,-5))
    
  end

  def victory?
    return @enemies.select{ |e| !e.down? }.empty?
  end


  def build_attack_queue

    @allies = [] if @allies == nil
    queue = $party.active_battlers + @allies + @enemies 

    # Add minion if there is
    if $party.active.include?('boy') && $battle.minion != nil
      minion = $party.get('boy').slot('minion')
      minion = minion.sub("boy-","")
      queue.push($party.get(minion))
    end

    queue.sort_by{ rand }

    # Sort by priority, random within same
    return queue.sort_by{ |battler| battler.attack_priority }


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
      dmg_p = 0.0
      dmg_mod = 0.0 # 1.0 is use str number as damage

      heal_base = 0
      heal_p = 0.0

      is_dmg = false
      is_heal = false

      # Specials
      is_half_armor = true
      empower = false

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
          
          # Damage
          when 'dmg-base'
            dmg_base = data[1].to_i
            is_dmg = true
          when 'dmg-p'
            dmg_p = data[1].to_i
            is_dmg = true
          when 'dmg-mod'
            dmg_mod = data[1].to_f
            is_dmg = true

          # Heals
          when 'heal'
            heal_base = data[1].to_i
            is_heal = true
          when 'heal-p'
            heal_p = data[1].to_f
            is_heal = true

          # Mana
          when 'gain-mana'
            result.gain_mana = data[1].to_i

          # States
          when 'state-add'
            result.state_add = data[1]
          when 'state-remove'
            result.state_remove = data[1]

          # Misc
          when 'transform'
            result.transform = data[1]
          when 'half-armor'
            is_half_armor = true
          when 'empower'
            empower = true


        end
      }

      # ---------------------------------------------
      # CRITS, EVADES, RESISTS
      # ---------------------------------------------

      # Calc evade
      result.evade = rand(100) < t.eva
      result.evade = false if is_heal

      # Calc crit
      result.critical = rand(100) < t.luk
      result.critical = false if result.evade

      # Calc resist if state added and its a bad one?
      if !result.state_add != nil
        if !['minion-double','crit','protect'].include?(result.state_add)
          result.resist = rand(100) < t.res
          result.state_add = nil
        end
      end

      # --------------------------------------------
      # DAMAGE
      # --------------------------------------------
      # Calc Damage
      result.damage = dmg_base + (attacker.str * dmg_mod)
      result.damage += t.maxhp * dmg_p

      # Add variation
      variation = result.damage * 0.2
      result.damage = (result.damage - variation/2) + (variation * rand)

      # Reduce by armor, less sometimes
      if is_half_armor
        result.damage -= (t.def/2) 
      else
        result.damage -= (t.def)
      end

      # Critical effect
      result.damage *= 1.8 if result.critical

      
      # ---------------------------------------------
      # HEALING
      # ---------------------------------------------
      result.heal = heal_base
      result.heal += t.maxhp * heal_p
      result.heal *= 1.5 if result.critical

      # ---------------------------------------------
      # TIDY
      # ---------------------------------------------

      # If there was no attack, don't have a damage amount
      if result.damage <= 0
        result.damage = is_dmg ? 1 : 0
      end

      if result.evade
        result.damage = 0
      end

      # ---------------------------------------------
      # CUSTOMS
      # ---------------------------------------------

      # Custom hacking
      if skill.id == 'pounce' 
        if t.state?('bleed')
          result.damage *= 2
        end
      end

      if empower
        result.empower = true
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
      return $battle.attackable_enemies
    elsif data.scope == 'ally' || data.scope == 'down'
      return $party.attackable_battlers
    end

  end

  def build_target_list(attacker,skill)

    # Get scope, prepare targets, return list
    case attacker.scope

      when 'one', 'ally', 'down'

        # Will be in attacker, already chosen
        targets = [attacker.target]

        # If the target is not attackable, do somethingelse
        # TODO TODO
        return targets

      when 'rand' # Single random target

        if attacker.is_good?
          return [@enemies.select{ |b| b.attackable? }.sample]
        else
          return [$party.active_battlers.select{ |b| b.attackable? }.sample]
        end

      when 'two'

        # Random 2
        if attacker.is_good?
          return @enemies.select{ |b| b.attackable? }.sample(2)
        else
          return $party.active_battlers.select{ |b| b.attackable? }.sample(2)
        end

      when 'three'

        # Random 3
        if attacker.is_good?
          return @enemies.select{ |b| b.attackable? }.sample(3)
        else
          return $party.active_battlers.select{ |b| b.attackable? }.sample(3)
        end

      when 'all'

        # All enemy
        if attacker.is_good?
          return @enemies.select{ |b| b.attackable? }
        else
          return $party.active_battlers.select{ |b| b.attackable? }
        end

      when 'party'

        # All allies
        if attacker.is_good?
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
    return 1 if skill.is_a?(UsableData)
    hits = skill.hits
    if hits.include?("-")
      data = hits.split("-")
      low = data[0].to_i
      high = data[0].to_i
      return (low + rand(high-low)).ceil
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

  def attackable_enemies
    return @enemies.select{ |a| a.attackable? }
  end

  def all_battlers
    return @enemies + $party.all_battlers
  end
  
end