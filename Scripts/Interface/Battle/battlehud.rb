
# Update self perhamps? Disregard else
# Uses $battle and that's it

class BattleHud

	def initialize(vp)

		# Bottom bar
		@chars = []
		idx = 0
		$party.active.each{ |char|
			@chars.push(CharView.new(vp,$party.get(char),idx))
			idx += 1
		}

		# Skill selector

		# Pointer

		# Message

	end

	def update

		# Check for party member changes

		# Check for skill select changes

		# Check for pointer changes - pointer is char id

		# Check for message changes haha

	end

end