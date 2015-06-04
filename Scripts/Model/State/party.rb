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

    $party = self

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

    # Hardcode Party Data
    init_party

  end

  #--------------------------------------------------------------------------
  # * Getting Maximum Level
  #--------------------------------------------------------------------------
  def max_level
    return @actors.max_by(&:level).level
  end

  def get(a)
    return actor_by_id(a)
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
  def add_item(id,n=1) 
    @items.has_key?(id) ? @items[id] += n : @items[id] = n
    @items[id] = 0 if @items[id] < 0 
    $map.need_refresh = true if $map
  end

  def lose_item(id,n=1) add_item(id,-n) end
  
  def item_number(id) return @items.has_key?(id) ? @items[id] : 0 end
  def has_item?(id) item_number(id) > 0 end


  def add_gold(n)
    @gold += n
    @gold = 0 if @gold < 0
    $map.need_refresh = true
  end

  def item_list
    items = []
    @items.each{ |k,v|
      items.push(k) if v > 0
    }
    return items
  end

  def battle_item_list
    return ['covey','cheese','mir-wood']
  end


  #--------------------------------------------------------------------------
  # * Determine Everyone is Dead
  #--------------------------------------------------------------------------
  def defeated?
    return @active.select{ |a| !@actors[a].down? }.empty?
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


  #--------------------------------------------------------------------------
  # ● Initialize Party Data
  #--------------------------------------------------------------------------

  def init_party

    @leader = 'boy'

    # -----------------------------------
    # Initial Party Members
    # -----------------------------------

    set_active("boy")
    #set_active("ing")
    #set_active("mys")
    #set_active("rob")
    #set_active("hib")
    #set_active("row")
    #set_active("phy")   
  
    # ----------------------------------
    # Initial Gear

    # Boyle
    @actors['boy'].equip('staff','boy-staff')
    @actors['boy'].equip('mid','boy-arm-s')

    # Ingrid
    @actors['ing'].equip('wand','ing-wep-s')
    @actors['ing'].equip('athame','ing-athame-s')
    @actors['ing'].equip('light','ing-arm-s')

    # Myst
    @actors['mys'].equip('claw1','mys-wep-s')
    @actors['mys'].equip('claw2','mys-wep-s')
    @actors['mys'].equip('light','mys-arm-s')

    # Robin
    @actors['rob'].equip('sword','rob-wep-s')
    @actors['rob'].equip('heavy','rob-arm-s')

    # Hiberu
    @actors['hib'].equip('book','hib-wep-s')
    @actors['hib'].equip('mid','hib-arm-s')
    # Give accessory

    # Rowen
    @actors['row'].equip('dagger','row-wep-s')
    @actors['row'].equip('light','row-arm-s')
    # Give extra gadget

    # Phye
    @actors['phy'].equip('staff','phy-sword')
    @actors['phy'].equip('heavy','phy-arm-s')
    # Give him helm


    # Initial skills per actor
    @actors["boy"].learn('fireburn')
    @actors["boy"].learn('flames')

  end























        
end