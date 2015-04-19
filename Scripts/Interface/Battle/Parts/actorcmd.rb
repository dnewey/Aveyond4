
class ActorCmd

	def initialize(vp)

		@vp = vp

		@icons = []
		#@text = Sprite.new(@vp)

		@idx = 0

	end

	def setup(battler)

		@battler = battler

		@icons.each{ |i| i.dispose }
		@icons = []

		# Read the categories for this guy
		battler.actions.each{ |action|
			# Add an icon?
			spr = Sprite.new(@vp)
			spr.bitmap = Cache.menu("Battle/icon")
			@icons.push(spr)
		}

		# Position the things
		angle = -135 * 0.0174532925
		dist = 50
		@icons.each{ |i|
			x = battler.ev.screen_x + Math.cos(angle) * dist
			y = (battler.ev.screen_y-15) + Math.sin(angle) * dist
			i.center(x,y)
			angle += 40 * 0.0174532925
		}

		# Prep the text
		#@text.bitmap = Cache.menu("Battle/text")
		#@text.center(battler.ev.screen_x,battler.ev.screen_y + 24)

	end

	def close
		@icons.each{ |i| i.dispose }
		#@text.bitmap = nil
		@icons = []
		@battler = nil
	end

	def get_action
		return @battler.actions[@idx]
	end

	def update

		return if @battler.nil?

		# Left and right to change
		if $input.right?
			@idx += 1 if @idx < @icons.count-1
			log_info(@battler.actions[@idx])
		end

		if $input.left?
			@idx -= 1 if @idx > 0
			log_info(@battler.actions[@idx])
		end

		pos = $mouse.position
		@icons.each{ |i|
			if i.within?(pos[0],pos[1])
				@idx = @icons.index(i)
				log_info(@battler.actions[@idx])
			end
		}

	end

end