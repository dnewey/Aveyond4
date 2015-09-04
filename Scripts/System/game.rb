#==============================================================================
# ** Game Manager
#==============================================================================

class GameManager

  attr_reader :width, :height
  attr_accessor :snapshot

  attr_accessor :queue

	def initialize

    $game = self

    Graphics.frame_rate = 60
    resize(640,480)

    @scenes = []
    @queue = nil

    @need_reload = false
    @flip_delay = 0

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

  def reload
    @need_reload = true
  end

  def do_reload
    @need_reload = false
    $scene = nil
    @scenes.each{ |s| s.terminate }
    @scenes = []
    push_scene(Scene_Map.new($map,$player))
    $map.resetup
  end

  def resize(w,h)
    @width = w
    @height = h
    #set_rez(w,h)
  end

  def push_scene(scene)
    $scene = scene
    @scenes.unshift(scene)
  end

  def pop_scene
    #Graphics.freeze
    $tweens.clear_all
    @scenes.shift.terminate
    $scene = @scenes[0]
  end

  def sub_scene
    return @scenes[0]
  end

  def quit?
    return false
  end

  def update

    @flip_delay -= 1

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

    # Reload here
    do_reload if @need_reload

  end

  def flip_window
    return if @flip_delay > 0
    @flip_delay = 30
    $settings.fullscreen = !$settings.fullscreen
    showm = Win32API.new('user32', 'keybd_event', %w(l l l l), '')
    showm.call(18,0,0,0)
    showm.call(13,0,0,0)
    showm.call(13,0,2,0)
    showm.call(18,0,2,0)
  end

end