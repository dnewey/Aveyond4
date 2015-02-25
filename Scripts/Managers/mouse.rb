#============================================================================== 
# ** Modules.Mouse Input (7.0)              By Near Fantastica & SephirothSpawn
#==============================================================================

class MouseManager
  #--------------------------------------------------------------------------
  # * Mouse to Input Triggers
  #
  #   key => Input::KeyCONSTANT (key: 0 - Left, 1 - Middle, 2 - Right)
  #--------------------------------------------------------------------------
  Mouse_to_Input_Triggers = {0 => Input::C, 1 => Input::B, 2 => Input::A}

  #--------------------------------------------------------------------------
  # * API Declaration
  #--------------------------------------------------------------------------
  GAKS          = Win32API.new('user32',    'GetAsyncKeyState', 'i',     'i')
  GSM           = Win32API.new('user32',    'GetSystemMetrics', 'i',     'i')
  Cursor_Pos    = Win32API.new('user32',    'GetCursorPos',     'p',     'i')
  $ShowCursor   = Win32API.new('user32',    'ShowCursor',       'i',     'l')
  Scr2cli       = Win32API.new('user32',    'ScreenToClient',   %w(l p), 'i')
  Client_rect   = Win32API.new('user32',    'GetClientRect',    %w(l p), 'i')
  Findwindow    = Win32API.new('user32',    'FindWindowA',      %w(p p), 'l')
                             
  # if graphical effects turned on, show fancy cursor
  $ShowCursor.call($game_mouse ? 0 : 1)
  
  def initialize
    @triggers     =   [[0, 1], [0, 2], [0, 4]] 
    @old_pos      =   0
    @pos_i        =   0
  end
    
  #--------------------------------------------------------------------------
  # * Mouse Grid Position
  #--------------------------------------------------------------------------
  def grid    
    # Return Nil if Position is Nil
    return nil if @pos.nil?
    
    # Get X & Y Locations  
    x = (@pos[0] + $game_map.display_x / 4) / 32
    y = (@pos[1] + $game_map.display_y / 4) / 32
    
    # Menu Stuff
    #$screen_x = @pos[0] / 32
    #$screen_y = @pos[1] / 32

    # Return X & Y
    return [x, y]
    
  end
  #--------------------------------------------------------------------------
  # * Mouse Position
  #--------------------------------------------------------------------------
  def position
    return @pos == nil ? [0, 0] : @pos
  end
  #--------------------------------------------------------------------------
  # * Mouse Global Position
  #--------------------------------------------------------------------------
  def global_pos
    # Packs 0 Position
    pos = [0, 0].pack('ll')
    # Returns Unpacked Cursor Position Call
    return Cursor_Pos.call(pos) == 0 ? nil : pos.unpack('ll')
  end
  
  #--------------------------------------------------------------------------
  # * Screen to Client
  #--------------------------------------------------------------------------
  def screen_to_client(x=0, y=0)
    pos = [x, y].pack('ll')
    return Scr2cli.call(self.hwnd, pos) == 0 ? nil : pos.unpack('ll')
  end  
    
  #--------------------------------------------------------------------------
  # * Mouse Position
  #-------------------------------------------------------------------------- 
  def pos

    global_pos = [0, 0].pack('ll')    
    gx, gy = Cursor_Pos.call(global_pos) == 0 ? nil : global_pos.unpack('ll')

    local_pos = [gx, gy].pack('ll')
    x, y = Scr2cli.call(self.hwnd, local_pos) == 0 ? nil : local_pos.unpack('ll')
    
    # Begins Test
    begin
      # Return X & Y or Nil Depending on Mouse Position
      if (x >= 0 && y >= 0 && x <= 640 && y <= 480)
        return x, y
      else
        return -20, -20
      end
    rescue
      return 0, 0 #nil
    end
    
  end  
    
  #--------------------------------------------------------------------------
  # * Update Mouse Position
  #--------------------------------------------------------------------------
  def update
    
    # Update Position
    old_pos = @pos
    @pos = self.pos
    
    # agf = hide mouse
    if $mouse_sprite.visible == false  
      if old_pos != @pos
        $mouse_sprite.visible = true
      end
    end
    
    if old_pos != [-20, -20] && @pos == [-20, -20]
      $ShowCursor.call(1)
    else 
      if old_pos == [-20, -20] && @pos != [-20, -20]
        $ShowCursor.call($game_mouse ? 0 : 1)
      end
    end

    # Update Triggers
    for i in @triggers
      # Gets Async State
      n = GAKS.call(i[1])
      # If 0 or 1
      if [0, 1].include?(n)
        i[0] = (i[0] > 0 ? i[0] * -1 : 0)
      else
        i[0] = (i[0] > 0 ? i[0] + 1 : 1)
      end
    end


    #$mouse_sprite.update if $mouse_sprite.visible # from Mouse 2 line 187+
    

    
  end
  #--------------------------------------------------------------------------
  # * Trigger?
  #     id : 0:Left, 1:Right, 2:Center
  #--------------------------------------------------------------------------
  def trigger?(id = 0)
    
    #only user trigger if in range of screen
    pos = self.pos
    if pos != [-20,-20]
    
    case id
    when 0  # Left
      return @triggers[id][0] == 1
    when 1  # Right (only when menu enabled or in a battle)
      if (@triggers[1][0] == 1) && ($game_system.menu_disabled == false || 
        $scene.is_a?(Scene_Battle))
        return @triggers[id][0] == 1      
      end
    when 2  # Center
      return @triggers[id][0] == 1
    end    
    
    end
    
  end
  #--------------------------------------------------------------------------
  # * Repeat?
  #     id : 0:Left, 1:Right, 2:Center
  #--------------------------------------------------------------------------
  def repeat?(id = 0)
    if @triggers[id][0] <= 0
      return false
    else
      return @triggers[id][0] % 5 == 1 && @triggers[id][0] % 5 != 2
    end
  end
  #--------------------------------------------------------------------------
  # * Screen to Client
  #--------------------------------------------------------------------------
  def screen_to_client(x=0, y=0)
    # Return nil if X & Y empty
    #return nil unless x and y
    # Pack X & Y
    pos = [x, y].pack('ll')
    # Return Unpacked Position or Nil
    return Scr2cli.call(self.hwnd, pos) == 0 ? nil : pos.unpack('ll')
  end
  #--------------------------------------------------------------------------
  # * Hwnd
  #--------------------------------------------------------------------------
  def hwnd
    if @hwnd.nil?
      # Finds Game Name
      #game_name = "\0" * 256
      #Readini.call('Game', 'Title', '', game_name, 255, ".\\Options.ini")
      #game_name.delete!("\0")
      # Finds Window
      @hwnd = Findwindow.call('RGSS Player', "Aveyond")
    end
    return @hwnd
  end
  #--------------------------------------------------------------------------
  # * Client Size
  #--------------------------------------------------------------------------
  def client_size
    # Packs Empty Rect
    rect = [0, 0, 0, 0].pack('l4')
    # Gets Game Window Rect
    Client_rect.call(self.hwnd, rect)
    # Unpacks Right & Bottom
    right, bottom = rect.unpack('l4')[2..3]
    # Returns Right & Bottom
    return right, bottom
  end
end



#==============================================================================
# ** Input
#==============================================================================

# Move to an input manager, will access mouse and keyboard
class Input2

  #--------------------------------------------------------------------------
  # * Trigger? Test
  #--------------------------------------------------------------------------
  def trigger?(constant)
    # Return true if original test is true
    return true if seph_mouse_input_trigger?(constant)
    # If Mouse Position isn't Nil
    unless Mouse.pos.nil?
      # If Mouse Trigger to Input Trigger Has Constant
      if Mouse::Mouse_to_Input_Triggers.has_value?(constant)
        # Return True if Mouse Triggered
        mouse_trigger = Mouse::Mouse_to_Input_Triggers.index(constant)
        return true if Mouse.trigger?(mouse_trigger)      
      end
    end
    # Return False
    return false
  end
  #--------------------------------------------------------------------------
  # * Repeat? Test
  #--------------------------------------------------------------------------
  def repeat?(constant)
    # Return true if original test is true
    return true if seph_mouse_input_repeat?(constant)
    # If Mouse Position isn't Nil
    unless Mouse.pos.nil?
      # If Mouse Trigger to Input Trigger Has Constant
      if Mouse::Mouse_to_Input_Triggers.has_value?(constant)
        # Return True if Mouse Triggered
        mouse_trigger = Mouse::Mouse_to_Input_Triggers.index(constant)     
        return true if Mouse.repeat?(mouse_trigger)
      end
    end
    # Return False
    return false
  end
end

