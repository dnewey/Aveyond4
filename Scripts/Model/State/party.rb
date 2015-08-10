#==============================================================================
# ** Game_Party
#==============================================================================

class Game_Party

  attr_accessor :active                  # actors
  attr_accessor :reserve                  # reserve party

  attr_reader   :gold                     # amount of gold

  attr_accessor :all_actors

  attr_accessor :leader

  attr_reader :items, :potions

  # Potion making vars
  attr_accessor :potion_state, :potion_level, :potion_id, :potion_item

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

    # Inventory
    @items = {}
    @gold = 250

    # Other things you can have
    @potions = []
    @creatures = []

    # Current state of potions
    @potion_state = :empty # Current potion in progress
    @potion_id = nil # Potion being made once in hack state
    @potion_level = 0 # How many hacks have been completed
    @potion_item = nil # What tool you are using

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

  def all_battlers
    return (@active+@reserve).map{ |a| @actors[a] }
  end

  def attackable_battlers
    return active_battlers.select{ |a| a.attackable? }
  end

  def alive_battlers
    return active_battlers.select{ |a| !a.down? }
  end

  def alive_members
    return @active.map{ |a| @actors[a] }.select{ |a| !a.down? }
  end

  #--------------------------------------------------------------------------
  # * Add an Actor
  #     actor_id : actor ID
  #--------------------------------------------------------------------------
  def set_active(actor)

    # If already active, forget it
    return if @active.include?(actor)

    # If active is full, somebody gets removed
    if @active.count > 3
      set_reserve(@active[3])
      @active.delete(@active[3])
    end

    # Make sure this actor is not in reserve
    @reserve.delete(actor)
      
    @active.push(actor)

  end

  def set_reserve(actor)

    # If already active, forget it
    return if @reserve.include?(actor)

    # If active is full, somebody gets removed
    if @reserve.count > 3
      set_active(@reserve[3])
      @reserve.delete(@reserve[3])
    end

    # Make sure this actor is not in active
    @active.delete(actor)
      
    @reserve.push(actor)

  end

  def back_to_pavillion(actor)
    @active.delete(actor)
    @reserve.delete(actor)
  end


  def swap(a,b)
    return if a == b

    first = nil
    dta = a.split('.')
    if dta[0] == 'a'
      first = @active[dta[1].to_i]
    else
      first = @reserve[dta[1].to_i]
    end

    second = nil
    dta2 = b.split('.')
    if dta2[0] == 'a'
      second = @active[dta2[1].to_i]
    else
      second = @reserve[dta2[1].to_i]
    end

    # Put second in first
    if dta[0] == 'a'
      @active[dta[1].to_i] = second
    else
      @reserve[dta[1].to_i] = second
    end

    # Put first in second
    if dta2[0] == 'a'
      @active[dta2[1].to_i] = first
    else
      @reserve[dta2[1].to_i] = first
    end

    @active.compact!
    @reserve.compact!

  end


  def all
    return @active + @reserve
  end


  #--------------------------------------------------------------------------
  # * Get Number of Items Possessed
  #--------------------------------------------------------------------------
  def add_item(id,n=1) 
    @items.has_key?(id) ? @items[id] += n : @items[id] = n
    @items.delete(id) if @items[id] <= 0 
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
    return @items.select{ |i| true }
  end


  #--------------------------------------------------------------------------
  # * Determine Everyone is Down
  #--------------------------------------------------------------------------
  def defeated?
    return @active.select{ |a| !@actors[a].down? }.empty?
  end
  
  #--------------------------------------------------------------------------
  # ● check if actor is in party
  #--------------------------------------------------------------------------  
  def has_member?(guy)
    return (@active + @reserve).include?(guy)
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
    set_active("ing")
    set_active("mys")
    # set_active("rob")
    # set_reserve("hib")
    # set_reserve("row")
    # set_reserve("phy")   
  
    # ----------------------------------
    # Initial Gear

    # Boyle
    @actors['boy'].equip('staff','boy-staff')
    @actors['boy'].equip('mid','boy-arm-s')

    # Ingrid
    @actors['ing'].equip('wand','wand-start')
    @actors['ing'].equip('athame','athame-start')
    @actors['ing'].equip('light','ing-arm-s')

    # Myst
    @actors['mys'].equip('lclaw','claw-l-start')
    @actors['mys'].equip('rclaw','claw-r-start')
    @actors['mys'].equip('light','mys-arm-s')

    # Robin
    @actors['rob'].equip('sword','hammer-start')
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
    @actors["boy"].learn('fireburn')

    @actors["ing"].learn('xform-snake')

    @actors["rob"].learn("team-boy")
    @actors["rob"].learn("team-ing")
    @actors["rob"].learn("team-mys")
    @actors["rob"].learn("team-row")
    @actors["rob"].learn("team-hib")
    @actors["rob"].learn("team-phy")

    item('boy-arm-s','s')
    item('hib-arm-s','s')

    potion_learn("blabber")
    potion_learn("blabber")
    potion_learn("blabber")
    potion_learn("blabber")
    potion_learn("blabber")
    

  end
        
end