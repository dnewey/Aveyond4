class Progress

	attr_accessor :quests, :complete

	attr_accessor :night_rank, :night_xp
  	attr_accessor :attract_boy, :attract_hib, :attract_phy

  attr_accessor :guild_id

	def initialize

		@quests = []
		@complete = []

		add_quest('ch0-domination')


		# Boyle - creatures
		@creatures = {} # Sorted by zone




		# Nightwatch rank
	    @night_rank = 0
	    @night_xp = 0

	    # Attraction
	    @attract_boy = 0
	    @attract_hib = 0
	    @attract_phy = 0

	    # Guild info
	    @guild_id = "c" # will be one letter, b, c, or s, or "" for none

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

end