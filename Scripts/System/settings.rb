#==============================================================================
# ** Game_Settings
#==============================================================================

class SettingsManager

  attr_accessor :fullscreen
  attr_accessor :music_vol
  attr_accessor :sound_vol  
  attr_accessor :effects
  attr_accessor :mouse
  attr_accessor :tutorial
  attr_accessor :bottombar

  attr_accessor :debug_skip_title
  attr_accessor :debug_draw_fps
  attr_accessor :debug_draw_helpers
  attr_accessor :debug_power_test
  

  # In settings
  attr_accessor :last_file_index          # last save file no.

  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def initialize

    # Defaults
    @fullscreen = false
    @music_vol = 1.0
    @sound_vol = 1.0    
    @effects = false
    @mouse = false
    @tutorial = false
    @bottombar = true

    # Debug options
    @debug_skip_title = true
    @debug_draw_fps = true
    @debug_draw_helpers = false
    @debug_power_test = true

    # Create the settings file if needed
    if !FileTest.exist?($appdata+'\settings.txt')
      file = File.new($appdata+'\settings.txt', "w+")
      file.close
    end
        
    # Load from settings file real quick   
    File.open($appdata+'\settings.txt', "r").each do |line|
      dta = line.split(" ")
      val = dta[1]
      if val.to_i.to_s == val
        val = val.to_i
      elsif val.to_f.to_s == val
        val = val.to_f
      elsif val == "true"
        val = true
      elsif val == "false"
        val = false
      end
      self.instance_variable_set(dta[0],val)
    end
    
  end
  
  #--------------------------------------------------------------------------
  # * Get/Set Settings
  #--------------------------------------------------------------------------
  def save() 
    File.open($appdata+'\settings.txt', 'w') { |file|  
      # Write some stats      
      self.instance_variables.each{ |var|
        next if !DEBUG && var.to_s.include?("debug")
        file.puts(var.to_s+" "+self.instance_variable_get(var).to_s)
      }
    }
  end

  def conclude
    @window = Win32API.new('Utils', "IsFullScreen", ["V"], "I").call
    save
  end

end