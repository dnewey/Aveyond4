#============================================================================== 
# ** Modules.Mouse Input (7.0)   By Near Fantastica & SephirothSpawn
#==============================================================================

class MouseManager

  attr_reader :hwnd

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
    @sprite.oy = 4
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

  # For snapshotting
  def hide_cursor() @sprite.opacity = 0 end
  def show_cursor() @sprite.opacity = 255 end

end