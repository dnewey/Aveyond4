#============================================================================== 
# ** Modules.Mouse Input (7.0)              By Near Fantastica & SephirothSpawn
#==============================================================================

class MouseManager

  #--------------------------------------------------------------------------
  # * API Declaration
  #--------------------------------------------------------------------------
  Cursor_Pos = Win32API.new('user32', 'GetCursorPos', 'p', 'i')
  ShowCursor = Win32API.new('user32', 'ShowCursor', 'i', 'l')
  Scr2cli = Win32API.new('user32', 'ScreenToClient', %w(l p), 'i')
  Findwindow = Win32API.new('user32', 'FindWindowA',%w(p p),'l')

  def initialize
    @pos = [0,0]
    @hwnd = Findwindow.call(nil, "Aveyond")
    @sprite = Sprite.new()
    @sprite.z = 6000
    @sprite.ox = 4
    change_cursor("Default")
  end

  def x() @pos[0] end
  def y() @pos[1] end
  
  def position() @pos; end
  def grid() 
    x = (@pos[0] + $map.display_x / 4) / 32
    y = (@pos[1] + 14 + $map.display_y / 4) / 32
    return [x.to_i,y.to_i]
  end
  def on_screen?() !(@pos[0] < 0 || @pos[1] < 0 || @pos[0] >= 640 || @pos[1] >= 480); end
        
  #--------------------------------------------------------------------------
  # * Update Mouse Position
  #--------------------------------------------------------------------------
  def update
    
    # Update Position
    pos = [0,0].pack('ll')
    Cursor_Pos.call(pos)
    Scr2cli.call(@hwnd, pos) 
    @pos = pos.unpack('ll')

    # Update sprite pos
    @sprite.x = @pos[0]
    @sprite.y = @pos[1]

    ShowCursor.call(0)#on_screen?.to_i) # on_screen && mouse_mode
    
  end

  def change_cursor(c)
    @sprite.bitmap = $cache.cursor(c)
  end

end

#==============================================================================
# ** Sprite_Mouse
#==============================================================================

class Sprite_Mouse < Sprite

  #--------------------------------------------------------------------------
  # ** Frame Update : Update Event Cursors
  #--------------------------------------------------------------------------
  def update_event_cursors
    
    # If Nil Grid Position
    if Mouse.grid.nil? 
      # Set Default Cursor
      set_bitmap(MouseCursor::Default_Cursor)
      return
    end
    
    # Gets Mouse Position
    x, y = *Mouse.grid
    
    # Gets Mouse Position
    mx, my = *Mouse.position    
    
    # Gets Mouse Event
    event = $game_map.lowest_event_at(x, y)
    
    # If Non-Nil Event or not over map HUD
    unless event.nil? || my >= 448
      # If Not Erased or Nil List
      if event.list != nil && event.erased == false && event.list[0].code == 108
        # Get the cursor to show
        icon = nil
        event.list[0].parameters.to_s.downcase.gsub!(/icon (.*)/) do
          icon = $1.to_s
        end
        
        if !((icon == "talk") || 
           (icon == "touch") || 
           (icon == "fight") || 
           (icon == "examine") || 
           (icon == "point") ||
           (icon == "exit"))
           icon = MouseCursor::Default_Cursor
        end        
        xNPCname = nil 
        if event.list.size > 1 && event.list[1].code == 108
          text = event.list[1].parameters.to_s
          text.gsub!(/[Nn][Aa][Mm][Ee] (.*)/) do
            xNPCname = $1.to_s
          end
        end
        set_bitmap(icon, xNPCname)  
        #self.x = self.x - self.bitmap.width + 24 if self.x + self.bitmap.width > 640
        if event.name != "BOTTOM" # and ["Arrow2", "Arrow4"].include?(icon)
          self.y -= 8
        end
        return
      end
      return
    end
    
    # Set Default Cursor
    set_bitmap(MouseCursor::Default_Cursor)
    
  end
end
