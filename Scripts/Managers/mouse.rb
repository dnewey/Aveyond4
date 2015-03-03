#============================================================================== 
# ** Modules.Mouse Input (7.0)              By Near Fantastica & SephirothSpawn
#==============================================================================

class MouseManager

  #--------------------------------------------------------------------------
  # * API Declaration
  #--------------------------------------------------------------------------
  Cursor_Pos    = Win32API.new('user32',    'GetCursorPos',     'p',     'i')
  ShowCursor    = Win32API.new('user32',    'ShowCursor',       'i',     'l')
  Scr2cli       = Win32API.new('user32',    'ScreenToClient',   %w(l p), 'i')
  Findwindow    = Win32API.new('user32',    'FindWindowA',      %w(p p), 'l')

  def initialize
    @pos = [0,0]
    @hwnd = Findwindow.call(nil, "Aveyond") if @hwnd.nil?
  end
  
  def position() @pos; end
  def grid() @pos.map{ |i| i = (i + $map.display_x / 4) / 32 } end
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

    #ShowCursor.call(on_screen?.to_i) # on_screen && mouse_mode
    
  end

end