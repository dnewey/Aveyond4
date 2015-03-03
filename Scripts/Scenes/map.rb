#==============================================================================
# ** Scene_Map
#------------------------------------------------------------------------------
# 　This class handles the scene-related elements of the map, such as setting up 
#   the message window and calling various menus that would change the "Scene". 
#   Other duties, such as processing of map graphics and map events, are handled 
#   by the Game_Map class and its member objects. 
#==============================================================================


class Scene_Map < Scene_Base
  
  
  #--------------------------------------------------------------------------
  # * Properties
  #   Global variables so the gold and help window can be controlled 
  #   on the map.
  #--------------------------------------------------------------------------
  attr_accessor :hud_window
   
  #--------------------------------------------------------------------------
  # * Set up the scene
  #--------------------------------------------------------------------------
  def start

    @hud = Game_Hud.new
    @world = Game_World.new
            
  end
  
  def terminate
    super

    @world.dispose
    @hud.dispose
    
    if $scene.is_a?(Scene_Title)
      Graphics.transition
      Graphics.freeze
    end

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

    # Direction the player should face
    case $temp.player_new_direction
    when 2  # Down
      $player.turn_down
    when 4  # Left
      $player.turn_left
    when 6  # Right
      $player.turn_right
    when 8  # Up
      $player.turn_up
    end

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