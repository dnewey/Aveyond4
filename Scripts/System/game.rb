#==============================================================================
# ** Game Manager
#==============================================================================

class GameManager

  attr_reader :width, :height
  attr_accessor :menu_page

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
    #resize(853,480)
    resize(640,480)

    @scenes = []
    @queue = nil

    # Game State Objects
    $progress = Progress.new
    $state = State.new
    $party = Game_Party.new
    $menu = MenuState.new
    $battle = Game_Battle.new    

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
    if ACE_MODE
      Graphics.resize_screen(w,h)
    end
    #set_rez(w,h)
  end

  def push_scene(scene)
    $scene = scene
    @scenes.unshift(scene)
  end

  def pop_scene
    #Graphics.freeze
    @scenes.shift.terminate
    $scene = @scenes[0]
  end

  def quit?
    return false
  end

  def update

    $audio.update
    $keyboard.update
    $mouse.update
    $debug.update
    $tweens.update
    Graphics.update
    Input.update
    @scenes[0].update

    if @queue
      push_scene(@queue)
      @queue = nil
    end

  end

  def flip_window
    showm = Win32API.new('user32', 'keybd_event', %w(l l l l), '')
    showm.call(18,0,0,0)
    showm.call(13,0,0,0)
    showm.call(13,0,2,0)
    showm.call(18,0,2,0)
  end

end