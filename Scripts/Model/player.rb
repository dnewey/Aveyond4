#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles the player. Its functions include event starting
#  determinants and map scrolling. Refer to "$game_player" for the one
#  instance of this class.
#==============================================================================

class Game_Player < Game_Character
  #--------------------------------------------------------------------------
  # * Invariables
  #--------------------------------------------------------------------------
  CENTER_X = (320 - 16) * 4   # Center screen x-coordinate * 4
  # agf - change from 240 to 224 to allow for fixed HUD
  CENTER_Y = (224 - 16) * 4   # Center screen y-coordinate * 4



  def initialize
    super
    @character_name = "boyle"
  end

  #--------------------------------------------------------------------------
  # * Passable Determinants
  #     x : x-coordinate
  #     y : y-coordinate
  #     d : direction (0,2,4,6,8)
  #         * 0 = Determines if all directions are impassable (for jumping)
  #--------------------------------------------------------------------------
  def passable?(x, y, d, step=999, tx=nil, ty=nil)
    if DEBUG and Input.press?(Input::CTRL)
      return true
    end
    super
  end
  #--------------------------------------------------------------------------
  # * Set Map Display Position to Center of Screen
  #--------------------------------------------------------------------------
  def center(x, y)
    max_x = ($map.width - 20) * 128
    max_y = ($map.height - 14) * 128
    $map.display_x = [0, [x * 128 - CENTER_X, max_x].min].max
    $map.display_y = [0, [y * 128 - CENTER_Y, max_y].min].max
  end
  #--------------------------------------------------------------------------
  # * Move to Designated Position
  #     x : x-coordinate
  #     y : y-coordinate
  #--------------------------------------------------------------------------
  def moveto(x, y)
    super
    # Centering
    center(x, y)
  end
  #--------------------------------------------------------------------------
  # * Increaase Steps
  #--------------------------------------------------------------------------
  def increase_steps
    super
    # If move route is not forcing
    unless @move_route_forcing
      
      # NOT USING STEPS, GET RID OF THIS PUT SLIP ELSEWHERE
     # if $party.steps % 2 == 0
        # Slip damage check
      #  $party.check_map_slip_damage
      #end
    end
  end
 
  #--------------------------------------------------------------------------
  # ● Change the party battlers (you can have up to 4)
  #--------------------------------------------------------------------------
  def change_battler(index)
    # set battler switch
    char_name = $game_actors[index+1].id
    
    # add character to battle party
    if !$party.has_actor?(char_name)
        add_main(char_name) 
    # add character to reserve party
    else  
        add_reserve(char_name)
    end    
       
    $game_player.restore_leader
    
    # refresh window to show "battler" beside the actor
    refresh     
    
  end  
   
  #-------------------------------------------------------------------------
  # Add character to main party
  #-------------------------------------------------------------------------
  def add_main(act)
    if $party.actors.size < 4
      $game_system.se_play($data_system.decision_se) 
      $party.remove_actor(act)
      $party.add_actor(act)
    else  
      $game_system.se_play($data_system.buzzer_se) 
    end
  end
    
  #-------------------------------------------------------------------------
  # Add character to reserve party
  #-------------------------------------------------------------------------
  def add_reserve(act) 
    if ($party.actors.size > 1 && act != 1)
      $game_system.se_play($data_system.decision_se) 
      $party.remove_actor(act)
      $party.add_reserve(act)
    else
      $game_system.se_play($data_system.buzzer_se)
    end
  end  
  
  #--------------------------------------------------------------------------
  # ● Change the party leader
  #--------------------------------------------------------------------------
  def change_leader(index)

    # turn off all leader switches
    for i in FIRST_LEADER_SWITCH .. LAST_LEADER_SWITCH
      $game_switches[i] = false
    end
   
    # set leader variable to actor ID 
    $game_variables[LEADER_VARIABLE] = $game_actors[index+1].id

    # set the leader sprite to show on the map
    $leader = $game_actors[index+1].character_name
    
    # set leader switch    
    $game_switches[index+FIRST_LEADER_SWITCH] = true
    
    # refresh window to show "leader" beside the leader actor
    refresh     
        
  end  
  
  #--------------------------------------------------------------------------
  # ● Show the default party leader
  #--------------------------------------------------------------------------
  def default_leader
        
    # turn off all leader switches
    for i in FIRST_LEADER_SWITCH .. LAST_LEADER_SWITCH
      $game_switches[i] = false
    end
    
    $game_variables[LEADER_VARIABLE] = 1    
    $game_switches[FIRST_LEADER_SWITCH] = true  
    
    $leader = $party.actors[0].character_name
    $data_actors[1].character_name = $leader
    char_name = $party.actors[0].id
     
    refresh     
    
  end   
  
  #--------------------------------------------------------------------------
  # ● Change the party leader
  #--------------------------------------------------------------------------
  def change_vehicle(name)
    $leader = name
    refresh         
  end    

  #--------------------------------------------------------------------------
  # ● Restore the party leader graphic
  #--------------------------------------------------------------------------
  def restore_leader
        
    # make sure leader is 1-10
    if ($game_variables[LEADER_VARIABLE] != FIRST_ACTOR_ID) && ($game_variables[LEADER_VARIABLE] <= LAST_ACTOR_ID)  
      $leader = $data_actors[$game_variables[LEADER_VARIABLE]].character_name 
      
      # turn off all leader switches
      for i in FIRST_LEADER_SWITCH .. LAST_LEADER_SWITCH
        $game_switches[i] = false
      end
      
      # set leader switch 
      $game_switches[$game_variables[LEADER_VARIABLE]+(FIRST_LEADER_SWITCH-1)] = true
      
    else
      default_leader
      
    end
    refresh         
    
  end  
  
  #--------------------------------------------------------------------------
  # ● Same as show_character. Don't delete
  #--------------------------------------------------------------------------
  def show_leader(num)
    $leader = $data_actors[num].character_name
    refresh         
  end  

  
  #--------------------------------------------------------------------------
  # ● Show the character who is speaking
  #--------------------------------------------------------------------------
  def show_character(num)
    $leader = $data_actors[num].character_name
    refresh         
  end   
  
  
  #--------------------------------------------------------------------------
  # ● Determine if a character is in the active party
  #--------------------------------------------------------------------------
  def is_active(num)
    return $party.actors.include?$game_actors[num]
  end

  #--------------------------------------------------------------------------
  # * Refresh
  #--------------------------------------------------------------------------
  def refresh
    # If party members = 0
    #if $party.actors.size == 0
      # Clear character file name and hue
      @character_name = ""
      @character_hue = 0
      # End method
      return
    #end
    # Get lead actor and show on map
    actor = $party.actors[0]
    if ($leader == 0)
      # Set character file name and hue
      @character_name = actor.character_name
    else
      @character_name = $leader
    end
    @character_hue = actor.character_hue
    # Initialize opacity level and blending method
    @opacity = 255
    @blend_type = 0
  end
  #--------------------------------------------------------------------------
  # * Same Position Starting Determinant
  #--------------------------------------------------------------------------
  def check_event_trigger_here(triggers)
    result = false
    # If event is running
    if $map.interpreter.running?
      return result
    end
    # All event loops
    for event in $map.events.values
      # If event coordinates and triggers are consistent
      if event.collide?(@x,@y) and triggers.include?(event.trigger)
      #if event.x == @x and event.y == @y and triggers.include?(event.trigger)
        # If starting determinant is same position event (other than jumping)
        if not event.jumping? and event.over_trigger?
          event.start
          result = true
        end
      end
    end
    return result
  end
  #--------------------------------------------------------------------------
  # * Front Envent Starting Determinant
  #--------------------------------------------------------------------------
  def check_event_trigger_there(triggers)
    result = false
    # If event is running
    if $map.interpreter.running?
      return result
    end

    log_info 'trying'


    # Calculate front event coordinates
    new_x = @x + (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
    new_y = @y + (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
    
    # All event loops
    for event in $map.events.values
      # If event coordinates and triggers are consistent
      if event.x == new_x and event.y == new_y and
         triggers.include?(event.trigger) and event.list.size > 1

         log_err "TRYINGHERE"

        # If starting determinant is front event (other than jumping)
        if not event.jumping? and not event.over_trigger?
          event.start
          result = true
        end
      end
    end
    # If fitting event is not found

    # COUNTER CHECK

    # if result == false
    #   # If front tile is a counter
    #   if $map.counter?(new_x, new_y)
    #     # Calculate 1 tile inside coordinates
    #     new_x += (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
    #     new_y += (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
    #     # All event loops
    #     for event in $map.events.values
    #       # If event coordinates and triggers are consistent
    #       if event.x == new_x and event.y == new_y and
    #          triggers.include?(event.trigger) and event.list.size > 1
    #         # If starting determinant is front event (other than jumping)
    #         if not event.jumping? and not event.over_trigger?
    #           event.start
    #           result = true
    #         end
    #       end
    #     end
    #   end
    # end
    return result
  end

  #--------------------------------------------------------------------------
  # * Touch Event Starting Determinant
  #--------------------------------------------------------------------------
  def check_event_trigger_touch(x, y)
    result = false
    # If event is running
    if $map.interpreter.running?
      return result
    end
    # All event loops
    for event in $map.events.values
      # If event coordinates and triggers are consistent
      if event.x == x and event.y == y and [1,2].include?(event.trigger)
        # If starting determinant is front event (other than jumping)
        if not event.jumping? and not event.over_trigger?
          event.start
          result = true
        end
      end
    end
    return result
  end

  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    # if $map.busy? or $hud.busy
    #return

    # Unless Interpretter Running, Forcing a Route or Message Showing
    # unless false# $game_system.map_interpreter.running? or
    #        #@move_route_forcing or $game_temp.message_window_showing
           
    #   # Find Path If Mouse Triggered
    #   if Mouse.trigger?(0) && Mouse.grid != nil

    #     # Check if mouse is over HUD on map 
    #     screen_x,screen_y = Mouse.pos
        
    #     # don't let user move player if below 448 px on screen
    #     if screen_y > 448
    #       if $game_system.menu_disabled
    #         $game_system.se_play($data_system.buzzer_se)
    #         return false
    #       end
          
    #       if screen_x < 32 
    #         $game_system.se_play($data_system.decision_se)
    #         $scene = Scene_End.new (2)
    #       elsif screen_x < 64
    #         $game_system.se_play($data_system.decision_se)
    #         $scene = Scene_Menu.new
    #       elsif screen_x < 96
    #         $game_system.se_play($data_system.decision_se)
    #         $scene = Scene_Save.new
    #       elsif screen_x < 128
    #         $game_system.se_play($data_system.decision_se)
    #         $scene = Scene_Journal.new(2)
    #       elsif screen_x < 160
    #         $game_system.se_play($data_system.decision_se)
    #         $scene = Scene_Item.new(2)
    #       elsif screen_x < 192
    #         $game_system.se_play($data_system.decision_se)
    #         $scene = Scene_Options.new(3)
    #       elsif screen_x < 224
    #         $game_system.se_play($data_system.decision_se)
    #         $scene = Scene_FAQ.new(2)       
    #       elsif screen_x > 235
    #         i = ((screen_x - 236) / 100).to_i
    #         if i < $party.actors.size
    #           $party.actor_lineup
    #           $game_system.se_play($data_system.decision_se)
    #           $scene = Scene_Equip.new($party.actors[i].id - 1, 0, 2)
    #         end
    #       end          
                    
    #       return false
          
    #     end     
        
    #     # Gets Mouse X & Y
    #     mx, my = *Mouse.grid
        
    #     # Turn Character in direction
    #     newd_x = (@x - mx).abs
    #     newd_y = (@y - my).abs
        
    #     if @x > mx 
    #         turn_left if newd_x >= newd_y 
    #     elsif @x < mx
    #         turn_right if newd_x >= newd_y 
    #     end  
            
    #     if @y > my
    #         turn_up if newd_x < newd_y 
    #     elsif @y < my
    #         turn_down if newd_x < newd_y 
    #     end 
        
    #     check_terrain(-1, -1) if WORLD_MAPS.include?($map.map_id)

    #     # Run Pathfinding
    #     evt = $map.lowest_event_at(mx, my)
    #     if evt == nil
    #       find_path(mx, my, false)
    #       @eventarray = @runpath ? $map.events_at(mx, my) : nil
    #     else
    #       find_path(evt.x, evt.y, false)
    #       @eventarray = [evt]
    #     end
        
    #     # If Event At Grid Location
    #     unless @eventarray.nil?
    #       @eventarray.each do |event|
    #         # If Event Autostart
    #         if !event.mouse_autostart
    #           # Set Autostart Event Flag
    #           #@mouse_event_autostarter = event.id
    #           @eventarray.delete(event)
    #         end
    #       end
    #       @eventarray = nil if @eventarray.size == 0
    #     end
        
    #   end
    # end
    
    if @move_route_forcing == true
      clear_path
      @eventarray = nil
    end

    # Clear path if any direction keys pressed
    #$player.clear_path if Input.dir4 != 0
    
    # Remember whether or not moving in local variables
    last_moving = moving?
    # If moving, event running, move route forcing, and message window
    # display are all not occurring
    unless moving? #or $game_system.map_interpreter.running? or
          # @move_route_forcing or $game_temp.message_window_showing
      case Input.dir4
        when 2; move_down
        when 4; move_left
        when 6; move_right
        when 8; move_up
      end
    end
    # Remember coordinates in local variables
    last_real_x = @real_x
    last_real_y = @real_y
    super
    # If character moves down and is positioned lower than the center
    # of the screen
    # if @real_y > last_real_y and @real_y - $map.display_y > CENTER_Y
    #   # Scroll map down
    #   $map.scroll_down(@real_y - last_real_y)
    # end
    # # If character moves left and is positioned more let on-screen than
    # # center
    # if @real_x < last_real_x and @real_x - $map.display_x < CENTER_X
    #   # Scroll map left
    #   $map.scroll_left(last_real_x - @real_x)
    # end
    # # If character moves right and is positioned more right on-screen than
    # # center
    # if @real_x > last_real_x and @real_x - $map.display_x > CENTER_X
    #   # Scroll map right
    #   $map.scroll_right(@real_x - last_real_x)
    # end
    # # If character moves up and is positioned higher than the center
    # # of the screen
    # if @real_y < last_real_y and @real_y - $map.display_y < CENTER_Y
    #   # Scroll map up
    #   $map.scroll_up(last_real_y - @real_y)
    # end
    # If not moving
    unless moving?
      # If player was moving last time
      if last_moving
        # Event determinant is via touch of same position event
        result = check_event_trigger_here([1,2])
      end
      # If C button was pressed
      if Input.trigger?(Input::C)
        # Same position and front event determinant
        check_event_trigger_here([0])
        check_event_trigger_there([0,1,2])
      end
    end
    
    # If Non-nil Event Autostarter
    if @eventarray != nil && !moving? && # @mouse_event_autostarter != nil && !moving? &&
      (!@ovrdest || @map.nil? || @map[@x,@y] == 1)

      # Gets Event
      #event = $map.events[@mouse_event_autostarter]
      @eventarray.each do |event|
      
        # If Event Within Range
        if event and ((@x == event.x or @y == event.y) || @ovrdest)
          # SHAZ - trigger event when:
          # - Autotouch and standing on or beside, or with a counter between
          # - player/event touch and standing as close as possible (on, if possible)
          distance = Math.hypot(@x - event.x, @y - event.y)
          dir = @x < event.x ? 6 : @x > event.x ? 4 : @y < event.y ? 2 : @y > event.y ? 8 : 0
          if (event.trigger == 0 and (distance < 2 or (distance == 2 and 
            $map.counter?((@x+event.x)/2, (@y+event.y)/2)))) or 
            ([1,2].include?(event.trigger) and ((distance == 0 and 
            $game_player.passable?(@x, @y, dir)) or (distance == 1 and
            (@ovrdest || !$game_player.passable?(@x, @y, dir)))))
            # Turn toward Event
            if @x == event.x
              turn_up if @y > event.y
              turn_down if @y < event.y
            else
              turn_left if @x > event.x
              turn_right if @x < event.x
            end
            # Start Event
            clear_path
            event.start # $map.events[@mouse_event_autostarter].start
            @eventarray.delete(event)
            @eventarray = nil if @eventarray.size == 0
            # Clear Flag
            #@mouse_event_autostarter = nil
          end
        end
      end      
    end
    
    # if not on ground terrain, check for boat or dragon exit
    #exit_vehicle if $game_variables[VEHICLE_VARIABLE] != 0 and Input.trigger?(Input::C)
      
  end

end
