class Progress

	attr_accessor :quests, :complete

	attr_accessor :night_rank, :night_xp
  	attr_accessor :attract_boy, :attract_hib, :attract_phy

  	attr_accessor :guild_id

  	attr_reader :creatures, :chester_level

  	attr_reader :demons

  	attr_accessor :store_level, :store_xp, :store_done

	def initialize

		@quests = []
		@complete = []

		add_quest('ch0-domination')


		# Boyle - creatures
		@creatures = {} # Sorted by zone
		@creatures['wyrmwood'] = 0

		# Boyle skills
		@chester_level = 0

		# Phy
		@demons = [] # Demons defeated

		# Nightwatch rank
	    @night_rank = 1
	    @night_xp = 0

	    # Attraction
	    @attract_boy = 0
	    @attract_hib = 0
	    @attract_phy = 0

	    # Guild info
	    @guild_id = 'n' #nil # will be one letter, b, c, or s, or "" for none

	    # Robin Shop
	    @store_level = 2
	    @store_xp = 0
	    @store_done = []

	end


	def add_quest(q)
		@quests.push(q)
		$map.need_refresh = true if $map
		log_info("Quest Added: #{q}")
	end

	def end_quest(q)
		@quests.delete(q)
		@complete.push(q)
		$map.need_refresh = true
		log_info("Quest Ended: #{q}")
	end

	def quest_active?(q)
		return @quests.include?(q)
	end

	def quest_complete?(q)
		return @complete.include?(q)
	end

	def catch_creature()

		zone = $map.zone.id

		# Auto convert zone to overall zone
		case zone

			when '@wyrmwood','@mir-woods','@fangder-cave','@mist-mountain'
				zone = 'wyrmwood'

			when '@windshire','@wind-hills','@wind-caves','@windmill','@briar-woods','@briar-caves','@whisper','@aveyond','@wind-valley','@endworld'
				zone = 'windshire'

			when '@wastelands','@tor','@dwarf-town','@firedeep','@firedeep-2','@arena'
				zone = 'wasteland'

			when '@royal-woods','@royal-town','@woods-boppity','@woods-ginger','@ginger-cave','@woods-swamp','@woods-hills','@royal-castle','@royal-dungeon','@royal-crusade','@royal-crabs','@weeville'
				zone = 'royal'

			when '@elvaria','@vault','@petrified-plains','@elf-town'
				zone = 'elvaria'

			when '@shadow','@shadow-lands','@skull-mountain','@shadow-cave','@ravwyn'
				zone = 'shadow'

			when '@snow-island','@crab-island','@wind-tower','@dream-zone','@dream-zone-2','@mist-realm'
				zone = 'other'

		end

		if zone == $map.zone.id
			log_err 'Invalid Cheeki location: '+zone
			$game.quit
		end

		#src = ["wyrmwood",'windshire','wasteland','royal','elvaria','shadow','other']

		if !@creatures.has_key?(zone)
			@creatures[zone] = 1
		else
			@creatures[zone] += 1
		end
	end

	def inc_chester_level(lvl)
		@chester_level = lvl if lvl > @chester_level
	end

	def defeat_demon(demon)
		@demons.push(demon)
	end

	def add_night_xp(amount)
		@night_xp += amount	
	end

end