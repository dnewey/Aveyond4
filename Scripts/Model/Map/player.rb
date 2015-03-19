#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles the player. Its functions include event starting
#  determinants and map scrolling. Refer to "$game_player" for the one
#  instance of this class.
#==============================================================================

class Game_Player < Game_Character

  def initialize
    super
    @character_name = "boyle"
  end

  #--------------------------------------------------------------------------
  # * Passable Determinants
  #--------------------------------------------------------------------------
  def passable?(x, y, d)
    if DEBUG and Input.press?(Input::CTRL)
      return true
    end
    super
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

    # Calculate front event coordinates
    new_x = @x + (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
    new_y = @y + (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
    
    # All event loops
    for event in $map.events.values
      # If event coordinates and triggers are consistent
      if event.at?(new_x,new_y) &&
         triggers.include?(event.trigger) and event.list.size > 1


        # If starting determinant is front event (other than jumping)
        if !event.jumping? and !event.over_trigger?
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
        
    return false if $map.interpreter.running?
      
    result = false

    # All event loops
    for event in $map.events.values
      # If event coordinates and triggers are consistent
      if event.at?(x,y) and [1,2].include?(event.trigger)
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

    return if ($hud && $hud.busy?) || $debug.busy?
    return if $map.interpreter.running? or @move_route_forcing 

    # Unless Interpretter Running, Forcing a Route or Message Showing

    if $input.action?

        # Gets Mouse X & Y
        mx, my = *$mouse.grid

        log_info([mx,my])
        
        # Turn Character in direction
        newd_x = (@x - mx).abs
        newd_y = (@y - my).abs
        
        if @x > mx 
            turn_left if newd_x >= newd_y 
        elsif @x < mx
            turn_right if newd_x >= newd_y 
        end  
            
        if @y > my
            turn_up if newd_x < newd_y 
        elsif @y < my
            turn_down if newd_x < newd_y 
        end 
        
        # Run Pathfinding
        evt = $map.lowest_event_at(mx, my)
#        if evt == nil
          find_path(mx, my)
          @eventarray = @runpath ? $map.events_at(mx, my) : nil
        # else
        #   find_path(evt.x, evt.y)
        #   @eventarray = [evt]
        # end
        
        # If Event At Grid Location
        unless @eventarray.nil?
          @eventarray = nil if @eventarray.empty?
        end
        
      end
    
    if @move_route_forcing == true
      clear_path
      @eventarray = nil
    end

    # Clear path if any direction keys pressed
    $player.clear_path if $input.dir4 != 0
    
    # Remember whether or not moving in local variables
    last_moving = moving?
    # If moving, event running, move route forcing, and message window
    # display are all not occurring
    unless moving? || $map.interpreter.running? || @move_route_forcing
      case $input.dir4
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
   
    # If not moving
    unless moving?
      # If player was moving last time
      if last_moving
        # Event determinant is via touch of same position event
        result = check_event_trigger_here([1,2])
      end
      # If C button was pressed
      if $input.action?
        # Same position and front event determinant
        check_event_trigger_here([0])
        check_event_trigger_there([0,1,2])
      end
    end
    
    # If Non-nil Event Autostarter
    if @eventarray != nil && !moving? && # @mouse_event_autostarter != nil && !moving? &&
      (!@ovrdest || @map.nil? || @map[@x,@y] == 1)

      @eventarray.each do |event|
      
        # If Event Within Range
        # if event and (event.at?(@x,@y) || @ovrdest
          
        #   # SHAZ - trigger event when:
        #   # - Autotouch and standing on or beside, or with a counter between
        #   # - player/event touch and standing as close as possible (on, if possible)
        #   distance = Math.hypot(@x - event.x, @y - event.y)

        #   dir = @x < event.x ? 6 : @x > event.x ? 4 : @y < event.y ? 2 : @y > event.y ? 8 : 0

        #   # if (event.trigger == 0 and (distance < 2 or (distance == 2 and 
        #   #   $map.counter?((@x+event.x)/2, (@y+event.y)/2))))             or ([1,2].include?(event.trigger) and ((distance == 0 and $game_player.passable?(@x, @y, dir))             or (distance == 1 and (@ovrdest || !$game_player.passable?(@x, @y, dir)))))

        #   #   # Turn toward Event
        #   #   if @x == event.x
        #   #     @y > event.y ? turn_up : turn_down
        #   #   else
        #   #     @x > event.x ? turn_left : turn_right
        #   #   end

        #   #   # Start Event
        #   #   clear_path
        #   #   event.start
        #   #   @eventarray.delete(event)
        #   #   @eventarray = nil if @eventarray.empty?

        #   # end
        # end
      end      
    end
    

  end

end
