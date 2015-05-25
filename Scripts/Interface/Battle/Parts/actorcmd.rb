
class ActorCmd

	def initialize(vp)

		@vp = vp

		@icons = []
		#@text = Sprite.new(@vp)

		@idx = 0

	end

	def setup(battler)

		close

		@battler = battler

		@icons.each{ |i| i.dispose }
		@icons = []

		# Read the categories for this guy
		@battler.actions.each{ |action|
			# Add an icon?
			spr = Sprite.new(@vp)
			spr.bitmap = $cache.icon("misc/bulb")
			@icons.push(spr)
		}



		# Position the things
		reposition

		select

		# Prep the text
		#@text.bitmap = Cache.menu("Battle/text")
		#@text.center(battler.ev.screen_x,battler.ev.screen_y + 24)

	end

	def close
		@icons.each{ |i|
			$tweens.clear(i)
		}
		@icons.each{ |i| i.dispose }
		#@text.bitmap = nil
		@icons = []
		@battler = nil
	end

	def get_action
		return @battler.actions[@idx]
	end

	def reposition
		sx = @battler.ev.screen_x
		sy = @battler.ev.screen_y-50

		if @icons.count == 3
			@icons[0].center(sx-36,sy-16)
			@icons[1].center(sx,sy-25)
			@icons[2].center(sx+36,sy-16)
		end

		if @icons.count == 4
			@icons[0].center(sx-48,sy-16)
			@icons[1].center(sx-18,sy-25)
			@icons[2].center(sx+18,sy-25)
			@icons[3].center(sx+48,sy-16)
		end


	end

	def select
		@icons.each{ |i|
			$tweens.clear(i)
		}
		reposition
		seq = sequence(go("y",-8,250,:quad_in_out),go("y",8,250,:cubic_in_out))
		@icons[@idx].do(repeat(seq))
	end

	def update

		return if @battler.nil?

		# Left and right to change
		if $input.right?
			@idx += 1 if @idx < @icons.count-1
			$scene.hud.set_help(@battler.actions[@idx])
			select
		end

		if $input.left?
			@idx -= 1 if @idx > 0
			$scene.hud.set_help(@battler.actions[@idx])
			select
		end

		pos = $mouse.position
		@icons.each{ |i|
			if i.within?(pos[0],pos[1])
				@idx = @icons.index(i)
				$scene.hud.set_help(@battler.actions[@idx])
			end
		}

	end

end