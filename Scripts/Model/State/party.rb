#==============================================================================
# ** Game_Party
#==============================================================================

class Game_Party

  attr_accessor :active                  # actors
  attr_accessor :reserve                  # reserve party

  attr_reader   :gold                     # amount of gold

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

    # Initialize amount of gold
    @gold = 0

    # Create amount in possession hash for items, weapons, and armor
    @items = {}
    @weapons = {}
    @armors = {}
    
    # TEMP DISABLE
    set_active("boy")
    set_active("ing")
    set_active("mys")
    set_active("rob")

  end

  #--------------------------------------------------------------------------
  # * Getting Maximum Level
  #--------------------------------------------------------------------------
  def max_level
    return @actors.max_by(&:level).level
  end

  def get(actor)
    return @actors[actor]
  end

  #--------------------------------------------------------------------------
  # * Add an Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def set_active(actor)

    # if @active.size < 4 and not @actors.include?(actor)
      
      @active.push(actor)

    # end
   # if !@active.include?(actor)
   #    @reserve.push(actor)
   #  end

  end

  def set_reserve(actor)
    @reserve.push(actor)
  end

  def back_to_pavillion(actor)
    @actors.delete(actor)
    @reserve.delete(actor)
  end

  #--------------------------------------------------------------------------
  # * Get Number of Items Possessed
  #--------------------------------------------------------------------------
  def add_item(id,n) add(@items,id,n) end
  def lose_item(item,n) add(@items,id,n) end
  def item_number(id) count(@items,id) end
  def has_item?(id) count(type,id) > 0 end



  def add(type,id,number)
    type.has_key?(id) ? type[id] += number : type[id] = number
  end

  def count(type,id)
    return type.has_key?(id) ? type[id] : 0
  end

  #--------------------------------------------------------------------------
  # * Determine Everyone is Dead
  #--------------------------------------------------------------------------
  def all_dead?
    return @active.select{ |a| @actors[a].hp > 0}.empty?
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