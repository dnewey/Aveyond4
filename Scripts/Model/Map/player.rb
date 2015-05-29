#==============================================================================
# ** Game_Player
#------------------------------------------------------------------------------
#  This class handles the player. Its functions include event starting
#  determinants and map scrolling. Refer to "$game_player" for the one
#  instance of this class.
#==============================================================================

class Game_Player < Game_Character

  attr_accessor :transferring      # player place movement flag

  def initialize
    super
    looklike("boy")
    @transferring = false
    @xfer_data = nil
    @static = false
  end

  def transfer(map,x,y,dir)
    @transferring = true
    @xfer_data = [map,x,y,dir]
  end

  def transfer_to(map,target,after=nil)
    @transferring = true
    @xfer_data = [map,target,after]
  end

  def name
    return "Player"
  end

  def looklike(char)
    self.character_name = "Player/#{char}"
  end

  def static
    @static = true
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

    if result == false

      # If front tile is a counter
      if $map.counter?(new_x, new_y)
        # Calculate 1 tile inside coordinates
        new_x += (@direction == 6 ? 1 : @direction == 4 ? -1 : 0)
        new_y += (@direction == 2 ? 1 : @direction == 8 ? -1 : 0)
        # All event loops
        for event in $map.events.values
          # If event coordinates and triggers are consistent
          if event.x == new_x and event.y == new_y and
             triggers.include?(event.trigger) and event.list.size > 1
            # If starting determinant is front event (other than jumping)
            if not event.jumping? and not event.over_trigger?
              event.start
              result = true
            end
          end
        end
      end
    end

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
          if event.trigger == 2
            start_battle
            return true
          else
            event.start
            result = true
          end
        end
      end
    end
    return result
  end

  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update

    return if @static

    return super if @move_route_forcing
    return super(true) if ($scene.busy?) || $debug.busy? # Still finish turn anim
    return super(true) if $map.interpreter.running? # Still finish turn anim
    

    transfer_player if @transferring 

    # Unless Interpretter Running, Forcing a Route or Message Showing

    if $input.click?

        # Gets Mouse X & Y
        mx, my = *$mouse.grid

        $scene.add_spark('click',$mouse.x+($map.display_x/4)+3,$mouse.y+($map.display_y/4)+5)
        $audio.sys('walkto',0.7)
        
        
        # Turn Character in direction
        #turn_toward_pos(mx,my)
        
        # Run Pathfinding
        evt = $map.event_at(mx, my)
        if evt == nil
          find_path(mx, my)
          @eventarray = @runpath ? $map.events_at(mx, my) : nil
        else
           find_path(evt.x+1, evt.y+1)
           @eventarray = [evt]
        end
        
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
    clear_path if $input.dir4 != 0
    
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

  #--------------------------------------------------------------------------
  # * Teleport the Player
  #--------------------------------------------------------------------------
  def transfer_player

    Graphics.freeze
   
    @transferring = false
    $player.clear_path

    # Map to teleport to 
    if $map.id != @xfer_data[0]
      $map.setup(@xfer_data[0])      
    end

      ev = gev(@xfer_data[1])
      if @xfer_data[2] != nil
        case @xfer_data[2]
          when 'd'
            @direction = 2
          when 'l'
            @direction = 4
          when 'r'
            @direction = 6
          when 'u'
            @direction = 8
        end
      end
      dx = 0
      dy = 0
      dx = 1 if @direction == 6
      dx = -1 if @direction == 4
      dy = 1 if @direction == 2
      dy = -1 if @direction == 8
      $player.moveto(ev.x+dx,ev.y+dy)
      #$player.direction = @xfer_data[3]

      $player.straighten  

      $game.update

      $scene.overlay.opacity = 255


      #Graphics.transition(16)
       Graphics.transition(45,'Graphics/Transitions/cave') 

       Graphics.freeze

       $scene.overlay.opacity = 0
       Graphics.transition(45,'Graphics/Transitions/cave_inv')      

    #end

    # AUTO SAVING

    # autosave your game (but not on the ending map)
   # if !ENDING_MAPS.include?($game_map.map_id)
   #   save = Scene_Save.new(1)
   #   save.autosave      
   # end
    
  end

end
