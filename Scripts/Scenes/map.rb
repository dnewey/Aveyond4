#==============================================================================
# ** Scene_Map
#==============================================================================

class Scene_Map < Scene_Base

   def initialize(map=nil,player=nil)
    super()

    @moblins = []

    # Setup
    if !map
      @map.setup($data.system.start_map_id)
      @map.setup_audio
    else
      @map = map
    end
    
    if !player
      @player.moveto($data.system.start_x, $data.system.start_y)
      @map.camera_to(@player)
      @map.camera_snap
    else
      @player = player
    end

    $map = @map
    $player = @player

    @hud = Ui_Screen.new(@vp_ui)    
            
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

  def add_moblin(ev,delay)
    ev = gev(ev) if !ev.is_a?(Game_Event)
    @moblins.push(Moblin.new(ev,delay))
  end

end
