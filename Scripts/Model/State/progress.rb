class Progress

	#attr_accessor :quests, :complete
	#attr_accessor :progress


	def initialize
		@quests = []
		@complete = []
		@progress = 0
	end

	def add_quest(q)
		@quests.push(q)
		$map.need_refresh = true
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

	def quest_done?(q)
		return @complete.include?(q)
	end

	def progress(pro)
		@progress= $data.progress[pro]
		$map.need_refresh = true
		log_info("Progress Set: #{pro}")
	end

	def get_progress
		return @progress
	end

	def progress?(progress)
	    return false if !$data.progress.include?(progress)
		return @progress >= $data.progress[progress]
	end

	def beyond?(progress)
		return false if !$data.progress.include?(progress)
		return @progress > $data.progress[progress]
	end

	def before?(progress)
		return false if !$data.progress.include?(progress)
		return @progress < $data.progress[progress]
	end

end