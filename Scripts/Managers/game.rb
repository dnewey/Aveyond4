#==============================================================================
# ** Game Manager
#==============================================================================

class GameManager

	def initialize

    # Setup font
    Font.default_size = 22
    Font.default_name = "Consolas"

    if ACE_MODE
      Font.default_outline = false
      Font.default_shadow = true
    end

    Graphics.frame_rate = 60
    set_rez(720,480)

    @scenes = []

    # Make scene object (title screen)
    if DEBUG && $settings.debug_skip_title
      quick_start
    else
      $scene = Scene_Splash.new    
    end

  end

   def width
    return Graphics.width
  end

  def height
    return Graphics.height
  end

   def quick_start

    # Game State Objects
    $temp = Game_Temp.new
    $progress = Av::Progress.new
    $state = Av::State.new

    $player = Game_Player.new
    $party = Game_Party.new

    # Model    
    $map = Game_Map.new
    $map.setup($data.system.start_map_id)

    # Set up initial map position    
    $player.moveto($data.system.start_x, $data.system.start_y)
    $player.refresh
    $map.autoplay
    $map.update

    $hud = Game_Hud.new

    # Switch to map screen
    push_scene(Scene_Map.new)

  end

  def push_scene(scene)
    @scenes.unshift(scene)
  end

  def pop_scene
    @scenes.shift.terminate
  end

  def quit?
    return false
  end

  def update

    $keyboard.update
    $mouse.update
    $debug.update
    $hud.update
    Graphics.update
    Input.update
    @scenes[0].update

  end

  def flip_window
    
    # Check for keyboard events
    $showm = Win32API.new 'user32', 'keybd_event', %w(l l l l), ''
    
    if false
      $showm.call(18,0,0,0)
      $showm.call(13,0,0,0)
      $showm.call(13,0,2,0)
      $showm.call(18,0,2,0)
    end

  end

end