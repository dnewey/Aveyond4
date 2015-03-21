#==============================================================================
# ** Game Manager
#==============================================================================

class GameManager

  attr_reader :width, :height

	def initialize

    $game = self

    # Setup font
    Font.default_size = 22
    Font.default_name = "Consolas"

    if ACE_MODE
      Font.default_outline = false
      Font.default_shadow = true
    end

    Graphics.frame_rate = 60
    resize(850,480)

    @scenes = []

    # Game State Objects
    $progress = Av::Progress.new
    $state = Av::State.new
    $party = Game_Party.new
    $player = Game_Player.new

    # Model    
    $map = Game_Map.new

    $map.setup($data.system.start_map_id)
    $player.moveto($data.system.start_x, $data.system.start_y)

    # Make scene object (title screen)
    if DEBUG && $settings.debug_skip_title
      push_scene(Scene_Map.new)    
    else
      push_scene(Scene_Splash.new)
    end

  end

  def resize(w,h)
    @width = w
    @height = h
    set_rez(w,h)
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
    Graphics.update
    Input.update
    @scenes[0].update

  end

  def flip_window
    showm = Win32API.new('user32', 'keybd_event', %w(l l l l), '')
    showm.call(18,0,0,0)
    showm.call(13,0,0,0)
    showm.call(13,0,2,0)
    showm.call(18,0,2,0)
  end

end