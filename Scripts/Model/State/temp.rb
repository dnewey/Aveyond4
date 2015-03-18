#==============================================================================
# ** Game_Temp
#==============================================================================

class Game_Temp
  
  # Put in map where it can be used
  attr_accessor :common_event_id          # common event ID  

  # Put this elsewhere, could open with shop
  attr_accessor :shop_goods               # list of shop goods
  
  # This can surely go elsewhere, in player or map
  attr_accessor :player_transferring      # player place movement flag
  attr_accessor :player_new_map_id        # player destination: map ID
  attr_accessor :player_new_x             # player destination: x-coordinate
  attr_accessor :player_new_y             # player destination: y-coordinate
  attr_accessor :player_new_direction     # player destination: direction
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize

    @common_event_id = 0
    @shop_goods = nil
    
    @player_transferring = false
    @player_new_map_id = 0
    @player_new_x = 0
    @player_new_y = 0
    @player_new_direction = 0
    
  end

end
