#==============================================================================
# ** Game_Settings
#==============================================================================

class SettingsManager

  attr_accessor :music
  attr_accessor :sound
  attr_accessor :window
  attr_accessor :effects
  attr_accessor :mouse

  attr_accessor :debug_skip_title
  attr_accessor :debug_fps
  

  # In settings
  attr_accessor :last_file_index          # last save file no.

  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def initialize

    # Defaults
    @music = false
    @sound = true
    @window = false
    @effects = false
    @mouse = false

    # Debug options - keys 1-9
    @debug_skip_title = true
    @debug_show_fps = 40
        
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
  end

end