#==============================================================================
# ** Game_Party
#==============================================================================

class Game_Party

  attr_accessor :actors                   # actors
  attr_accessor :reserve                  # reserve party

  attr_reader   :gold                     # amount of gold
  attr_reader   :steps                    # number of steps

  attr_accessor :all_actors

  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize

    # Create all actors    
    @actors = {}
    $data.actors.each{ |k,v| @actors[k] = Game_Actor.new(k) }    

    # Create actor array
    @active = []
    @reserve = []

    # Initialize amount of gold and steps
    @gold = 0
    @steps = 0

    # Create amount in possession hash for items, weapons, and armor
    @items = {}
    @weapons = {}
    @armors = {}
    
    # TEMP DISABLE
    add_actor("boyle")

  end

  #--------------------------------------------------------------------------
  # * Getting Maximum Level
  #--------------------------------------------------------------------------
  def max_level
    return @actors.max_by(&:level)
  end

  #--------------------------------------------------------------------------
  # * Add an Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def add_actor(actor)

    if @active.size < 4 and not @actors.include?(actor)
      
      @ctive.push(actor)
      
      $player.refresh
    end
   if !@active.include?(actor)
      @reserve.push(actor)
    end

  end

  #--------------------------------------------------------------------------
  # ● Add an Actor in the Reserve Party
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def add_reserve(actor)
    @reserve.push(actor)
  end

  #--------------------------------------------------------------------------
  # * Remove Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def remove_actor(actor)
    @actors.delete(actor)
    @reserve.delete(actor)
  end

 def add_gold(n)
    @gold += n
    $game_map.need_hud_refresh = true # Shaz
  end

 def remove_gold(n)
    gain_gold(-n)
  end

  #--------------------------------------------------------------------------
  # * Increase Steps
  #--------------------------------------------------------------------------
  def increase_steps
    @steps += 1
  end

  #--------------------------------------------------------------------------
  # * Get Number of Items Possessed
  #--------------------------------------------------------------------------
  def item_number(item)
    return @items.has_key?(item) ? @items[item] : 0
  end

  #--------------------------------------------------------------------------
  # * Get Number of Weapons Possessed
  #     weapon_id : weapon ID
  #--------------------------------------------------------------------------
  def weapon_number(weapon)
    return @weapons.has_key?(weapon) ? @weapons[weapon] : 0
  end

  #--------------------------------------------------------------------------
  # * Get Amount of Armor Possessed
  #     armor_id : armor ID
  #--------------------------------------------------------------------------
  def armor_number(armor)
    return @armors.has_key?(armor) ? @armors[armor] : 0
  end

  #--------------------------------------------------------------------------
  # * Gain Items (or lose)
  #--------------------------------------------------------------------------
  def add_item(item, n)
    @items[item] = [[item_number(item) + n, 0].max, 99].min
  end

  #--------------------------------------------------------------------------
  # * Gain Weapons (or lose)
  #     weapon_id : weapon ID
  #     n         : quantity
  #--------------------------------------------------------------------------
  def gain_weapon(weapon_id, n)
    # Update quantity data in the hash.
    if weapon_id > 0
      @weapons[weapon_id] = [[weapon_number(weapon_id) + n, 0].max, 99].min
    end
  end

  #--------------------------------------------------------------------------
  # * Gain Armor (or lose)
  #     armor_id : armor ID
  #     n        : quantity
  #--------------------------------------------------------------------------
  def gain_armor(armor_id, n)
    # Update quantity data in the hash.
    if armor_id > 0
      @armors[armor_id] = [[armor_number(armor_id) + n, 0].max, 99].min
    end
  end

  #--------------------------------------------------------------------------
  # * Lose Items
  #     item_id : item ID
  #     n       : quantity
  #--------------------------------------------------------------------------
  def lose_item(item_id, n)
    # Reverse the numerical value and call it gain_item
    gain_item(item_id, -n)
  end

  #--------------------------------------------------------------------------
  # * Lose Weapons
  #     weapon_id : weapon ID
  #     n         : quantity
  #--------------------------------------------------------------------------
  def lose_weapon(weapon_id, n)
    # Reverse the numerical value and call it gain_weapon
    gain_weapon(weapon_id, -n)
  end

  #--------------------------------------------------------------------------
  # * Lose Armor
  #     armor_id : armor ID
  #     n        : quantity
  #--------------------------------------------------------------------------
  def lose_armor(armor_id, n)
    # Reverse the numerical value and call it gain_armor
    gain_armor(armor_id, -n)
  end

  #--------------------------------------------------------------------------
  # * Determine if Item is Usable
  #     item_id : item ID
  #--------------------------------------------------------------------------
  def item_can_use?(item)
    return false if item_number(item) == 0
      
    # Get usable time
    occasion = $data.items[item_id].occasion
    # If in battle
    if $game_temp.in_battle
      # If useable time is 0 (normal) or 1 (only battle) it's usable
      return (occasion == 0 or occasion == 1)
    end
    # If useable time is 0 (normal) or 2 (only menu) it's usable
    return (occasion == 0 or occasion == 2)
  end

  #--------------------------------------------------------------------------
  # * Clear All Member Actions
  #--------------------------------------------------------------------------
  def clear_actions
    for actor in @actors
      actor.current_action.clear
    end
  end

  #--------------------------------------------------------------------------
  # * Determine Everyone is Dead
  #--------------------------------------------------------------------------
  def all_dead?
    return false if @active.empty?
    for actor in @active
      return false if @actors[actor].hp > 0
    end
    return true
  end

  #--------------------------------------------------------------------------
  # * Slip Damage Check (for map)
  #--------------------------------------------------------------------------
  def check_map_slip_damage
    for actor in @active + @reserve
      if actor.hp > 0 and actor.slip_damage?
        actor.hp -= [actor.maxhp / 100, 1].max
        if actor.hp == 0
          $audio.play_se($data_system.actor_collapse_se)
        end
        $map.world.start_flash(Color.new(255,0,0,128), 4)
        $temp.gameover = $party.all_dead?
      end
    end
  end

  #--------------------------------------------------------------------------
  # * Random Selection of Target Actor
  #     hp0 : limited to actors with 0 HP
  #--------------------------------------------------------------------------
  def random_target_actor(hp0 = false)
    # Initialize roulette
    roulette = []
    # Loop
    for actor in @actors
      # If it fits the conditions
      if (not hp0 and actor.exist?) or (hp0 and actor.hp0?)
        # Get actor class [position]
        position = $data_classes[actor.class_id].position
        # Front guard: n = 4; Mid guard: n = 3; Rear guard: n = 2
        n = 4 - position
        # Add actor to roulette n times
        n.times do
          roulette.push(actor)
        end
      end
    end
    # If roulette size is 0
    if roulette.size == 0
      return nil
    end
    # Spin the roulette, choose an actor
    return roulette[rand(roulette.size)]
  end

  #--------------------------------------------------------------------------
  # * Random Selection of Target Actor (HP 0)
  #--------------------------------------------------------------------------
  def random_target_actor_hp0
    return random_target_actor(true)
  end
  
  #--------------------------------------------------------------------------
  # * Smooth Selection of Target Actor
  #     actor_index : actor index
  #--------------------------------------------------------------------------
  def smooth_target_actor(actor_index)
    # Get an actor
    actor = @actors[actor_index]
    # If an actor exists
    if actor != nil and actor.exist?
      return actor
    end
    # Loop
    for actor in @actors
      # If an actor exists
      if actor.exist?
        return actor
      end
    end
  end
  
  #--------------------------------------------------------------------------
  # ● check if actor is in party
  #--------------------------------------------------------------------------  
  def has_actor?(actor)
    return @active.include?(actor)
  end

  #--------------------------------------------------------------------------
  # ● check if all actors are 'normal' state
  #--------------------------------------------------------------------------  
  def all_normal
    for i in 0..LAST_ACTOR_ID
      actor = @all_actors[i]
      if actor != nil && $game_player.is_present(actor.id)
        if (actor.states & ([1] + BAD_STATES)).size > 0 # non-shield status inflicted
          return false
        end
      end
    end
    
    return true
  end

  #--------------------------------------------------------------------------
  # ● remove inflictions
  #--------------------------------------------------------------------------  
  def remove_inflictions()
    for i in 0..LAST_ACTOR_ID
      actor = @all_actors[i]
      if actor != nil && $game_player.is_present(actor.id)
        for state in BAD_STATES
          actor.remove_state(state, true)
        end
      end
    end
  end

  #--------------------------------------------------------------------------
  # ● Actor Lineup
  #   Provides a list of party members
  #-------------------------------------------------------------------------- 
  def actor_lineup()
    @lineup = []
    for i in 1..LAST_ACTOR_ID
      actor = @all_actors[i]
      if actor != nil and !@lineup.include?(actor) && $game_player.is_present(actor.id)
        @lineup.push(actor)
      end
    end
  end
        
end