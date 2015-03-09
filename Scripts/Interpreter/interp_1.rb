#==============================================================================
# ** Interpreter (part 1)
#------------------------------------------------------------------------------
#  This interpreter runs event commands. This class is used within the
#  Game_System class and the Game_Event class.
#==============================================================================

class Interpreter
  
  #--------------------------------------------------------------------------
  # * Object Initialization
  #     depth : nest depth
  #     main  : main flag
  #--------------------------------------------------------------------------
  def initialize(depth = 0, main = false)
    @depth = depth
    @main = main
    
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
    @map_id = $map.map_id
    
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
    if $temp.common_event_id > 0
      
      # Set up event
      setup($data.commons[$temp.common_event_id].list, 0)
      
      # Release reservation
      $temp.common_event_id = 0
      
      return
      
    end
    
    # Loop (map events)
    for event in $map.events.values
      
      # If running event is found
      if event.starting
        
        # If not auto run
        if event.trigger < 3
          
          # Clear starting flag
          event.clear_starting
          
          # Lock
          event.lock
          
        end
        
        # Set up event
        setup(event.list, event.id)
        
        return
        
      end
      
    end
    
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
      if $map.map_id != @map_id
        # Change event ID to 0
        @event_id = 0
      end
      
      # If a child interpreter exists
      if @child_interpreter != nil
        
        # Update child interpreter
        @child_interpreter.update
        
        # If child interpreter is finished running
        unless @child_interpreter.running?
          # Delete child interpreter
          @child_interpreter = nil          
        end
        
        # If child interpreter still exists
        if @child_interpreter != nil
          return
        end
        
      end
      
      # If waiting for message to end
      if @message_waiting
        return
      end

      # Misc hud busy
      if $hud && $hud.busy?
        return
      end
      
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
  # * Setup Choices
  #--------------------------------------------------------------------------
  def setup_choices(parameters)
    
    # Set choice item count to choice_max
    $game_temp.choice_max = parameters[0].size
    
    # Set choice to message_text
    for text in parameters[0]
      $game_temp.message_text += text + "\n"
    end
    
    # Set cancel processing
    $game_temp.choice_cancel_type = parameters[1]
    
    # Set callback
    current_indent = @list[@index].indent
    $game_temp.choice_proc = Proc.new { |n| @branch[current_indent] = n }
    
  end

  #--------------------------------------------------------------------------
  # * Actor Iterator (consider all party members)
  #     parameter : if 1 or more, ID; if 0, all
  #--------------------------------------------------------------------------
  def iterate_actor(parameter)
    
    # If entire party
    if parameter == 0
      
      # Loop for entire party
      #for actor in $game_party.actors
        
        # Evaluate block
        #yield actor
                
      #end
      
      # Shaz - do this to all actors in the party, including reserve
      for i in 0..10
        actor = $game_actors[i]
        yield actor if actor != nil && $player.is_present(actor.id)
      end
      
    # If single actor
    else
      
      # Get actor
      actor = $game_actors[parameter]
      
      # Evaluate block
      yield actor if actor != nil
      
    end
  end
  
  #--------------------------------------------------------------------------
  # * Enemy Iterator (consider all troop members)
  #     parameter : If 0 or above, index; if -1, all
  #--------------------------------------------------------------------------
  def iterate_enemy(parameter)
    
    # If entire troop
    if parameter == -1
      
      # Loop for entire troop
      for enemy in $game_troop.enemies
        
        # Evaluate block
        yield enemy
        
      end
      
    # If single enemy
    else
      
      # Get enemy
      enemy = $game_troop.enemies[parameter]
      
      # Evaluate block
      yield enemy if enemy != nil
      
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Battler Iterator (consider entire troop and entire party)
  #     parameter1 : If 0, enemy; if 1, actor
  #     parameter2 : If 0 or above, index; if -1, all
  #--------------------------------------------------------------------------
  def iterate_battler(parameter1, parameter2)
    
    # If enemy
    if parameter1 == 0
      
      # Call enemy iterator
      iterate_enemy(parameter2) do |enemy|
        yield enemy
      end
      
    # If actor
    else
      
      # If entire party
      if parameter2 == -1
        
        # Loop for entire party
        #for actor in $game_party.actors
          
          # Evaluate block
          #yield actor
          
        #end

        # Shaz - do this to all actors in the party, including reserve
        for i in 0..10
          actor = $game_actors[i]
          yield actor if actor != nil && $player.is_present(actor.id)
        end
        
      # If single actor (N exposed)
      else
        
        # Get actor
        actor = $game_party.actors[parameter2]
        
        # Evaluate block
        yield actor if actor != nil
        
      end
      
    end
  end
end
