
class Moblin

	def initialize(ev,delay)

		@ev = ev
		@delay = delay
		@next = 1

	end

	def update

		@next -= 1
		if @next <= 0

			@next = @delay
			@ev.start

		end

	end

end