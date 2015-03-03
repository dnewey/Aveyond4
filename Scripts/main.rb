#==============================================================================
# ** Game
#==============================================================================

APPFOLDER = "Aveyond 4"

# Get rid of this
# ----------------------------

  # Font used in windows 
  $fontface = "Arial" 
  $fontface2 = "Tahoma"
  
  # Font size used
  $fontsize = 22
  $fontsize2 = 18
  $fontsize3 = 20
  $fontsize4 = 15
  $fontsize5 = 26 
  
  # Initilize leader
  $leader = 0  

  def aveyond4

      # User Data folder
      Win32API.new('Utils', "AVSetEnv", ["V"], "I").call          
      $appdata = ENV['AV_APPDATA'] + "\\" + APPFOLDER
      Dir.mkdir($appdata) if !File.exists?($appdata) 

      $debug = DebugManager.new
      $DEBUG = true

      $audio = AudioManager.new

      # Install font here?
      $keyboard = KeyboardManager.new
      $mouse = MouseManager.new

      $data = DataManager.new
      $nanos = NanoManager.new

      $settings = SettingsManager.new
      $files = FileManager.new

      $game = GameManager.new

      # Call main method as long as $scene is effective      
      $game.update until $game.quit?
      
      # Set the windowed mode for next time
      $settings.conclude
      
  rescue ScriptError => e

    line = e.message.split(":")[1].to_i      
    log_err e.inspect
    log_err "------------------"
    
    e.backtrace.each{ |location|
      line_num = location.split(":")[1]
      script_name = location.split(":")[0].split("/").last
      method = location.split(":")[2]
      next if method == nil
      loc_err = "Line " + line_num + ", in "+script_name+ ", "+method.to_s
      loc_err = "Game Start" if script_name.include?("{0128")
      log_err("#{loc_err}")
    }     
    
  rescue StandardError => e
      
    line = e.message.split(":")[1].to_i      
    log_err e.inspect
    log_err "------------------"
    
    e.backtrace.each{ |location|
      line_num = location.split(":")[1]
      script_name = location.split(":")[0].split("/").last

      if location.include?("Section")
        section = location[/(?#Section)(\d)*(:)/]
        section_err = section[0, section.length - 1]
        script_name = $RGSS_SCRIPTS[section_err.to_i][1]
      end

      method = location.split(":")[2]
      next if method == nil
      loc_err = "Line " + line_num + ", in "+script_name+ ", "+method.to_s
      loc_err = "Game Start" if script_name.include?("{0128")
      log_err("#{loc_err}")
    } 
    
  end


