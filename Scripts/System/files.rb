#==============================================================================
# ** Save File Manager
#==============================================================================

# 99 save files
class FileManager
  
  #--------------------------------------------------------------------------
  # * Determine Existence of Save File
  #--------------------------------------------------------------------------
  def any_save_files?
    !Dir.glob('Av4-*.save').empty?
  end
  
  #--------------------------------------------------------------------------
  # * Determine Existence of Save File
  #--------------------------------------------------------------------------
  def file_exists?(which)
    file = 'Av4-'+which+'.save'
    File.exist?($appPath + file)
  end
  
  #--------------------------------------------------------------------------
  # * Create Filename
  #--------------------------------------------------------------------------
  def make_filename()
    file = "Av4-"+$settings.value('active')+".dean"
    return $appdata + file
  end

  #--------------------------------------------------------------------------
  # * Execute Save (No Exception Processing)
  #--------------------------------------------------------------------------
  def save_game
    File.open(make_filename(), "wb") { |file|
      header = make_save_header  
      body = make_save_contents
      Marshal.dump(header, file)
      Marshal.dump(body, file)
      @last_savefile_index = index
    }
    return true
  end
  
  #--------------------------------------------------------------------------
  # * Execute Load (No Exception Processing)
  #--------------------------------------------------------------------------
  def load_game
    File.open(make_filename(), "rb") do |file|
      Marshal.load(file)
      extract_save_contents(Marshal.load(file))
      reload_map_if_updated
      @index = index
    end
    return true
  end
  
  #--------------------------------------------------------------------------
  # * Load Save Header (No Exception Processing)
  #--------------------------------------------------------------------------
  def load_header
    File.open(make_filename(), "rb") do |file|
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
    #header[:characters] = $game_party.characters_for_savefile
    #header[:playtime_s] = $game_system.playtime_s
    header
  end
  
  #--------------------------------------------------------------------------
  # * Create Save Contents
  #--------------------------------------------------------------------------
  def make_save_contents
    contents = {}
    contents[:state]       = $state
    contents[:progress]         = $progress
    contents[:party]      = $party
    contents[:battle]     = $battle

    contents[:map]        = $map
    contents[:player]        = $player
    contents
  end
  
  #--------------------------------------------------------------------------
  # * Extract Save Contents
  #--------------------------------------------------------------------------
  def extract_save_contents(contents)
    $journal       = contents[:journal]
    $flags         = contents[:flags]
    $switches      = contents[:switches]
    $variables     = contents[:variables]
    $states        = contents[:states]
    $harvey        = contents[:harvey]
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
