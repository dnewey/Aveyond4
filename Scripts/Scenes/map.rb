#==============================================================================
# ** Scene_Map
#==============================================================================

class Scene_Map
   
  #--------------------------------------------------------------------------
  # * Set up the scene
  #--------------------------------------------------------------------------
  def initialize

    @hud = Ui_Screen.new
    @world = Game_World.new

        $map = Game_Map.new

    $map.setup($data.system.start_map_id)
    $player.moveto($data.system.start_x, $data.system.start_y)

    $hud = @hud
    $world = @world
            
  end
  
  def terminate

    @world.dispose
    @hud.dispose

  end

  #--------------------------------------------------------------------------
  # * Update the map contents and processes input from the player
  #--------------------------------------------------------------------------
  def update

    $map.update      
    $player.update

    @world.update
    @hud.update

    # Open Menu at player's request
    unless $map.interpreter.running? or $hud.busy?

      # Check inputs
        
    end
    
  end

end