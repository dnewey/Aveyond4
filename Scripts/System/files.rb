#==============================================================================
# ** Save File Manager
#==============================================================================

SAVE_FILES = 99

class SaveData
  attr_accessor :name
end

class FileManager

  attr_accessor :headers

  def initialize

    @headers = []

    # Load save headers
    i = 0
    while i <= SAVE_FILES
      if file_exists?(i)
        @headers.push(load_header(i))
      else
        @headers.push(nil)
      end
      i += 1
    end

  end
  
  #--------------------------------------------------------------------------
  # * Determine Existence of Save File
  #--------------------------------------------------------------------------
  def any_save_files?
    !Dir.glob('Av4-*.save').empty?
  end
  
  #--------------------------------------------------------------------------
  # * Determine Existence of Save File
  #--------------------------------------------------------------------------
  def file_exists?(i)
    file = "\\Av4-#{i}.save"
    File.exist?($appdata + file)
  end

  def save_file_list
    i = 0
    list = []
    while i <= SAVE_FILES
      list.push(i)
      i+=1
    end
    return list
  end
  
  #--------------------------------------------------------------------------
  # * Create Filename
  #--------------------------------------------------------------------------
  def make_filename(i)
    file = "\\Av4-#{i}.save"
    return $appdata + file
  end

  #--------------------------------------------------------------------------
  # * Execute Save (No Exception Processing)
  #--------------------------------------------------------------------------
  def save_game(i)
    File.open(make_filename(i), "wb") { |file|
      header = make_save_header  
      body = make_save_contents
      Marshal.dump(header, file)
      Marshal.dump(body, file)
      @last_savefile_index = i
    }

    # Save pic for save file
    w = 256
    h = 192
    x = (640-w)/2
    y = (480-h)/2
    rect = Rect.new(x,y,w,h)
    mini = Bitmap.new(w,h)
    mini.blt(0,0,$game.snapshot,rect)
    mini.export("#{$appdata}//Av4-#{i}.png")
    return true

  end
  
  #--------------------------------------------------------------------------
  # * Execute Load (No Exception Processing)
  #--------------------------------------------------------------------------
  def load_game(i)
    File.open(make_filename(i), "rb") do |file|
      Marshal.load(file)
      extract_save_contents(Marshal.load(file))
      $game.reload
      @index = i
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # * Load Save Header (No Exception Processing)
  #--------------------------------------------------------------------------
  def load_header(i)
    File.open(make_filename(i), "rb") do |file|
      return Marshal.load(file)
    end
    return nil
  end
  
  #--------------------------------------------------------------------------
  # * Delete Save File
  #--------------------------------------------------------------------------
  def delete_save_file()
    File.delete(make_filename()) rescue nil
  end
  
  #--------------------------------------------------------------------------
  # * Create Save Header
  #--------------------------------------------------------------------------
  def make_save_header
    header = {}
    header[:progress] = 140
    header[:name] = "Save Name"
    # Location, party, playtime, quest?, gold
    #header[:characters] = $game_party.characters_for_savefile
    #header[:playtime_s] = $game_system.playtime_s
    header
  end
  
  #--------------------------------------------------------------------------
  # * Create Save Contents
  #--------------------------------------------------------------------------
  def make_save_contents
    
    contents = {}

    contents[:battle]       = $battle
    contents[:menu]         = $menu
    contents[:party]        = $party
    contents[:progress]     = $progress
    contents[:state]        = $state

    contents[:map]          = $map
    contents[:player]       = $player

    contents

  end
  
  #--------------------------------------------------------------------------
  # * Extract Save Contents
  #--------------------------------------------------------------------------
  def extract_save_contents(contents)

    $battle =    contents[:battle]
    $menu =      contents[:menu]    
    $party =     contents[:party]   
    $progress =  contents[:progress]
    $state =     contents[:state]   

    $map =       contents[:map]     
    $player =    contents[:player]  

  end
  
  #--------------------------------------------------------------------------
  # * Get Update Date of Save File
  #--------------------------------------------------------------------------
  def savefile_time_stamp()
    File.mtime(make_filename()) rescue Time.at(0)
  end
  
  #--------------------------------------------------------------------------
  # * Get File Index with Latest Update Date
  #--------------------------------------------------------------------------
  def latest_savefile_index
    savefile_max.times.max_by {|i| savefile_time_stamp(i) }
  end
  
end
