
module Av

	class Progress

		attr_accessor :quests, :complete
		attr_accessor :progress


		def initialize
			@quests = []
			@complete = []
			@progress = []
		end

		def add_quest(q)
			@quests.push(q)
		end

		def end_quest(q)
			@quests.delete(q)
			@complete.push(q)
		end

		def quest_active?(q)
			return @quests.include?(q)
		end

		def quest_done?(q)
			return @complete.include?(q)
		end


		def progress!(progress)
			@progress= $data.progress[progress]
		end

		def progress?(progress)
		    return false if !$data.progress.include?(progress)
			return @progress >= $data.progress[progress]
		end

		def beyond?(progress)
			return false if !$data.progress.include?(progress)
			return @progress > $data.progress[progress]
		end

	end

end