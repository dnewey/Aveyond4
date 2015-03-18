#==============================================================================
# ** Game_Battle
#==============================================================================

# Hold battle state

# Phases
# :start - introduction seq
# :command - choose actions
# :main - perform actions
# :victory - player wins
# :defeat - enemy wins

class Game_Battle

	def initialize

		@phase = :start

	end

	def start_phase_2

		# Player command inputs section
		@phase = :command

		@idx = -1

		next_actor

		# that's about it?
		# show the ui? how?

		$party.clear_actions

	end

	def update_phase_2
		# awaiting inputs?
	end

	def start_phase_3

	end

end
  