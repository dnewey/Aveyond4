#==============================================================================
# ** Interpreter
#==============================================================================

class Interpreter

  attr_accessor :common_event_id

  attr_accessor :wait_count

  attr_accessor :event_id
  
  attr_accessor :battlemap

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
    return $scene.map.events[@event_id]
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
    if $scene.map.need_refresh
      $scene.map.refresh
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
    $scene.map.starting_events.each{ |e| 

        # If not auto run
        #if e.trigger < 3
          
          e.clear_starting
          e.lock          
       # end
        
        # Set up event

        # Make sure autoruns don't run a second time if disabled
        return if e.disabled || e.deleted || e.erased

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

      return if $scene.is_a?(Scene_GameOver)
      
      # Add 1 to loop count
      @loop_count += 1
      
      # If 100 event commands ran
      if @loop_count > 100
        # Call Graphics.update for freeze prevention
        Graphics.update
        @loop_count = 0
      end
      
      # If map is different than event startup time
      if $scene.map.id != @map_id
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
      return if $scene.is_a?(Scene_Menu)

      return if $scene.is_a?(Scene_Battle) && !battlemap
      return if $scene.busy?


      return if $scene.map.camera_moving?

      # If waiting for move to end
      if @move_route_waiting

        # If player is forcing move route
        if $player.move_route_forcing
          return
        end
        
        # Loop (map events)
        for event in $scene.map.events.values
          
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

        if @list[@index].code == 108 && this != nil
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

    # Fix for going into battle mid event
    # Cut this or something, change all maps here to $scene.map?
    if $scene.map.events[@event_id] == nil
      @list = nil
      return
    end

    # Clear list of event commands
    @list = nil
    # If main map event and event ID are valid
    if @main and @event_id > 0
      # Unlock event
      $scene.map.events[@event_id].unlock
    end

    # Tell the even that it is stopping so it can mark second
    $scene.map.events[@event_id].stop 

  end

  # #--------------------------------------------------------------------------
  # # * Command Skip
  # #--------------------------------------------------------------------------
  # def command_skip
  #   # Get indent
  #   indent = @list[@index].indent
  #   # Loop
  #   loop do
  #     # If next event command is at the same level as indent
  #     if @list[@index+1].indent == indent
  #       # Continue
  #       return true
  #     end
  #     # Advance index
  #     @index += 1
  #   end
  # end
  # #--------------------------------------------------------------------------
  # # * Get Character
  # #     parameter : parameter
  # #--------------------------------------------------------------------------
  # def get_character(parameter)
  #   # Branch by parameter
  #   case parameter
  #   when -1  # player
  #     return $player
  #   when 0  # this event
  #     events = $map.events
  #     return events == nil ? nil : events[@event_id]
  #   else  # specific event
  #     events = $map.events
  #     return events == nil ? nil : events[parameter]
  #   end
  # end

  # #--------------------------------------------------------------------------
  # # * Calculate Operated Value
  # #     operation    : operation
  # #     operand_type : operand type (0: invariable 1: variable)
  # #     operand      : operand (number or variable ID)
  # #--------------------------------------------------------------------------
  # def operate_value(operation, operand_type, operand)
  #   # Get operand
  #   if operand_type == 0
  #     value = operand
  #   else
  #     value = $game_variables[operand]
  #   end
  #   # Reverse sign of integer if operation is [decrease]
  #   if operation == 1
  #     value = -value
  #   end
  #   # Return value
  #   return value
  # end


    def next_event_code
    @list[@index+1].code
  end

  def queue_text(txt)

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
    while next_event_code == 101 && @list[@index+1].parameters[0].include?("@")
      @index+=1
      $scene.hud.message.add_choice(@list[@index].parameters[0])
    end

    $scene.hud.message.start(message)

    # If vn mode
    
    #$scene.hud.message.start_vn(message)
    
    # Return mouse to default cursor
    #$mouse.set_cursor('Default')
    
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

  # #--------------------------------------------------------------------------
  # # * Conditional Branch
  # #--------------------------------------------------------------------------
  # def command_111
    
  #   result = eval(@parameters[1])
  #   return true if result
  
  #   # Skip it
  #   @branch[@list[@index].indent] = result
  #   return command_skip
  
  # end
  # #--------------------------------------------------------------------------
  # # * Else
  # #--------------------------------------------------------------------------
  # def command_411
  #   # If determinant results are false
  #   if @branch[@list[@index].indent] == false
  #     # Delete branch data
  #     @branch.delete(@list[@index].indent)
  #     # Continue
  #     return true
  #   end
  #   # If it doesn't meet the conditions: command skip
  #   return command_skip
  # end
 
  # #--------------------------------------------------------------------------
  # # * Exit Event Processing
  # #--------------------------------------------------------------------------
  # def command_115
  #   command_end
  #   return true
  # end

  def command_117
    # Get common event
    common_event = $data.commons[@parameters[0]]
    # If common event is valid
    if common_event != nil
      # Make child interpreter
      @child_interpreter = Interpreter.new(@depth + 1)
      @child_interpreter.setup(common_event.list, @event_id)
    end
    # Continue
    return true
  end

  # #--------------------------------------------------------------------------
  # # * Set Move Route
  # #--------------------------------------------------------------------------
  def command_209
    # Get character
    character = get_character(@parameters[0])
    # If no character exists
    return true if character == nil

    # Force move route - pushes on top of auto movers
    character.force_move_route(@parameters[1])
    return true
  end
  
  # #--------------------------------------------------------------------------
  # # * Wait for Move's Completion
  # #--------------------------------------------------------------------------
    def command_210
      @move_route_waiting = true
      return true
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
