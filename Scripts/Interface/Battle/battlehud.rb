
# Update self perhamps? Disregard else
# Uses $battle and that's it

# Handle all inputs?

class BattleHud

	def initialize(vp)

		# Bottom bar
		@chars = []
		idx = 0
		$party.active.each{ |char|
			@chars.push(CharView.new(vp,$party.actor_by_id(char),idx))
			idx += 1
		}



	end

	
	def update

		

	end

end