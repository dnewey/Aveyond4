#==============================================================================
# ** Game_Party
#------------------------------------------------------------------------------
#  This class handles the party. It includes information on amount of gold 
#  and items. Refer to "$game_party" for the instance of this class.
#==============================================================================

class Game_Party
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :actors                   # actors
  attr_accessor :reserve                  # reserve party
  attr_reader   :gold                     # amount of gold
  attr_reader   :steps                    # number of steps
  attr_reader   :lineup                   # active party + reserve

  attr_accessor :all_actors
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    
    @all_actors = {}
    $data.actors.each{ |k,v|
      @all_actors[k] = Game_Actor.new(k)
    }
    
    
    # Create actor array
    @active = []
    @reserve = [] # list of reserve actors
    # Initialize amount of gold and steps
    @gold = 0
    @steps = 0
    # Create amount in possession hash for items, weapons, and armor
    @items = {}
    @weapons = {}
    @armors = {}
    @lineup = []

    
    # TEMP DISABLE
    setup_starting_members
    

  end

  #--------------------------------------------------------------------------
  # * Initial Party Setup
  #--------------------------------------------------------------------------
  def setup_starting_members
    #@actors = []
    #for i in $data_system.party_members
      @active.push("boyle")
    #end
    @reserve = []
  end
 
  #--------------------------------------------------------------------------
  # * Refresh Party Members
  #--------------------------------------------------------------------------
  def refresh
    # Actor objects split from @all_actors right after loading game data
    # Avoid this problem by resetting the actors each time data is loaded.
    new_actors = []
    for i in 0...@actors.size
      if $data_actors[@actors[i].id] != nil
        new_actors.push(@all_actors[@actors[i].id])
      end
    end
    @actors = new_actors
    
    $game_party.reserve = []
    for i in 0..LAST_ACTOR_ID
      actor = @all_actors[i]
      if actor != nil && $game_player.is_present(actor.id) && 
        !$game_party.actors.include?(actor)
        $game_party.reserve.push actor
      end
    end

    $game_map.need_hud_refresh = true # Shaz
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
  def add_actor(actor_id)
    # Get actor
    actor = @all_actors[actor_id]
    # If the party has less than 4 members and this actor is not in the party
    if @actors.size < 4 and not @actors.include?(actor)
      # Add actor
      @actors.push(actor)
      # Refresh player
      $game_player.refresh
    end
    # If the actor is not in the main party, put them in reserve
    if !@actors.include?(actor)
      @reserve.push(actor)
    end
    $game_switches[actor_id] = true
    $game_map.need_hud_refresh = true # Shaz
  end
  #--------------------------------------------------------------------------
  # ● Add an Actor in the Reserve Party
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def add_reserve(actor_id)
    actor = @all_actors[actor_id]
    @reserve.push(actor)
    $game_switches[actor_id] = true
  end
  #--------------------------------------------------------------------------
  # * Remove Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def remove_actor(actor_id)
    # Delete actor
    @actors.delete(@all_actors[actor_id])
    @reserve.delete(@all_actors[actor_id])
    $game_switches[actor_id] = false
    # Refresh player
    $game_player.refresh
    $game_map.need_hud_refresh = true # Shaz
  end
  #--------------------------------------------------------------------------
  # * Gain Gold (or lose)
  #     n : amount of gold
  #--------------------------------------------------------------------------
  def gain_gold(n)
    @gold = [[@gold + n, 0].max, 9999999].min
    $game_map.need_hud_refresh = true # Shaz
  end
  #--------------------------------------------------------------------------
  # * Lose Gold
  #     n : amount of gold
  #--------------------------------------------------------------------------
  def lose_gold(n)
    # Reverse the numerical value and call it gain_gold
    gain_gold(-n)
    $game_map.need_hud_refresh = true # Shaz
  end
  #--------------------------------------------------------------------------
  # * Increase Steps
  #--------------------------------------------------------------------------
  def increase_steps
    @steps = [@steps + 1, 9999999].min
  end
  #--------------------------------------------------------------------------
  # * Get Number of Items Possessed
  #     item_id : item ID
  #--------------------------------------------------------------------------
  def item_number(item_id)
    # If quantity data is in the hash, use it. If not, return 0
    return @items.include?(item_id) ? @items[item_id] : 0
  end
  #--------------------------------------------------------------------------
  # * Get Number of Weapons Possessed
  #     weapon_id : weapon ID
  #--------------------------------------------------------------------------
  def weapon_number(weapon_id)
    # If quantity data is in the hash, use it. If not, return 0
    return @weapons.include?(weapon_id) ? @weapons[weapon_id] : 0
  end
  #--------------------------------------------------------------------------
  # * Get Amount of Armor Possessed
  #     armor_id : armor ID
  #--------------------------------------------------------------------------
  def armor_number(armor_id)
    # If quantity data is in the hash, use it. If not, return 0
    return @armors.include?(armor_id) ? @armors[armor_id] : 0
  end
  #--------------------------------------------------------------------------
  # * Gain Items (or lose)
  #     item_id : item ID
  #     n       : quantity
  #--------------------------------------------------------------------------
  def gain_item(item_id, n)
    # Update quantity data in the hash.
    if item_id > 0
      @items[item_id] = [[item_number(item_id) + n, 0].max, 99].min
    end
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
  def item_can_use?(item_id)
    # If item quantity is 0
    if item_number(item_id) == 0
      # Unusable
      return false
    end
    # Get usable time
    occasion = $data_items[item_id].occasion
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
    # Clear All Member Actions
    for actor in @actors
      actor.current_action.clear
    end
  end
  #--------------------------------------------------------------------------
  # * Determine if Command is Inputable
  #--------------------------------------------------------------------------
  def inputable?
    # Return true if input is possible for one person as well
    for actor in @actors
      if actor.inputable?
        return true
      end
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Determine Everyone is Dead
  #--------------------------------------------------------------------------
  def all_dead?
    # If number of party members is 0
    if $game_party.actors.size == 0
      return false
    end
    # If an actor is in the party with 0 or more HP
    for actor in @actors
      if actor.hp > 0
        return false
      end
    end
    # All members dead
    return true
  end
  #--------------------------------------------------------------------------
  # * Slip Damage Check (for map)
  #--------------------------------------------------------------------------
  def check_map_slip_damage
    return 0
    for actor in @actors
      if actor.hp > 0 and actor.slip_damage?
        actor.hp -= [actor.maxhp / 100, 1].max
        if actor.hp == 0
          $game_system.se_play($data_system.actor_collapse_se)
        end
        $game_screen.start_flash(Color.new(255,0,0,128), 4)
        $game_temp.gameover = $game_party.all_dead?
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
  def has_actor?(actor_id)
    @actors.each {|a| return true if a.id == actor_id}
    return false
  end
  
  #--------------------------------------------------------------------------
  # ● check if actors are in party
  #--------------------------------------------------------------------------  
  def has_actors?(*ids)
    i = ids.size
    @actors.each {|a| i -= 1 if ids.include?(a.id)}
    return i == 0
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