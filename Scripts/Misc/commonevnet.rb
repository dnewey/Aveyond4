#==============================================================================
# ** Game_CommonEvent
#------------------------------------------------------------------------------
#  This class handles common events. It includes execution of parallel process
#  event. This class is used within the Game_Map class ($game_map).
#==============================================================================

class Game_CommonEvent
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     common_event_id : common event ID
  #--------------------------------------------------------------------------
  def initialize(common_event_id)
    @common_event_id = common_event_id
  end
  #--------------------------------------------------------------------------
  # * Get Name
  #--------------------------------------------------------------------------
  def name
    return $data.commons[@common_event_id].name
  end
  #--------------------------------------------------------------------------
  # * Get Trigger
  #--------------------------------------------------------------------------
  def trigger
    return $data.commons[@common_event_id].trigger
  end
  #--------------------------------------------------------------------------
  # * Get List of Event Commands
  #--------------------------------------------------------------------------
  def list
    return $data.commons[@common_event_id].list
  end

end