
# Update self perhamps? Disregard else
# Uses $battle and that's it

# Handle all inputs?

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
		# Or put this in scene
		@actor_cmd = ActorCmd.new

		# Pointer

		# Message

	end

	def open_actor_cmd(actor)
		@actor_cmd.open(actor)
	end

	def 

	def update

		@actor_cmd.update

	end

end