#==============================================================================
# ** Scene_Map
#==============================================================================

class Scene_Battle < Scene_Base  
  
  attr_accessor :hud_window
   
  #--------------------------------------------------------------------------
  # * Set up the scene
  #--------------------------------------------------------------------------
  def start

    @hud = Game_Hud.new
    @world = Game_World.new

    @battle = Game_Battle.new
            
  end
  
  def terminate
    super

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


      return # if not transferring

      # transfer_player
      
      # if $game_temp.transition_processing
      #   break
      # end
    #end   

    if $temp.transition_processing
      $temp.transition_processing = false

      if $temp.transition_name == ""
        Graphics.transition(20)
      else
        Graphics.transition(40, "Graphics/Transitions/" +
          $temp.transition_name)
      end
    end

    # Open Menu at player's request
    unless $map.interpreter.running? or $hud.busy?

      # Check inputs
        
    end
    
  end

  #--------------------------------------------------------------------------
  # * Teleport the Player
  #--------------------------------------------------------------------------
  def transfer_player
   
    $temp.player_transferring = false
    $player.clear_path

    # Map to teleport to 
    if $map.map_id != $temp.player_new_map_id
      $map.setup($game_temp.player_new_map_id)      
    end

    # Location on the map to teleport to
    $player.moveto($temp.player_new_x, $temp.player_new_y)
    $player.direction = $temp.player_new_direction

    $player.straighten
    $map.update

    if $temp.transition_processing
      $temp.transition_processing = false
      Graphics.transition(20)
    end

    $map.autoplay    

    # AUTO SAVING

    # autosave your game (but not on the ending map)
   # if !ENDING_MAPS.include?($game_map.map_id)
   #   save = Scene_Save.new(1)
   #   save.autosave      
   # end
    
  end

end