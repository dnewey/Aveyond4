#==============================================================================
# ** Game Manager
#==============================================================================

class GameManager

	def initialize

      # Make scene object (title screen)
      if DEBUG && $settings.debug_skip_title
        quick_start
      else
        $scene = Scene_Splash.new    
      end

     end

     def quick_start

      # Game State Objects
      $temp = Game_Temp.new
      $progress = Av::Progress.new
      $state = Av::State.new
      $party = Game_Party.new

      # Model

      $player        = Game_Player.new
      $map           = Game_Map.new
      $map.setup($data.system.start_map_id)

      # Set up initial map position
      
      $player.moveto($data.system.start_x, $data.system.start_y)
      $player.refresh
      $map.autoplay
      $map.update

      # Switch to map screen
      $scene = Scene_Map.new

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
          $scene.update

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