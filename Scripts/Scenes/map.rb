#==============================================================================
# ** Scene_Map
#==============================================================================

class Scene_Map < Scene_Base

   def initialize
    super

    # Setup
    @map.setup($data.system.start_map_id)
    @player.moveto($data.system.start_x, $data.system.start_y)

    @map.camera_to(@player)

    $map = @map
    $player = @player

    @hud = Ui_Screen.new(@vp_ui)

    @moblins = []
            
  end
  
  def terminate
    super

  end

  def busy?
    return @hud.busy?
  end

  #--------------------------------------------------------------------------
  # * Update the map contents and processes input from the player
  #--------------------------------------------------------------------------
  def update
    super

    @moblins.each{ |i| i.update } if !busy?
    
  end

  def moblin(src,delay)
    @moblins.push(Moblin.new(src,delay))
  end

end
