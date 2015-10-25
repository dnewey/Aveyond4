#============================================================================== 
# ** Modules.Mouse Input (7.0)   By Near Fantastica & SephirothSpawn
#==============================================================================

class MouseManager

  attr_reader :hwnd, :wheel
  
  #--------------------------------------------------------------------------
  # * API Declaration
  #--------------------------------------------------------------------------
  Cursor_Pos = Win32API.new('user32', 'GetCursorPos', 'p', 'i')
  $ShowCursor = Win32API.new('user32', 'ShowCursor', 'i', 'l')
  Scr2cli = Win32API.new('user32', 'ScreenToClient', %w(l p), 'i')
  Findwindow = Win32API.new('user32', 'FindWindowA',%w(p p),'l')

  def initialize
    @pos = [0,0]
    @hwnd = Findwindow.call(nil, "Aveyond")
    @sprite = Sprite.new()
    @sprite.z = 10000
    @sprite.ox = 32
    @sprite.oy = 32
    @mousing = true # Disabled when keys pressed
    @cursor = nil    
    change_cursor("Default")
  end

  def x() @pos[0] end
  def y() @pos[1] end
  
  def position() 
    $settings.mouse && @mousing ? @pos : [-777,-777]
  end
  def grid() 
    x = (@pos[0] + $map.display_x / 4) / 32
    y = (@pos[1] + $map.display_y / 4) / 32
    return [x.to_i,y.to_i]
  end
  def on_screen?() !(@pos[0] < 0 || @pos[1] < 0 || @pos[0] >= 640 || @pos[1] >= 480); end

  def unmouse
    @mousing = false
    hide_cursor
  end

  def remouse
    @mousing = true
    show_cursor
  end
        
  #--------------------------------------------------------------------------
  # * Update Mouse Position
  #--------------------------------------------------------------------------
  def update

    if !$settings.mouse
      @sprite.hide
      $ShowCursor.call(1)
    else
      @sprite.show
      $ShowCursor.call(0)
    end
    
    # Update Position
    pos = [0,0].pack('ll')
    Cursor_Pos.call(pos)
    Scr2cli.call(@hwnd, pos) 
    pos2 = pos.unpack('ll')

    # Update sprite pos if moved
    if pos2 != @pos
      @pos = pos2
      @sprite.x = @pos[0]
      @sprite.y = @pos[1]
      remouse
    end

    #on_screen?.to_i) # on_screen && mouse_mode
    
  end

  def change_cursor(c)
    return if c == @cursor
    @cursor = c
    @sprite.bitmap = $cache.cursor(c)
  end

  # For snapshotting
  def hide_cursor() @sprite.opacity = 0 end
  def show_cursor() @sprite.opacity = 255 end

end