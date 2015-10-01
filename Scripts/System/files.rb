#==============================================================================
# ** Save File Manager
#==============================================================================

SAVE_FILES = 99

def build_time_string(frames)

    h = frames/60/60/60
    hf = h * 60*60*60
    m = (frames-hf)/60/60
    mf = m*60*60
    s = (frames-hf-mf)/60

    if h > 0
      time = "#{h}h #{m}m"
    elsif m > 0
      time = "#{m}m #{s}s"
    else
      time = "#{s}s"
    end

    return time

end

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

  def save_exists?(i)
    return @headers[i] != nil
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

    # Save sfx
    if i != 0
      sys('save')
    end

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
    x = $menu.player_x - 128#(640-w)/2
    y = $menu.player_y - 96#(480-h)/2
    x = 0 if x < 0
    y = 0 if y < 0
    rect = Rect.new(x,y,w,h)
    mini = Bitmap.new(w,h)
    mini.blt(0,0,$game.snapshot,rect)
    mini.export("#{$appdata}//Av4-#{i}.png")



    @headers[i] = load_header(i)

    return true

  end
  
  # Could be in game? just the contents part here? Strange to give files such power
  def load_game(i)
    sys('load')
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
    header[:time] = Graphics.frame_count
    header[:members] = $party.active
    header[:gold] = $party.gold
    header[:chars] = $party.all
    header[:levels] = [1,2,3,4,5,6,7]
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

    contents[:frame_count]  = Graphics.frame_count

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

    Graphics.frame_count = contents[:frame_count]

  end
  
end
