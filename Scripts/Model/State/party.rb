#==============================================================================
# ** Game_Party
#==============================================================================

class Game_Party

  attr_accessor :active                  # actors
  attr_accessor :reserve                  # reserve party

  attr_reader   :gold                     # amount of gold

  attr_accessor :all_actors

  attr_reader :leader

  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize

    # Create all actors    
    @actors = {}
    $data.actors.each{ |k,v| 
      battler = Game_Battler.new
      battler.init_actor(k)
      @actors[k] = battler 
    }    

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
    # set_active("ing")
    # set_active("phy")
    # set_active("rob")

    @leader = 'boy'

    @actors["boy"].learn('fireburn')
    @actors["boy"].learn('flames')

  end

  #--------------------------------------------------------------------------
  # * Getting Maximum Level
  #--------------------------------------------------------------------------
  def max_level
    return @actors.max_by(&:level).level
  end

  def actor_by_id(actor)
    return @actors[actor]
  end

  def actor_by_index(idx)
    return @actors[@active[idx]]
  end

  def active_battlers
    return @active.map{ |a| @actors[a] }
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
  def add_item(id,n) 
    @items.has_key?(id) ? @items[id] += n : @items[id] = n
    @items[id] = 0 if @items[id] < 0 
    $map.need_refresh = true
  end

  def lose_item(id,n) add_item(id,-n) end
  
  def item_number(id) return @items.has_key?(id) ? @items[id] : 0 end
  def has_item?(id) item_number(id) > 0 end


  def add_gold(n)
    @gold += n
    @gold = 0 if @gold < 0
    $map.need_refresh = true
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
  # ● check if actor is in party
  #--------------------------------------------------------------------------  
  def has_member?(guy)
    return (@active + @reserve).include?(guy)
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