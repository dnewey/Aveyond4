
class Moblin

	def initialize(scr,delay)

		@src = src
		@delay = delay
		@next = 1

	end

	def update

		@next -= 1
		if @next <= 0

			@next = @delay
			eval(@src)

		end

	end

end