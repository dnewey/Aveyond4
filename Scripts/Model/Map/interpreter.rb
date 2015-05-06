#==============================================================================
# ** Interpreter (part 1)
#------------------------------------------------------------------------------
#  This interpreter runs event commands. This class is used within the
#  Game_System class and the Game_Event class.
#==============================================================================

class Interpreter

  attr_accessor :common_event_id

  attr_accessor :wait_count

  attr_accessor :event_id
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     depth : nest depth
  #     main  : main flag
  #--------------------------------------------------------------------------
  def initialize(depth = 0, main = false)
    @depth = depth
    @main = main

    @common_event_id = 0
    
    # Depth goes up to level 100
    if depth > 100
      print("Common event call has exceeded maximum limit.")
      exit
    end
    
    # Clear inner situation of interpreter
    clear
    
  end
  
  #--------------------------------------------------------------------------
  # * Reset
  #   Remove any queued items 
  #--------------------------------------------------------------------------
  def reset
    @list = nil
  end
  
  #--------------------------------------------------------------------------
  # * Clear
  #--------------------------------------------------------------------------
  def clear
    @map_id = 0                       # map ID when starting up
    @event_id = 0                     # event ID
    @message_waiting = false          # waiting for message to end
    @move_route_waiting = false       # waiting for move completion
    @wait_count = 0                   # wait count
    @child_interpreter = nil          # child interpreter
    @branch = {}                      # branch data
  end

  #--------------------------------------------------------------------------
  # * Event Setup
  #     list     : list of event commands
  #     event_id : event ID
  #--------------------------------------------------------------------------
  def setup(list, event_id)
    
    # Clear inner situation of interpreter
    clear
    
    # Remember map ID
    @map_id = $map.id
    
    # Remember event ID
    @event_id = event_id
    
    # Remember list of event commands
    @list = list
    
    # Initialize index
    @index = 0
    
    # Clear branch data hash
    @branch.clear
    
  end
  
  #--------------------------------------------------------------------------
  # * Current event (as event, not id)
  #--------------------------------------------------------------------------
  def event
    return $map.events[@event_id]
  end
  
  #--------------------------------------------------------------------------
  # * Determine if Running
  #--------------------------------------------------------------------------
  def running?
    return @list != nil
  end
  
  #--------------------------------------------------------------------------
  # * Starting Event Setup
  #--------------------------------------------------------------------------
  def setup_starting_event
    
    # Refresh map if necessary
    if $map.need_refresh
      $map.refresh
    end
    
    # If common event call is reserved
    if @common_event_id > 0
      
      # Set up event
      setup($data.commons[@common_event_id].list, 0)
      
      # Release reservation
      @common_event_id = 0
      
      return
      
    end
    
    # Loop (map events)
    $map.starting_events.each{ |e| 

        # If not auto run
        if e.trigger < 3
          
          e.clear_starting
          e.lock          
        end
        
        # Set up event
        setup(e.list, e.id)
        
        return      
    }
    
  end
  
  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    
    # Initialize loop count
    @loop_count = 0
    
    # Loop
    loop do
      
      # Add 1 to loop count
      @loop_count += 1
      
      # If 100 event commands ran
      if @loop_count > 100
        # Call Graphics.update for freeze prevention
        Graphics.update
        @loop_count = 0
      end
      
      # If map is different than event startup time
      if $map.id != @map_id
        # Change event ID to 0
        @event_id = 0
      end
      
      # If a child interpreter exists, run it then check if done
      if @child_interpreter != nil
        @child_interpreter.update
        @child_interpreter = nil if !@child_interpreter.running?  
        return if @child_interpreter != nil        
      end
      
      # If waiting for message to end
      return if @message_waiting

      # Misc hud busy
      return if $scene.busy?

      # If waiting for move to end
      if @move_route_waiting

        # If player is forcing move route
        if $player.move_route_forcing
          return
        end
        
        # Loop (map events)
        for event in $map.events.values
          
          # If this event is forcing move route
          if event.move_route_forcing
            return
          end
          
        end
        
        # Clear move end waiting flag
        @move_route_waiting = false
        
      end
      
      # If waiting
      if @wait_count > 0
        # Decrease wait count
        @wait_count -= 1
        return
      end

      # If list of event commands is empty
      if @list == nil
        
        # If main map event
        if @main
          # Set up starting event
          setup_starting_event
        end
        
        # If nothing was set up
        if @list == nil
          return
        end
        
      end
      
      # If return value is false when trying to execute event command
      if execute_command == false
        return
      end
      
      # Advance index
      @index += 1
      
    end
  end

    #--------------------------------------------------------------------------
  # * Event Command Execution
  #--------------------------------------------------------------------------
  def execute_command
   
    # If last to arrive for list of event commands
    if @index >= @list.size - 1
      command_end
      return true
    end

    # Make event command parameters available for reference via @parameters
    @parameters = @list[@index].parameters

    # Check if this is a label marker
    # If it is check if applies, if so keep going,
    # Otherwise skip to next label
    if @list[@index].code == 108 && @parameters[0].include?('@')

      # Keep going until a label passes or end of events
      while true

        # No more commands, end it
        if @index >= @list.size - 1
          command_end
          return true
        end

        if @list[@index].code == 108
          break if this.label_applies?(@list[@index].parameters[0])
        end

        @index += 1

      end

    end

    # Branch by command code
    return true if @list[@index].code == 108
    return true if @list[@index].code == 509
    send("command_"+@list[@index].code.to_s)
    
  end
  #--------------------------------------------------------------------------
  # * End Event
  #--------------------------------------------------------------------------
  def command_end
    # Clear list of event commands
    @list = nil
    # If main map event and event ID are valid
    if @main and @event_id > 0
      # Unlock event
      $map.events[@event_id].unlock
    end

    # Tell the even that it is stopping so it can mark second
    this.stop 
  end

  #--------------------------------------------------------------------------
  # * Command Skip
  #--------------------------------------------------------------------------
  def command_skip
    # Get indent
    indent = @list[@index].indent
    # Loop
    loop do
      # If next event command is at the same level as indent
      if @list[@index+1].indent == indent
        # Continue
        return true
      end
      # Advance index
      @index += 1
    end
  end
  #--------------------------------------------------------------------------
  # * Get Character
  #     parameter : parameter
  #--------------------------------------------------------------------------
  def get_character(parameter)
    # Branch by parameter
    case parameter
    when -1  # player
      return $player
    when 0  # this event
      events = $map.events
      return events == nil ? nil : events[@event_id]
    else  # specific event
      events = $map.events
      return events == nil ? nil : events[parameter]
    end
  end

  #--------------------------------------------------------------------------
  # * Calculate Operated Value
  #     operation    : operation
  #     operand_type : operand type (0: invariable 1: variable)
  #     operand      : operand (number or variable ID)
  #--------------------------------------------------------------------------
  def operate_value(operation, operand_type, operand)
    # Get operand
    if operand_type == 0
      value = operand
    else
      value = $game_variables[operand]
    end
    # Reverse sign of integer if operation is [decrease]
    if operation == 1
      value = -value
    end
    # Return value
    return value
  end


    def next_event_code
    @list[@index+1].code
  end

    #--------------------------------------------------------------------------
  # * Show Text
  #--------------------------------------------------------------------------
  def command_101

    message = []
    message.push(@list[@index].parameters[0])
    while next_event_code == 401
      @index += 1
      message.push(@list[@index].parameters[0])
    end

    message = message.join(' ')

    # If there is a choice next, add it
    if next_event_code == 102
      @index+=1
      while next_event_code == 402

      end
    end

    $scene.hud.message.start(message)
    
    # Return mouse to default cursor
    #$mouse_sprite.set_bitmap(MouseCursor::Default_Cursor)
    
    # Continue
    return true

  end

  #--------------------------------------------------------------------------
  # * Wait
  #--------------------------------------------------------------------------
  def command_106
    @wait_count = @parameters[0]
    return true
  end

  #--------------------------------------------------------------------------
  # * Conditional Branch
  #--------------------------------------------------------------------------
  def command_111
    
    result = eval(@parameters[1])
    return true if result
  
    # Skip it
    @branch[@list[@index].indent] = result
    return command_skip
  
  end
  #--------------------------------------------------------------------------
  # * Else
  #--------------------------------------------------------------------------
  def command_411
    # If determinant results are false
    if @branch[@list[@index].indent] == false
      # Delete branch data
      @branch.delete(@list[@index].indent)
      # Continue
      return true
    end
    # If it doesn't meet the conditions: command skip
    return command_skip
  end
 
  #--------------------------------------------------------------------------
  # * Exit Event Processing
  #--------------------------------------------------------------------------
  def command_115
    command_end
    return true
  end

  #--------------------------------------------------------------------------
  # * Label
  #--------------------------------------------------------------------------
  def command_118
    return true
  end

  #--------------------------------------------------------------------------
  # * Jump to Label
  #--------------------------------------------------------------------------
  def command_119
    # Get label name
    label_name = @parameters[0]
    # Initialize temporary variables
    temp_index = 0
    # Loop
    loop do

      # If a fitting label was not found
      return true if temp_index >= @list.size-1

      # If this event command is a designated label name
      if @list[temp_index].code == 118 and
         @list[temp_index].parameters[0] == label_name
        # Update index
        @index = temp_index
        # Continue
        return true
      end
      # Advance index
      temp_index += 1
    end
  end

  #--------------------------------------------------------------------------
  # * Transfer Player
  #--------------------------------------------------------------------------
  def command_201

    # If transferring player, showing message, or processing transition
    return false if $player.transferring || $scene.busy?
    
    # If appointment method is [direct appointment]
    $player.queue_xfer(@parameters[1],@parameters[2],@parameters[3],@parameters[4])
    
    # Advance index
    @index += 1

    # If fade is set <---- CUT
    # if @parameters[5] == 0
    #   # Prepare for transition
    #   Graphics.freeze
    #   # Set transition processing flag
    #   $game_temp.transition_processing = true
    #   $game_temp.transition_name = ""
    # end

    # End
    return false
  end

  #--------------------------------------------------------------------------
  # * Set Event Location
  #--------------------------------------------------------------------------
  def command_202

    # Get character
    character = get_character(@parameters[0])
    return true if character == nil

    # If appointment method is [direct appointment]
    if @parameters[1] == 0
      # Set character position
      character.moveto(@parameters[2], @parameters[3])
    # If appointment method is [appoint with variables]
    elsif @parameters[1] == 1
      # Set character position
      character.moveto($game_variables[@parameters[2]],
        $game_variables[@parameters[3]])
    # If appointment method is [exchange with another event]
    else
      old_x = character.x
      old_y = character.y
      character2 = get_character(@parameters[2])
      if character2 != nil
        character.moveto(character2.x, character2.y)
        character2.moveto(old_x, old_y)
      end
    end
    # Set character direction
    case @parameters[4]
      when 8  # up
        character.turn_up
      when 6  # right
        character.turn_right
      when 2  # down
        character.turn_down
      when 4  # left
        character.turn_left
    end
    # Continue
    return true
  end

  #--------------------------------------------------------------------------
  # * Change Map Settings
  #--------------------------------------------------------------------------
  def command_204
    case @parameters[0]
    when 0  # panorama
      $game_map.panorama_name = @parameters[1]
      $game_map.panorama_hue = @parameters[2]
    when 1  # fog
      $game_map.fog_name = @parameters[1]
      $game_map.fog_hue = @parameters[2]
      $game_map.fog_opacity = @parameters[3]
      $game_map.fog_blend_type = @parameters[4]
      $game_map.fog_zoom = @parameters[5]
      $game_map.fog_sx = @parameters[6]
      $game_map.fog_sy = @parameters[7]
    end
    # Continue
    return true
  end

  #--------------------------------------------------------------------------
  # * Change Fog Opacity
  #--------------------------------------------------------------------------
  def command_206
    # Start opacity level change
    $game_map.start_fog_opacity_change(@parameters[0], @parameters[1] * 2)
    # Continue
    return true
  end
  #--------------------------------------------------------------------------
  # * Show Animation
  #--------------------------------------------------------------------------
  def command_207
    # Get character
    character = get_character(@parameters[0])
    return true if character == nil

    # Set animation ID
    character.animation_id = @parameters[1]
    # Continue
    return true

  end
  #--------------------------------------------------------------------------
  # * Change Transparent Flag
  #--------------------------------------------------------------------------
  def command_208
    $game_player.transparent = (@parameters[0] == 0)
    return true
  end

  #--------------------------------------------------------------------------
  # * Set Move Route
  #--------------------------------------------------------------------------
  def command_209
    # Get character
    character = get_character(@parameters[0])
    # If no character exists
    return true if character == nil

    # Force move route - pushes on top of auto movers
    character.force_move_route(@parameters[1])
    return true
  end
  
  #--------------------------------------------------------------------------
  # * Wait for Move's Completion
  #--------------------------------------------------------------------------
  def command_210
    @move_route_waiting = true
    return true
  end
  
  #--------------------------------------------------------------------------
  # * Change Screen Color Tone
  #--------------------------------------------------------------------------
  def command_223
    $game_screen.start_tone_change(@parameters[0], @parameters[1] * 2)
    return true
  end

  #--------------------------------------------------------------------------
  # * Set Weather Effects
  #--------------------------------------------------------------------------
  def command_236
    # Set Weather Effects
    $game_screen.weather(@parameters[0], @parameters[1], @parameters[2])
    # Continue
    return true
  end

  #--------------------------------------------------------------------------
  # * Play BGM
  #--------------------------------------------------------------------------
  def command_241
    # Play BGM
    $game_system.bgm_play(@parameters[0])
    # Continue
    return true
  end

  #--------------------------------------------------------------------------
  # * Fade Out BGM
  #--------------------------------------------------------------------------
  def command_242
    # Fade out BGM
    $game_system.bgm_fade(@parameters[0])
    # Continue
    return true
  end
  #--------------------------------------------------------------------------
  # * Play BGS
  #--------------------------------------------------------------------------
  def command_245
    # Play BGS
    $game_system.bgs_play(@parameters[0])
    # Continue
    return true
  end
  #--------------------------------------------------------------------------
  # * Fade Out BGS
  #--------------------------------------------------------------------------
  def command_246
    # Fade out BGS
    $game_system.bgs_fade(@parameters[0])
    # Continue
    return true
  end
  #--------------------------------------------------------------------------
  # * Memorize BGM/BGS
  #--------------------------------------------------------------------------
  def command_247
    # Memorize BGM/BGS
    $game_system.bgm_memorize
    $game_system.bgs_memorize
    # Continue
    return true
  end
  #--------------------------------------------------------------------------
  # * Restore BGM/BGS
  #--------------------------------------------------------------------------
  def command_248
    # Restore BGM/BGS
    $game_system.bgm_restore
    $game_system.bgs_restore
    # Continue
    return true
  end
  #--------------------------------------------------------------------------
  # * Play ME
  #--------------------------------------------------------------------------
  def command_249
    # Play ME
    $game_system.me_play(@parameters[0])
    # Continue
    return true
  end
  #--------------------------------------------------------------------------
  # * Play SE
  #--------------------------------------------------------------------------
  def command_250
    $audio.play_se(@parameters[0])
    return true
  end
  #--------------------------------------------------------------------------
  # * Stop SE
  #--------------------------------------------------------------------------
  def command_251
    # Stop SE
    Audio.se_stop
    # Continue
    return true
  end


  #--------------------------------------------------------------------------
  # * Shop Processing
  #--------------------------------------------------------------------------
  def command_302

    # Set shop calling flag
    $game_temp.shop_calling = true
    # Set goods list on new item
    $game_temp.shop_goods = [@parameters]
    # Loop
    loop do
      # Advance index
      @index += 1
      # If next event command has shop on second line or after
      if @list[@index].code == 605
        # Add goods list to new item
        $game_temp.shop_goods.push(@list[@index].parameters)
      # If event command does not have shop on second line or after
      else
        # End
        return false
      end
    end
  end


    #--------------------------------------------------------------------------
  # * Script
  #--------------------------------------------------------------------------
  def command_355
    # Set first line to script
    script = @list[@index].parameters[0] + "\n"
    # Loop
    loop do
      # If next event command is second line of script or after
      if @list[@index + 1].code == 655
        # Add second line or after to script
        script += @list[@index + 1].parameters[0] + "\n"
      # If event command is not second line or after
      else
        # Abort loop
        break
      end
      # Advance index
      @index += 1
    end
    
    # Evaluation
    result = eval(script)

    return true

  rescue Exception => e

    line = e.message.split(":")[1].to_i      
    log_scr e.inspect.split(":in `")[0]
    log_scr e.inspect.split(":in `")[1]

    lc = 0
      script.split("\n").each{ |s|
        if lc == line
          s = "---> "+s
        end
        log_scr s
        lc+=1
      }

    # Continue
    return true
     
  end

end
