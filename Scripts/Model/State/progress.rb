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

	def catch_creature(zone)
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