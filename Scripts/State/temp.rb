#==============================================================================
# ** Game_Temp
#==============================================================================

class Game_Temp
  
  # Put in map where it can be used
  attr_accessor :common_event_id          # common event ID  
  
  
  # Battle setup, don't need?
  attr_accessor :in_battle                # in-battle flag
  attr_accessor :battle_troop_id          # battle troop ID
  attr_accessor :battle_can_escape        # battle flag: escape possible
  attr_accessor :battle_can_lose          # battle flag: losing possible
  attr_accessor :battle_proc              # battle callback (Proc)
  attr_accessor :battle_turn              # number of battle turns
  attr_accessor :battle_event_flags       # battle event flags: completed
  attr_accessor :battle_abort             # battle flag: interrupt
  attr_accessor :battle_main_phase        # battle flag: main phase


  # Put this elsewhere, could open with shop
  attr_accessor :shop_goods               # list of shop goods

  
  # This can surely go elsewhere, in player or map
  attr_accessor :player_transferring      # player place movement flag
  attr_accessor :player_new_map_id        # player destination: map ID
  attr_accessor :player_new_x             # player destination: x-coordinate
  attr_accessor :player_new_y             # player destination: y-coordinate
  attr_accessor :player_new_direction     # player destination: direction
  
 
  # FROM SYSTEM - TO BE CUT
    
  # move out of here, to map perhaps
  #attr_accessor :map_interpreter          # map event interpreter
  #attr_reader   :battle_interpreter       # battle event interpreter
    
  # Possibly useful, maybe move
  # These could be flags? or options somewhere
  attr_accessor :save_disabled            # save forbidden
  attr_accessor :menu_disabled            # menu forbidden
  
  
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize

    @common_event_id = 0
    
    @in_battle = false
    @battle_calling = false
    @battle_troop_id = 0
    @battle_can_escape = false
    @battle_can_lose = false
    @battle_proc = nil
    @battle_turn = 0
    @battle_event_flags = {}
    @battle_abort = false
    @battle_main_phase = false
    @battleback_name = ''

    
    @player_transferring = false
    @player_new_map_id = 0
    @player_new_x = 0
    @player_new_y = 0
    @player_new_direction = 0
    
    # In game surely? or map
    @transition_processing = false
    @transition_name = ""

  end

end
