#==============================================================================
# ** Data Manager
#==============================================================================

class DataManager

  # JsonData
	attr_reader :items
  attr_reader :weapons
  attr_reader :armors

  attr_reader :actors
  attr_reader :enemies
  attr_reader :skills
  attr_reader :states

  attr_reader :progress
  attr_reader :quests
  attr_reader :zones

  # Clone events
  attr_reader :clones

  # RxData
  attr_reader :commons
  attr_reader :tilesets
  attr_reader :system
  attr_reader :mapinfos

	def initialize

    # Create an icon list
    create_icon_list if DEBUG

    # Load up json data
    
    @items = load_json("items",ItemData)
    @weapons = load_json("weapons",WeaponData)
    @armors = load_json("armors",ArmorData)

    @actors = load_json("actors",ActorData)
    @enemies = load_json("enemies",EnemyData)
    @skills = load_json("skills",SkillData)
    @states = load_json("states",StateData)
    
    @progress = load_json("progress",ProgressData)
    @quests = load_json("quests",QuestData)
    @zones = load_json("zones",ZoneData)

    @clones = load_clones

		# Convert to json
    @commons = load_data("Data/CommonEvents.rxdata")
    @tilesets = load_data("Data/Tilesets.rxdata")
    @system = load_data("Data/System.rxdata")
    @mapinfos = load_data("Data/MapInfos.rxdata")

	end

  def create_icon_list

    list = Dir.glob('Graphics/Icons/**/*').select{ |e| File.file? e }
    list.each_index { |i|
      list[i] = list[i].gsub("Graphics/Icons/","")
      list[i] = list[i].gsub(".png","")
    }

    File.open('Editor/icons.json', 'w') { |file|
      file.puts("[")
      list.each{ |l| file.puts("\""+l+"\",") }
      file.puts("\"\"")
      file.puts("]")
    }

  end

  def load_clones

    clones = {}
    map = load_data("Data/Map001.rxdata")

    map.events.each{ |k,ev|
      clones[ev.name.split("#")[0].rstrip!] = ev.pages
    }

    return clones

  end

  def load_json(file,type)

    # Load from rxdata if not debug
    if !DEBUG
      return load_data("Data/Json/#{file}.rxdata")
    end

    # Clear out garbage files
    process_data_files(file)

    # If there is no data file, make blank
    if !FileTest.exist?("Editor/json/#{file}.json")
      log_sys "Missing data file: #{file}.json"
      return {}
    end

    # Load up the data
    json_data = File.read("Editor/json/#{file}.json")
    json_data = json_data.gsub(/[:]/, '=>')
    json_data = eval(json_data)

  
    # Create datas
    data = {}
    json_data.each{ |v|
      item = type.new
      v.each{ |var,val|
        # Attempt to convert val to int or float

        item.instance_variable_set("@#{var}", val)
      }
      data[item.id] = item
      
    }

    # Export to rxdata for later
    save_data(data,"Data/Json/#{file}.rxdata")

    return data

  end

  def process_data_files(file)

    # RIGHT, START AT 50 DOWN TO NOTHING! WHEN FOUND REPLACE THE BASE
    idx = 50
    while idx > 0
      if FileTest.exist?("Editor/json/#{file}(#{idx}).json") 
        # Found it! Delete the base and rename this one
        File.delete("Editor/json/#{file}.json")
        File.rename("Editor/json/#{file}(#{idx}).json","Editor/json/#{file}.json")
        break
      end
      idx -= 1
    end

    # Delete any with brackets
    idx = 50
    while idx > 0
      if FileTest.exist?("Editor/json/#{file}(#{idx}).json") 
        File.delete("Editor/json/#{file}(#{idx}).json")
      end      
      idx -= 1
    end

  end

 end