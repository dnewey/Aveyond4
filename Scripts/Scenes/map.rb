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


    @world = Game_World.new

    return
    
    # Player HUD
    # $hud_window = Window_Hud.new
    # $hud_window.opacity = 0
    # $hud_window.x = -16
    # $hud_window.y = -16
    
    # $hudtext_window = Window_HudText.new
            
  end
  
  def terminate
    super

    @spriteset.dispose
    @message_window.dispose
    $hud_window.dispose
    $hudtext_window.dispose
    $jrnl_anim.dispose
    
    if $scene.is_a?(Scene_Title)
      Graphics.transition
      Graphics.freeze
    end
  end
  #--------------------------------------------------------------------------
  # * Update the map contents and processes input from the player
  #--------------------------------------------------------------------------
  def update

    # Update windows
    #$game_system.slave_windows.each_value { |window| window.update }
    #$game_system.indy_windows.each_value { |window| window.update }
    
    
    #loop do

      $map.update
      #$hud_window.refresh if $game_map.need_hud_refresh
      #$hudtext_window.update 

      @world.update
      

      $player.update
      #$game_system.update
      #$game_screen.update
      #$jrnl_anim.update if $game_temp.jrnl_animate

      # unless $game_temp.player_transferring
      #   break
      # end

      # transfer_player
      
      # if $game_temp.transition_processing
      #   break
      # end
    #end
    
    
return
    @spriteset.update
    @message_window.update    
      


    if $game_temp.transition_processing
      $game_temp.transition_processing = false

      if $game_temp.transition_name == ""
        Graphics.transition(20)
      else
        Graphics.transition(40, "Graphics/Transitions/" +
          $game_temp.transition_name)
      end
    end
    

    if $game_temp.message_window_showing
      return
    end


    # Open Menu at player's request
    if Input.trigger?(Input::B)

      unless $game_system.map_interpreter.running? or
             $game_system.menu_disabled
             
        $game_temp.menu_calling = true
        $game_temp.menu_beep = true
        
      end
      
    end


    unless $game_player.moving?
      if $game_temp.battle_calling
        call_battle
      elsif $game_temp.shop_calling
        call_shop
      elsif $game_temp.name_calling
        call_name
      elsif $game_temp.menu_calling
        call_menu
      elsif $game_temp.save_calling
        call_save
      end
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Call the battle screen
  #--------------------------------------------------------------------------
  def call_battle
    $game_temp.battle_calling = false
    $game_temp.menu_calling = false
    $game_temp.menu_beep = false
    $game_player.make_encounter_count
    $game_temp.map_bgm = $game_system.playing_bgm
    $game_temp.map_bgs = $game_system.playing_bgs
    $game_system.bgm_stop
    $game_system.bgs_stop
    $game_system.se_play($data_system.battle_start_se)
    $game_system.bgm_play($game_system.battle_bgm)
    $game_player.straighten
    $scene = Scene_Battle.new
  end
 
  #--------------------------------------------------------------------------
  # * Open the Journal
  #--------------------------------------------------------------------------
  def call_journal
      unless $game_system.map_interpreter.running? or
             $game_system.menu_disabled
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Journal.new        
      end
  end  
  
  #--------------------------------------------------------------------------
  # * Open the Save Menu
  #--------------------------------------------------------------------------
  def call_save
    $game_player.straighten
    $scene = Scene_Save.new(2)
  end    
  
  #--------------------------------------------------------------------------
  # * Open the Save Menu
  #--------------------------------------------------------------------------
  def call_save2
      unless $game_system.map_interpreter.running? or
             $game_system.menu_disabled
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Save.new
      end    
  end  

  #--------------------------------------------------------------------------
  # * Open the Item Menu
  #--------------------------------------------------------------------------
  def call_items
      unless $game_system.map_interpreter.running? or
             $game_system.menu_disabled
        $game_system.se_play($data_system.decision_se)
        $scene = Scene_Item.new
      end
  end   
  
  #--------------------------------------------------------------------------
  # * Open the shop window
  #--------------------------------------------------------------------------
  def call_shop
    $game_temp.shop_calling = false
    $game_player.straighten
    $scene = Scene_Shop.new
  end

  #--------------------------------------------------------------------------
  # * Opens the Main Menu
  #--------------------------------------------------------------------------
  def call_menu
    $game_temp.menu_calling = false

    if $game_temp.menu_beep
      $game_system.se_play($data_system.decision_se)
      $game_temp.menu_beep = false
    end

    $game_player.straighten
    $scene = Scene_Menu.new
  end
  
  #--------------------------------------------------------------------------
  # * Teleport the Player
  #--------------------------------------------------------------------------
  def transfer_player
   
    $game_temp.player_transferring = false
    $game_player.clear_path

    # Map to teleport to 
    if $game_map.map_id != $game_temp.player_new_map_id
      # set monsters to either respawn or to never return
      update_monster_switches
      $game_map.setup($game_temp.player_new_map_id)      
      # reset anti-lag-override on change to new map
      $game_switches[ANTI_LAG_OVERRIDE_SWITCH] = false
      $hud_window.update
    end

    # Location on the map to teleport to
    $game_player.moveto($game_temp.player_new_x, $game_temp.player_new_y)

    # Direction the player should face
    case $game_temp.player_new_direction
    when 2  # Down
      $game_player.turn_down
    when 4  # Left
      $game_player.turn_left
    when 6  # Right
      $game_player.turn_right
    when 8  # Up
      $game_player.turn_up
    end

    $game_player.straighten
    $game_map.update

    @spriteset.dispose
    @spriteset = Spriteset_Map.new

    if $game_temp.transition_processing
      $game_temp.transition_processing = false
      Graphics.transition(20)
    end

    $game_map.autoplay
    Graphics.frame_reset
    Input.update
    
    # autosave your game (but not on the ending map)
    if !ENDING_MAPS.include?($game_map.map_id)
      save = Scene_Save.new(1)
      save.autosave      
    end
    
  end
  #--------------------------------------------------------------------------
  # * Reset self-switches for monsters
  #   Hide certain monster groups after they've been defeated
  #   
  #--------------------------------------------------------------------------
  def update_monster_switches
    level = $game_variables[DIFFICULTY_VARIABLE] # Difficulty: 0=easy, 1=normal, 2=hard
    hide = []
    case level
      when 0
        hide = ["7", "8", "9", "10", "11", "12", "13", "14", "15"]
      when 1
        hide = ["10", "11", "12", "13", "14", "15"]
      when 2
        hide = ["13", "14", "15"]
    end
    
    $game_map.monster_events.each do |group, events|
      switch = group.to_i + 25
      if $game_switches[switch] # if this monster group defeated
        events.each do |event|
          # reset loot
          $game_self_switches[[$game_map.map_id, event, "A"]] = false
          # stop respawning?
          if hide.include?(group)
            $game_self_switches[[$game_map.map_id, event, "B"]] = true
          end
        end
        $game_switches[switch] = false # reset monsters for the next map
      end
    end
      
  end
end
