#==============================================================================
# ** Data Manager
#==============================================================================

class DataManager

	attr_reader :actors
	attr_reader :items

	attr_reader :quests

  attr_reader :commons
  attr_reader :tilesets
  attr_reader :system
  attr_reader :mapinfos

	def initialize

		# Load up all the data
		#@quests = load_json("quests.json")
    @commons = load_data("Data/CommonEvents.rxdata")
    @tilesets = load_data("Data/Tilesets.rxdata")
    @system = load_data("Data/System.rxdata")
    @mapinfos = load_data("Data/MapInfos.rxdata")
	end

	def load_database

    	# Load database
      	Json.init

      	# Move database data to memory
      	$data_actors        = load_data("Data/Actors.rxdata")
      	$data_classes       = load_data("Data/Classes.rxdata")
      	$data_skills        = load_data("Data/Skills.rxdata")
      $data_items         = load_data("Data/Items.rxdata")
      $data_weapons       = load_data("Data/Weapons.rxdata")
      $data_armors        = load_data("Data/Armors.rxdata")
      $data_enemies       = load_data("Data/Enemies.rxdata")
      $data_troops        = load_data("Data/Troops.rxdata")
      $data_states        = load_data("Data/States.rxdata")
      $data_animations    = load_data("Data/Animations.rxdata")
      $data_tilesets      = load_data("Data/Tilesets.rxdata")
      #$data_common_events = load_data("Data/CommonEvents.rxdata")
      #$data_system        = 

  end

 end