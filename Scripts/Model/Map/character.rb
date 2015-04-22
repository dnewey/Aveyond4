#==============================================================================
# ** Game_Character (part 1)
#------------------------------------------------------------------------------
#  This class deals with characters. It's used as a superclass for the
#  Game_Player and Game_Event classes.
#==============================================================================

class Game_Character
  
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_reader   :id                       # ID
  
  attr_reader   :x                        # map x-coordinate (logical)
  attr_reader   :y                        # map y-coordinate (logical)
  attr_reader   :real_x                   # map x-coordinate (real * 128) # For precision
  attr_reader   :real_y                   # map y-coordinate (real * 128)
  
  
  # Graphics

  attr_accessor   :character_name           # character file name

  attr_accessor   :opacity                  # opacity level
  
  
  attr_accessor :direction                # direction
  attr_accessor   :pattern                  # pattern
  attr_reader   :move_route_forcing       # forced move route flag
  attr_reader   :through                  # through
  attr_accessor :animation_id             # animation ID
  attr_accessor :transparent              # transparent flag
  attr_accessor :ignore_movement          # ignore movement when finding path
  attr_accessor :step_anime               # stop animation
  
  
  # Custom
  attr_accessor :off_x, :off_y
  
   
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    @id = 0
    @x = 0
    @y = 0
    @real_x = 0
    @real_y = 0
    @character_name = ""
    @direction = 2
    @pattern = 0

    @move_route_forcing = false
    @through = false
    @animation_id = 0
    @transparent = false
    @original_direction = 2
    @original_pattern = 0

    @move_type = 0
    @move_speed = 3
    @move_frequency = 6
    @move_route = nil
    @move_route_index = 0

    @original_move_route = nil
    @original_move_route_index = 0
    @walk_anime = true
    @step_anime = false
    @direction_fix = false
    @always_on_top = false
    @anime_count = 0
    @stop_count = 0 #how long has paused for between steps

    @jump_count = 0
    @jump_peak = 0
    @wait_count = 0
    @locked = false
    @prelock_direction = 0
    @ignore_movement = false

    @opacity = 255
  end
  #--------------------------------------------------------------------------
  # * Determine if Moving
  #--------------------------------------------------------------------------
  def moving?
    return (@real_x != @x * 128 or @real_y != @y * 128)
  end
  #--------------------------------------------------------------------------
  # * Determine if Jumping
  #--------------------------------------------------------------------------
  def jumping?
    return @jump_count > 0
  end

  #--------------------------------------------------------------------------
  # * Straighten Position
  #--------------------------------------------------------------------------
  def straighten
    # If moving animation or stop animation is ON
    if @walk_anime or @step_anime
      # Set pattern to 0
      @pattern = 0
    end
    # Clear animation count
    @anime_count = 0
    # Clear prelock direction
    @prelock_direction = 0
  end
  #--------------------------------------------------------------------------
  # * Force Move Route
  #--------------------------------------------------------------------------
  def force_move_route(move_route)
    # Save original move route
    if @original_move_route == nil
      @original_move_route = @move_route
      @original_move_route_index = @move_route_index
    end
    # Change move route
    @move_route = move_route
    @move_route_index = 0
    # Set forced move route flag
    @move_route_forcing = true
    # Clear prelock direction
    @prelock_direction = 0
    # Clear wait count
    @wait_count = 0
    # Move cutsom
    move_type_custom
  end

  #--------------------------------------------------------------------------
  # * Determine if Passable
  #--------------------------------------------------------------------------
  def passable?(x, y, d) #d0 = jump

    return true

    # Get new coordinates
    new_x = x + (d == 6 ? 1 : d == 4 ? -1 : 0)
    new_y = y + (d == 2 ? 1 : d == 8 ? -1 : 0)
       
    # If coordinates are outside of map
    return false unless $map.valid?(new_x, new_y)
    return true if @through
    
    # To new tile and from new tile
    return false unless $map.passable?(x, y, d, self)
    return false unless $map.passable?(new_x, new_y, 10 - d) 

    # end
    return true

  end
  
  #--------------------------------------------------------------------------
  # * Determine if Can Fight 
  #--------------------------------------------------------------------------
  def canfight?()

    d = 2 if @x == $player.x and @y == $player.y - 1
    d = 8 if @x == $player.x and @y == $player.y + 1
    d = 4 if @y == $player.y and @x == $player.x + 1
    d = 6 if @y == $player.y and @x == $player.x - 1
    
    return passable?(x,y,d)

  end

  #--------------------------------------------------------------------------
  # * Lock
  #--------------------------------------------------------------------------
  def lock
    return if @locked
    @prelock_direction = @direction
    turn_toward_player
    @locked = true
  end

  #--------------------------------------------------------------------------
  # * Determine if Locked
  #--------------------------------------------------------------------------
  def lock?
    return @locked
  end

  #--------------------------------------------------------------------------
  # * Unlock
  #--------------------------------------------------------------------------
  def unlock
    return if !@locked

    # Clear locked flag
    @locked = false
    # If direction is not fixed
    unless @direction_fix
      # If prelock direction is saved
      if @prelock_direction != 0
        # Restore prelock direction
        @direction = @prelock_direction
      end
    end
  end

  #--------------------------------------------------------------------------
  # * Move to Designated Position
  #--------------------------------------------------------------------------
  def moveto(x, y)
    @x = x 
    @y = y 
    @real_x = @x * 128
    @real_y = @y * 128
    @prelock_direction = 0
  end

  #--------------------------------------------------------------------------
  # * Get Screen X-Coordinates
  #--------------------------------------------------------------------------
  def screen_x
    # Get screen coordinates from real coordinates and map display position
    return (@real_x - $map.display_x + 3) / 4 + 16
  end

  #--------------------------------------------------------------------------
  # * Get Screen Y-Coordinates
  #--------------------------------------------------------------------------
  def screen_y
    # Get screen coordinates from real coordinates and map display position
    y = (@real_y - $map.display_y + 3) / 4 + 32
    # Make y-coordinate smaller via jump count
    if @jump_count >= @jump_peak
      n = @jump_count - @jump_peak
    else
      n = @jump_peak - @jump_count
    end
    return y - (@jump_peak * @jump_peak - n * n) / 2
  end
  #--------------------------------------------------------------------------
  # * Get Screen Z-Coordinates
  #     height : character height
  #--------------------------------------------------------------------------
  def screen_z(height = 0)

    # Some sort of below character here
    # return 0 if @always on bottom

    return 999 if @always_on_top

    # Get screen coordinates from real coordinates and map display position
    z = (@real_y - $map.display_y + 3) / 4 + 32

    # If height exceeds 32, then add 31
    return z #+ ((height > 32) ? 31 : 0)


  end

  #--------------------------------------------------------------------------
  # * Get Thicket Depth
  #--------------------------------------------------------------------------
  def bush_depth
    return 0 if @always_on_top
    return 0 if jumping?
    return 12 if $map.bush?(@x, @y)
    return 0
  end

  #--------------------------------------------------------------------------
  # * Get Terrain Tag
  #--------------------------------------------------------------------------
  def terrain_tag() return $map.terrain_tag(@x, @y) end

  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update

    # Mouse pathfinding
    run_path if @runpath == true
    
    # Branch with jumping, moving, and stopping
    if jumping?
      update_jump
    elsif moving?
      update_move
    else
      update_stop
    end

    # If animation count exceeds maximum value
    # * Maximum value is move speed * 1 taken from basic value 18
    if @anime_count > 18 - @move_speed * 2
      # If stop animation is OFF when stopping
      if not @step_anime and @stop_count > 0
        # Return to original pattern
        @pattern = @original_pattern
      # If stop animation is ON when moving
      else
        # Update pattern
        @pattern = (@pattern + 1) % 4
      end
      # Clear animation count
      @anime_count = 0
    end


    # If waiting
    if @wait_count > 0
      # Reduce wait count
      @wait_count -= 1
      return
    end


    # If move route is forced
    if @move_route_forcing
      # Custom move
      move_type_custom
      return
    end
    # When waiting for event execution or locked
    if @starting or lock?
      # Not moving by self
      return
    end

    # If stop count exceeds a certain value (computed from move frequency)
    if @stop_count > (40 - @move_frequency * 2) * (6 - @move_frequency)
      # Branch by move type
      case @move_type
        when 1  # Random
          move_type_random
        when 2  # Approach
          move_type_toward_player
        when 3  # Custom
          move_type_custom
      end
    end

  end

  #--------------------------------------------------------------------------
  # * Frame Update (jump)
  #--------------------------------------------------------------------------
  def update_jump
    # Reduce jump count by 1
    @jump_count -= 1
    # Calculate new coordinates
    @real_x = (@real_x * @jump_count + @x * 128) / (@jump_count + 1)
    @real_y = (@real_y * @jump_count + @y * 128) / (@jump_count + 1)
  end

  #--------------------------------------------------------------------------
  # * Update frame (move)
  #--------------------------------------------------------------------------
  def update_move
    # Convert map coordinates from map move speed into move distance
    distance = 2 ** @move_speed
    # If logical coordinates are further down than real coordinates
    if @y * 128 > @real_y
      # Move down
      @real_y = [@real_y + distance, @y * 128].min
    end
    # If logical coordinates are more to the left than real coordinates
    if @x * 128 < @real_x
      # Move left
      @real_x = [@real_x - distance, @x * 128].max
    end
    # If logical coordinates are more to the right than real coordinates
    if @x * 128 > @real_x
      # Move right
      @real_x = [@real_x + distance, @x * 128].min
    end
    # If logical coordinates are further up than real coordinates
    if @y * 128 < @real_y
      # Move up
      @real_y = [@real_y - distance, @y * 128].max
    end

    # If move animation is ON
    if @walk_anime
      # Increase animation count by 1.5
      @anime_count += 1.5
    # If move animation is OFF, and stop animation is ON
    elsif @step_anime
      # Increase animation count by 1
      @anime_count += 1
    end

  end

  #--------------------------------------------------------------------------
  # * Frame Update (stop)
  #--------------------------------------------------------------------------
  def update_stop
    # If stop animation is ON
    if @step_anime
      # Increase animation count by 1
      @anime_count += 1
    # If stop animation is OFF, but current pattern is different from original
    elsif @pattern != @original_pattern
      # Increase animation count by 1.5
      @anime_count += 1.5
    end
    # When waiting for event execution, or not locked
    # * If lock deals with event execution coming to a halt
    unless @starting or lock?
      @stop_count += 1
    end
  end
  
  #--------------------------------------------------------------------------
  # * Move Type : Random
  #--------------------------------------------------------------------------
  def move_type_random
    # Branch by random numbers 0-5
    case rand(6)
      when 0..3  # Random
        move_random
      when 4  # 1 step forward
        move_forward
      when 5  # Temporary stop
        @stop_count = 0
    end
  end
  #--------------------------------------------------------------------------
  # * Move Type : Approach
  #--------------------------------------------------------------------------
  def move_type_toward_player
    # Get difference in player coordinates
    sx = @x - $game_player.x
    sy = @y - $game_player.y
    # Get absolute value of difference
    abs_sx = sx > 0 ? sx : -sx
    abs_sy = sy > 0 ? sy : -sy
    # If separated by 20 or more tiles matching up horizontally and vertically
    if sx + sy >= 20
      # Random
      move_random
      return
    end

    # What if they follow more aggressively on harder difficulty?
    # Branch by random numbers 0-5
    case rand(6)
    when 0..3  # Approach player
      move_toward_player
    when 4  # random
      move_random
    when 5  # 1 step forward
      move_forward
    end
  end

  #--------------------------------------------------------------------------
  # * Move Type : Custom
  #--------------------------------------------------------------------------
  def move_type_custom
    # Interrupt if not stopping
    return if jumping? or moving?

    # Loop until finally arriving at move command list
    while @move_route_index < @move_route.list.size

      # Acquiring move command
      command = @move_route.list[@move_route_index]

      # If command code is 0 (last part of list)
      if command.code == 0

        # Restart
        @move_route_index = 0 if @move_route.repeat

        # If [repeat action] option is OFF
        if !@move_route.repeat
          # If move route is forcing
          if @move_route_forcing

            # Release forced move route
            @move_route_forcing = false

            # Restore original move route
            @move_route = @original_move_route
            @move_route_index = @original_move_route_index
            @original_move_route = nil
          end
          # Clear stop count
          @stop_count = 0
        end
        return
      end

      # COL 1

      # During move command (from move down to jump)
      if command.code <= 14
        # Branch by command code
        case command.code
          when 1; move_down
          when 2  # Move left
            move_left
          when 3  # Move right
            move_right
          when 4  # Move up
            move_up
          when 5  # Move lower left
            move_lower_left
          when 6  # Move lower right
            move_lower_right
          when 7  # Move upper left
            move_upper_left
          when 8  # Move upper right
            move_upper_right
          when 9  # Move at random
            move_random
          when 10  # Move toward player
            move_toward_player
          when 11  # Move away from player
            move_away_from_player
          when 12  # 1 step forward
            move_forward
          when 13  # 1 step backward
            move_backward
          when 14  # Jump
            jump(command.parameters[0], command.parameters[1])
        end
        # If movement failure occurs when [Ignore if can't move] option is OFF
        if not @move_route.skippable and not moving? and not jumping?
          return
        end
        @move_route_index += 1
        return
      end

      # If waiting
      if command.code == 15
        # Set wait count
        @wait_count = command.parameters[0] * 2 - 1
        @move_route_index += 1
        return
      end

      # COL 2

      # If direction change command
      if command.code >= 16 and command.code <= 26
        # Branch by command code
        case command.code
        when 16  # Turn down
          turn_down
        when 17  # Turn left
          turn_left
        when 18  # Turn right
          turn_right
        when 19  # Turn up
          turn_up
        when 20  # Turn 90° right
          turn_right_90
        when 21  # Turn 90° left
          turn_left_90
        when 22  # Turn 180°
          turn_180
        when 23  # Turn 90° right or left
          turn_right_or_left_90
        when 24  # Turn at Random
          turn_random
        when 25  # Turn toward player
          turn_toward_player
        when 26  # Turn away from player
          turn_away_from_player
        end
        @move_route_index += 1
        return
      end

      # COL 3

      # If other command
      if command.code >= 27
        # Branch by command code
        case command.code
        
        when 29  # Change speed
          @move_speed = command.parameters[0]
        when 30  # Change freq
          @move_frequency = command.parameters[0]
        when 31  # Move animation ON
          @walk_anime = true
        when 32  # Move animation OFF
          @walk_anime = false
        when 33  # Stop animation ON
          @step_anime = true
        when 34  # Stop animation OFF
          @step_anime = false
        when 35  # Direction fix ON
          @direction_fix = true
        when 36  # Direction fix OFF
          @direction_fix = false
        when 37  # Through ON
          @through = true
        when 38  # Through OFF
          @through = false
        when 39  # Always on top ON
          @always_on_top = true
        when 40  # Always on top OFF
          @always_on_top = false
        when 41  # Change Graphic
          @character_name = command.parameters[0]
          if @original_direction != command.parameters[2]
            @direction = command.parameters[2]
            @original_direction = @direction
            @prelock_direction = 0
          end
          if @original_pattern != command.parameters[3]
            @pattern = command.parameters[3]
            @original_pattern = @pattern
          end
        when 42  # Change Opacity
          @opacity = command.parameters[0]
        when 43  # Change Blending
          @blend_type = command.parameters[0]
        when 44  # Play SE
          $game_system.se_play(command.parameters[0])
        when 45  # Script
          result = eval(command.parameters[0])
        end
        @move_route_index += 1
      end


    end


  end

  #--------------------------------------------------------------------------
  # * Increase Steps
  #--------------------------------------------------------------------------
  def increase_steps
    # Clear stop count
    @stop_count = 0
  end



    #--------------------------------------------------------------------------
  # * Move Down
  #     turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_down(turn_enabled = true)

    # Turn down
    if turn_enabled
      turn_down
    end
    # If passable
    if passable?(@x, @y, 2)

      # Turn down
      turn_down
      # Update coordinates
      @y += 1
      # Increase steps
      increase_steps
    # If impassable
    else
      # Determine if touch event is triggered IF ENEMY ONLY
      #check_event_trigger_touch(@x, @y+1)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Left
  #     turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_left(turn_enabled = true)
    # Turn left
    if turn_enabled
      turn_left
    end
    # If passable
    if passable?(@x, @y, 4)
      # Turn left
      turn_left
      # Update coordinates
      @x -= 1
      # Increase steps
      increase_steps
    # If impassable
    else
      # Determine if touch event is triggered
      #check_event_trigger_touch(@x-1, @y)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Right
  #     turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_right(turn_enabled = true)
    # Turn right
    if turn_enabled
      turn_right
    end
    # If passable
    if passable?(@x, @y, 6)
      # Turn right
      turn_right
      # Update coordinates
      @x += 1
      # Increase steps
      increase_steps
    # If impassable
    else
      # Determine if touch event is triggered
     # check_event_trigger_touch(@x+1, @y)
    end
  end
  #--------------------------------------------------------------------------
  # * Move up
  #     turn_enabled : a flag permits direction change on that spot
  #--------------------------------------------------------------------------
  def move_up(turn_enabled = true)
    # Turn up
    if turn_enabled
      turn_up
    end
    # If passable
    if passable?(@x, @y, 8)
      # Turn up
      turn_up
      # Update coordinates
      @y -= 1
      # Increase steps
      increase_steps
    # If impassable
    else
      # Determine if touch event is triggered
     # check_event_trigger_touch(@x, @y-1)
    end
  end
  #--------------------------------------------------------------------------
  # * Move Lower Left
  #--------------------------------------------------------------------------
  def move_lower_left
    # If no direction fix
    unless @direction_fix
      # Face down is facing right or up
      @direction = (@direction == 6 ? 4 : @direction == 8 ? 2 : @direction)
    end
    # When a down to left or a left to down course is passable
    if (passable?(@x, @y, 2) and passable?(@x, @y + 1, 4)) or
       (passable?(@x, @y, 4) and passable?(@x - 1, @y, 2))
      # Update coordinates
      @x -= 1
      @y += 1
      # Increase steps
      increase_steps
    end
  end
  #--------------------------------------------------------------------------
  # * Move Lower Right
  #--------------------------------------------------------------------------
  def move_lower_right
    # If no direction fix
    unless @direction_fix
      # Face right if facing left, and face down if facing up
      @direction = (@direction == 4 ? 6 : @direction == 8 ? 2 : @direction)
    end
    # When a down to right or a right to down course is passable
    if (passable?(@x, @y, 2) and passable?(@x, @y + 1, 6)) or
       (passable?(@x, @y, 6) and passable?(@x + 1, @y, 2))
      # Update coordinates
      @x += 1
      @y += 1
      # Increase steps
      increase_steps
    end
  end
  #--------------------------------------------------------------------------
  # * Move Upper Left
  #--------------------------------------------------------------------------
  def move_upper_left
    # If no direction fix
    unless @direction_fix
      # Face left if facing right, and face up if facing down
      @direction = (@direction == 6 ? 4 : @direction == 2 ? 8 : @direction)
    end
    # When an up to left or a left to up course is passable
    if (passable?(@x, @y, 8) and passable?(@x, @y - 1, 4)) or
       (passable?(@x, @y, 4) and passable?(@x - 1, @y, 8))
      # Update coordinates
      @x -= 1
      @y -= 1
      # Increase steps
      increase_steps
    end
  end
  #--------------------------------------------------------------------------
  # * Move Upper Right
  #--------------------------------------------------------------------------
  def move_upper_right
    # If no direction fix
    unless @direction_fix
      # Face right if facing left, and face up if facing down
      @direction = (@direction == 4 ? 6 : @direction == 2 ? 8 : @direction)
    end
    # When an up to right or a right to up course is passable
    if (passable?(@x, @y, 8) and passable?(@x, @y - 1, 6)) or
       (passable?(@x, @y, 6) and passable?(@x + 1, @y, 8))
      # Update coordinates
      @x += 1
      @y -= 1
      # Increase steps
      increase_steps
    end
  end
  #--------------------------------------------------------------------------
  # * Move at Random
  #--------------------------------------------------------------------------
  def move_random
    case rand(4)
    when 0  # Move down
      move_down(false)
    when 1  # Move left
      move_left(false)
    when 2  # Move right
      move_right(false)
    when 3  # Move up
      move_up(false)
    end
  end
  #--------------------------------------------------------------------------
  # * Move toward Player
  #--------------------------------------------------------------------------
  def move_toward_player
    # Get difference in player coordinates
    sx = @x - $player.x
    sy = @y - $player.y
    # If coordinates are equal
    if sx == 0 and sy == 0
      return
    end
    # Get absolute value of difference
    abs_sx = sx.abs
    abs_sy = sy.abs
    # If horizontal and vertical distances are equal
    if abs_sx == abs_sy
      # Increase one of them randomly by 1
      rand(2) == 0 ? abs_sx += 1 : abs_sy += 1
    end
    # If horizontal distance is longer
    if abs_sx > abs_sy
      # Move towards player, prioritize left and right directions
      sx > 0 ? move_left : move_right
      if not moving? and sy != 0
        sy > 0 ? move_up : move_down
      end
    # If vertical distance is longer
    else
      # Move towards player, prioritize up and down directions
      sy > 0 ? move_up : move_down
      if not moving? and sx != 0
        sx > 0 ? move_left : move_right
      end
    end
  end
  #--------------------------------------------------------------------------
  # * Move away from Player
  #--------------------------------------------------------------------------
  def move_away_from_player
    # Get difference in player coordinates
    sx = @x - $player.x
    sy = @y - $player.y
    # If coordinates are equal
    if sx == 0 and sy == 0
      return
    end
    # Get absolute value of difference
    abs_sx = sx.abs
    abs_sy = sy.abs
    # If horizontal and vertical distances are equal
    if abs_sx == abs_sy
      # Increase one of them randomly by 1
      rand(2) == 0 ? abs_sx += 1 : abs_sy += 1
    end
    # If horizontal distance is longer
    if abs_sx > abs_sy
      # Move away from player, prioritize left and right directions
      sx > 0 ? move_right : move_left
      if not moving? and sy != 0
        sy > 0 ? move_down : move_up
      end
    # If vertical distance is longer
    else
      # Move away from player, prioritize up and down directions
      sy > 0 ? move_down : move_up
      if not moving? and sx != 0
        sx > 0 ? move_right : move_left
      end
    end
  end
  #--------------------------------------------------------------------------
  # * 1 Step Forward
  #--------------------------------------------------------------------------
  def move_forward
    case @direction
    when 2
      move_down(false)
    when 4
      move_left(false)
    when 6
      move_right(false)
    when 8
      move_up(false)
    end
  end
  #--------------------------------------------------------------------------
  # * 1 Step Backward
  #--------------------------------------------------------------------------
  def move_backward
    # Remember direction fix situation
    last_direction_fix = @direction_fix
    # Force directino fix
    @direction_fix = true
    # Branch by direction
    case @direction
    when 2  # Down
      move_up(false)
    when 4  # Left
      move_right(false)
    when 6  # Right
      move_left(false)
    when 8  # Up
      move_down(false)
    end
    # Return direction fix situation back to normal
    @direction_fix = last_direction_fix
  end
  #--------------------------------------------------------------------------
  # * Jump
  #     x_plus : x-coordinate plus value
  #     y_plus : y-coordinate plus value
  #--------------------------------------------------------------------------
  def jump(x_plus, y_plus)
    # If plus value is not (0,0)
    if x_plus != 0 or y_plus != 0
      # If horizontal distnace is longer
      if x_plus.abs > y_plus.abs
        # Change direction to left or right
        x_plus < 0 ? turn_left : turn_right
      # If vertical distance is longer, or equal
      else
        # Change direction to up or down
        y_plus < 0 ? turn_up : turn_down
      end
    end
    # Calculate new coordinates
    new_x = @x + x_plus
    new_y = @y + y_plus
    # If plus value is (0,0) or jump destination is passable
    if (x_plus == 0 and y_plus == 0) or passable?(new_x, new_y, 0)
      # Straighten position
      straighten
      # Update coordinates
      @x = new_x
      @y = new_y
      # Calculate distance
      distance = Math.sqrt(x_plus * x_plus + y_plus * y_plus).round
      # Set jump count
      @jump_peak = 10 + distance - @move_speed
      @jump_count = @jump_peak * 2
      # Clear stop count
      @stop_count = 0
    end
  end

  #--------------------------------------------------------------------------
  # * Turns
  #--------------------------------------------------------------------------
  def turn_down() @direction = 2 unless @direction_fix end
  def turn_left() @direction = 4 unless @direction_fix end
  def turn_right() @direction = 6unless @direction_fix end
  def turn_up() @direction = 8 unless @direction_fix end
  
  #--------------------------------------------------------------------------
  # * Turn 90° Right
  #--------------------------------------------------------------------------
  def turn_right_90
    case @direction
    when 2
      turn_left
    when 4
      turn_up
    when 6
      turn_down
    when 8
      turn_right
    end
  end
  #--------------------------------------------------------------------------
  # * Turn 90° Left
  #--------------------------------------------------------------------------
  def turn_left_90
    case @direction
    when 2
      turn_right
    when 4
      turn_down
    when 6
      turn_up
    when 8
      turn_left
    end
  end
  #--------------------------------------------------------------------------
  # * Turn 180°
  #--------------------------------------------------------------------------
  def turn_180
    case @direction
    when 2
      turn_up
    when 4
      turn_right
    when 6
      turn_left
    when 8
      turn_down
    end
  end
  #--------------------------------------------------------------------------
  # * Turn 90° Right or Left
  #--------------------------------------------------------------------------
  def turn_right_or_left_90
    if rand(2) == 0
      turn_right_90
    else
      turn_left_90
    end
  end
  #--------------------------------------------------------------------------
  # * Turn at Random
  #--------------------------------------------------------------------------
  def turn_random
    case rand(4)
    when 0
      turn_up
    when 1
      turn_right
    when 2
      turn_left
    when 3
      turn_down
    end
  end
  #--------------------------------------------------------------------------
  # * Turn Towards Player
  #--------------------------------------------------------------------------
  def turn_toward_player
    # Get difference in player coordinates
    sx = @x - $player.x
    sy = @y - $player.y
    # If coordinates are equal
    if sx == 0 and sy == 0
      return
    end
    # If horizontal distance is longer
    if sx.abs > sy.abs
      # Turn to the right or left towards player
      sx > 0 ? turn_left : turn_right
    # If vertical distance is longer
    else
      # Turn up or down towards player
      sy > 0 ? turn_up : turn_down
    end
  end
  #--------------------------------------------------------------------------
  # * Turn Away from Player
  #--------------------------------------------------------------------------
  def turn_away_from_player
    # Get difference in player coordinates
    sx = @x - $player.x
    sy = @y - $player.y
    # If coordinates are equal
    if sx == 0 and sy == 0
      return
    end
    # If horizontal distance is longer
    if sx.abs > sy.abs
      # Turn to the right or left away from player
      sx > 0 ? turn_right : turn_left
    # If vertical distance is longer
    else
      # Turn up or down away from player
      sy > 0 ? turn_down : turn_up
    end
  end

  #--------------------------------------------------------------------------
  # * Turn Towards Event
  #--------------------------------------------------------------------------
  def turn_toward_event(event_id)
    # Get difference in player coordinates
    evt = $map.events[event_id]
    return if evt == nil
    sx = @x - evt.x
    sy = @y - evt.y
    # If coordinates are equal
    if sx == 0 and sy == 0
      return
    end
    # If horizontal distance is longer
    if sx.abs > sy.abs
      # Turn to the right or left towards event
      sx > 0 ? turn_left : turn_right
    # If vertical distance is longer
    else
      # Turn up or down towards event
      sy > 0 ? turn_up : turn_down
    end
  end

  def turn_toward_pos(x,y)

    sx = @x - x
    sy = @y - y

    # If coordinates are equal
    return if sx == 0 and sy == 0

    # If horizontal distance is longer
    if sx.abs > sy.abs
      # Turn to the right or left towards event
      sx > 0 ? turn_left : turn_right
    # If vertical distance is longer
    else
      # Turn up or down towards event
      sy > 0 ? turn_up : turn_down
    end
  end
  #   #--------------------------------------------------------------------------
#   # * Frame Update (run_path)
#   #--------------------------------------------------------------------------
  def run_path

    return if moving?

    step = @map[@x,@y]
    if step == 1 # AT TARGET POS
      @map = nil
      @runpath = false
      return
    end
      
    # maybe cut the step != 0, would be broken if there

    dir = rand(2)
    case dir
    when 0
      move_right if @map[@x+1,@y] == step - 1 and step != 0
      move_down if @map[@x,@y+1] == step - 1 and step != 0
      move_left if @map[@x-1,@y] == step - 1 and step != 0
      move_up if @map[@x,@y-1] == step - 1 and step != 0
    when 1
      move_up if @map[@x,@y-1] == step - 1 and step != 0
      move_left if @map[@x-1,@y] == step - 1 and step != 0
      move_down if @map[@x,@y+1] == step - 1 and step != 0
      move_right if @map[@x+1,@y] == step - 1 and step != 0
    end
  end

  #--------------------------------------------------------------------------
  # * Find Path
  #--------------------------------------------------------------------------
  def find_path(x,y)
    sx, sy = @x, @y
    @tx, @ty = x, y
    tx, ty = x,y
    result = setup_map(sx,sy,tx,ty)
    @runpath = result[0]
    @map = result[1]
    @map[sx,sy] = result[2] if result[2] != nil
  end
  #--------------------------------------------------------------------------
  # * Clear Path
  #--------------------------------------------------------------------------
  def clear_path
    @map = nil
    @runpath = false
  end
  #--------------------------------------------------------------------------
  # * Setup Map
  #--------------------------------------------------------------------------
  def setup_map(sx,sy,tx,ty) #tx and ty in params for external call

    map = Table.new($map.width, $map.height)

    update_counter = 0
    map[tx,ty] = 1
    old_positions = [[tx, ty]]
    new_positions = []

    depth = 2

    depth.upto(100){ |step|
      while !old_positions.empty?

        x,y = old_positions.shift

        #log_sys([x,y])

        if x == sx and y == sy
          log_scr("WINWINWINW")
          return [true, map, step-1] 
        end

        if map[x,y + 1] == 0 and passable?(x, y, 2) 
          #log_err "IN"
          map[x,y + 1] = step
          new_positions.push([x,y + 1])
        end

        if map[x - 1,y] == 0 and passable?(x, y, 4) 
          map[x - 1,y] = step
          new_positions.push([x - 1,y])
        end

        if map[x + 1,y] == 0 and passable?(x, y, 6) 
          map[x + 1,y] = step
          new_positions.push([x + 1,y])
        end

        if map[x,y - 1] == 0 and passable?(x, y, 8) 
          map[x,y - 1] = step
          new_positions.push([x,y - 1])
        end

      end

      old_positions = new_positions
      new_positions = []

      #log_info (old_positions)
    }
      
      log_err "FAILFAIL"
    return [false, nil, nil]     

  end


end
