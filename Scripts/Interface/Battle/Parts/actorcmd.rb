
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
			spr.bitmap = $cache.icon("battle/boy-staff")
			spr.ox = spr.width/2
			spr.oy = spr.height
			@icons.push(spr)
		}



		# Position the things
		

		select

		reposition

		# Prep the text
		#@text.bitmap = Cache.menu("Battle/text")
		#@text.center(battler.ev.screen_x,battler.ev.screen_y + 24)

	end

	def close
		return if !@icons || @icons.empty?
		@icons.each{ |i|
			$tweens.clear(i)
		}

		@icons[0].do(go("opacity",-255,250,:qio))
			@icons[1].do(go("opacity",-255,250,:qio))
			@icons[2].do(go("opacity",-255,250,:qio))

		@icons[0].do(go("x",36,250,:qio))
			@icons[0].do(go("y",16,250,:qio))
			#@icons[1].move(sx,sy-25)
			@icons[1].do(go("y",25,250,:qio))
			#@icons[2].move(sx+36,sy-16)
			@icons[2].do(go("x",-36,250,:qio))
			@icons[2].do(go("y",16,250,:qio))

		#@icons.each{ |i| i.dispose }
		#@text.bitmap = nil
		#@icons = []
		#@battler = nil
	end

	def get_action
		return @battler.actions[@idx]
	end

	def reposition
		sx = @battler.ev.screen_x
		sy = @battler.ev.screen_y-44

		if @icons.count == 3

			@icons[0].opacity = 0
			@icons[1].opacity = 0
			@icons[2].opacity = 0

			@icons[0].move(sx,sy+12)
			@icons[1].move(sx,sy+12)
			@icons[2].move(sx,sy+12)

			@icons[0].do(go("opacity",255,250,:qio))
			@icons[1].do(go("opacity",255,250,:qio))
			@icons[2].do(go("opacity",255,250,:qio))

			#@icons[0].move(sx-36,sy-16)
			@icons[0].do(go("x",-36,250,:qio))
			@icons[0].do(go("y",-16,250,:qio))
			#@icons[1].move(sx,sy-25)
			@icons[1].do(go("y",-25,250,:qio))
			#@icons[2].move(sx+36,sy-16)
			@icons[2].do(go("x",36,250,:qio))
			@icons[2].do(go("y",-16,250,:qio))
		end

		if @icons.count == 4
			@icons[0].center(sx-48,sy-16)
			@icons[1].center(sx-18,sy-25)
			@icons[2].center(sx+18,sy-25)
			@icons[3].center(sx+48,sy-16)
		end


	end

	def select
		sys('select')
		idx = 0
		@icons.each{ |i|
			$tweens.clear(i)
			i.bitmap = $cache.icon("battle/#{@battler.id}-#{@battler.actions[idx]}")
			i.ox = i.width/2
			i.oy = i.height
			idx += 1
		}
		#reposition
		@icons[@idx].bitmap = $cache.icon("battle/#{@battler.id}-#{@battler.actions[@idx]}-on")
		#seq = sequence(go("y",-3,400),go("y",3,400))
		@icons[@idx].do(repeat(seq))
		$scene.hud.set_help(@battler.actions[@idx])
		@icons[@idx].ox = @icons[@idx].width/2
		@icons[@idx].oy = @icons[@idx].height
	end

	def update

		return if @battler.nil?

		# Left and right to change
		if $input.right? && @idx < @icons.count-1
			@idx += 1
			select
		end

		if $input.left? && @idx > 0
			@idx -= 1 			
			select
		end

		pos = $mouse.position
			@icons.each{ |i|
			if i.within?(pos[0],pos[1])
				break if @icons.index(i) == @idx
				@idx = @icons.index(i)
				select
			end
		}

	end

end