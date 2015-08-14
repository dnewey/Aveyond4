#==============================================================================
# ** Save File Manager
#==============================================================================

SAVE_FILES = 99

# For the list
class SaveData
  attr_accessor :name
  attr_accessor :leader
end

class FileManager

  attr_accessor :headers

  def initialize

    @headers = []

    # 0 is auto save, you can't save over it

    # Load save headers
    i = 0
    while i <= SAVE_FILES
      if File.exist?(filename(i))
        @headers.push(load_header(i))
      else
        @headers.push(nil)
      end
      i += 1
    end

  end
  
  def any_save_files?
    !Dir.glob('Av4-*.save').empty?
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
  
  def filename(i)
    return $appdata + "\\Av4-#{i}.save"
  end

  def autosave
    save_game(0)
  end

  def save_game(i)
    File.open(filename(i), "wb") { |file|
      header = make_save_header  
      body = make_save_contents
      Marshal.dump(header, file)
      Marshal.dump(body, file)
      @last_savefile_index = i
    }

    # Save pic for save file
    w = 256
    h = 128
    x = (640-w)/2
    y = (480-h)/2
    rect = Rect.new(x,y,w,h)
    mini = Bitmap.new(w,h)
    mini.blt(0,0,$game.snapshot,rect)
    mini.export("#{$appdata}//Av4-#{i}.png")
    return true

  end
  
  # Could be in game? just the contents part here? Strange to give files such power
  def load_game(i)
    File.open(filename(i), "rb") do |file|
      Marshal.load(file)
      extract_save_contents(Marshal.load(file))
      $game.reload
      @index = i
    end
    return true
  end
  
  def load_header(i)
    File.open(filename(i), "rb") do |file|
      return Marshal.load(file)
    end
    return nil
  end
  
  def make_save_header
    header = {}
    header[:leader] = $party.leader
    header[:time] = "1h 20m"
    header[:members] = $party.active
    header[:gold] = $party.gold
    return header
  end
  
  def make_save_contents
    
    contents = {}

    contents[:battle]       = $battle
    contents[:menu]         = $menu
    contents[:party]        = $party
    contents[:progress]     = $progress
    contents[:state]        = $state

    contents[:map]          = $map
    contents[:player]       = $player

    return contents

  end
  
  def extract_save_contents(contents)

    $battle =    contents[:battle]
    $menu =      contents[:menu]    
    $party =     contents[:party]   
    $progress =  contents[:progress]
    $state =     contents[:state]   

    $map =       contents[:map]     
    $player =    contents[:player]  

  end
  
end
