#==============================================================================
# ** Game
#==============================================================================

APPFOLDER = "Aveyond 4"

def aveyond4

    # User Data folder
    Win32API.new('System/Utils', "AVSetEnv", ["V"], "I").call          
    $appdata = ENV['AV_APPDATA'] + "\\" + APPFOLDER
    Dir.mkdir($appdata) if !File.exists?($appdata) 

    # Who will debug the debug?
    begin
      $debug = DebugManager.new
    rescue StandardError => e
      p e.inspect
    end

    $cache = CacheManager.new
    $audio = AudioManager.new
    $keyboard = KeyboardManager.new
    $mouse = MouseManager.new
    $input = InputManager.new
    $data = DataManager.new
    $tweens = TweenManager.new
    $settings = SettingsManager.new
    $files = FileManager.new
    $battle = Game_Battle.new
    $fonts = FontManager.new
    $game = GameManager.new  
    # $steam = SteamManager.new

    $scratch = Bitmap.new(400,50)

    # Call main method as long as $scene is effective      
    $game.update until $game.quit?
    
    # Set the windowed mode for next time
    $settings.conclude
    $audio.dispose

rescue SystemExit

    $settings.conclude
    $audio.dispose

rescue StandardError => e

  $audio.dispose
    
  line = e.message.split(":")[1].to_i      
  log_err e.inspect
  log_err "------------------"
  
  e.backtrace.each{ |location|
    line_num = location.split(":")[1]
    script_name = location.split(":")[0]
    if script_name.include?("Scripts/")
      script_name['Scripts/'] = ''
    end

    if location.include?("Section")
      section = location[/(?#Section)(\d)*(:)/]
      section_err = section[0, section.length - 1]
      script_name = $RGSS_SCRIPTS[section_err.to_i][1]
    end

    method = location.split(":")[2]
    next if method == nil
    loc_err = "Line " + line_num + ", "+method.to_s+" in "+script_name    
    loc_err = "Game Start" if script_name.include?("{0128")
    log_err("#{loc_err}")
  } 
  
end