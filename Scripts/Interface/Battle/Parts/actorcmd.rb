
class ActorCmd

	def initialize(vp)

		@vp = vp

		@icons = []
		@texts = []
		#@text = Sprite.new(@vp)

		@idx = 0

	end

	def setup(battler)

		close

		@battler = battler

		@icons.each{ |i| i.dispose }
		@icons = []

		@texts.each{ |i| i.dispose }
		@texts = []

		# Read the categories for this guy
		@battler.actions.each{ |action|
			# Add an icon?
			spr = Sprite.new(@vp)
			@icons.push(spr)

			spr = Sprite.new(@vp)
			@texts.push(spr)
		}

		# Position the things
		#@idx = 1
		

		reposition
		select

		# Prep the text
		#@text.bitmap = Cache.menu("Battle/text")
		#@text.center(battler.ev.screen_x,battler.ev.screen_y + 24)

	end

	def close
		return if !@icons || @icons.empty?

		@icons.each{ |i|
			$tweens.clear(i)
		}
		@texts.each{ |i|
			$tweens.clear(i)
		}

		if @icons.count == 2

			@icons[0].do(go("x",18,250,:qio))
			@icons[0].do(go("y",25,250,:qio))

			@icons[1].do(go("x",-18,250,:qio))
			@icons[1].do(go("y",25,250,:qio))

		end

		if @icons.count == 3

			@icons[0].do(go("x",36,250,:qio))
			@icons[0].do(go("y",16,250,:qio))

			@icons[1].do(go("y",25,250,:qio))

			@icons[2].do(go("x",-36,250,:qio))
			@icons[2].do(go("y",16,250,:qio))

		end

		if @icons.count == 4

			@icons[0].do(go("x",54,250,:qio))
			@icons[0].do(go("y",16,250,:qio))

			@icons[1].do(go("x",18,250,:qio))
			@icons[1].do(go("y",25,250,:qio))

			@icons[2].do(go("x",-18,250,:qio))
			@icons[2].do(go("y",25,250,:qio))

			@icons[3].do(go("x",-54,250,:qio))
			@icons[3].do(go("y",16,250,:qio))

		end

		(@texts + @icons).each{ |i|
			i.do(go("opacity",-255,250,:qio))
			i.do(go("opacity",-255,250,:qio))
			i.do(go("opacity",-255,250,:qio))
		}

	end

	def get_action
		return @battler.actions[@idx]
	end

	def reposition
		sx = @battler.ev.screen_x
		sy = @battler.ev.screen_y-44

		@icons.each{ |i|

				# Hide and fade in
				i.opacity = 0
				i.do(go("opacity",255,250,:qio))

				# Move
				i.move(sx,sy+12)

			}

		if @icons.count == 2

			cx = -18

			@icons[0].do(go("x",cx,250,:qio))
			@icons[0].do(go("y",-25,250,:qio))

			@texts[0].move(sx+cx+2,sy-35)

			cx += 36

			@icons[1].do(go("x",cx,250,:qio))
			@icons[1].do(go("y",-25,250,:qio))

			@texts[1].move(sx+cx+2,sy-35-9)

		end

		if @icons.count == 3

			cx = -36

			@icons[0].do(go("x",cx,250,:qio))
			@icons[0].do(go("y",-16,250,:qio))

			@texts[0].move(sx+cx+2,sy-35)

			cx += 36

			@icons[1].do(go("x",cx,250,:qio))
			@icons[1].do(go("y",-25,250,:qio))

			@texts[1].move(sx+cx+2,sy-35-9)

			cx += 36

			@icons[2].do(go("x",cx,250,:qio))
			@icons[2].do(go("y",-16,250,:qio))

			@texts[2].move(sx+cx+2,sy-35)

		end

		if @icons.count == 4

			cx = -36-18

			@icons[0].do(go("x",cx,250,:qio))
			@icons[0].do(go("y",-16,250,:qio))

			@texts[0].move(sx+cx+2,sy-35)

			cx += 36

			@icons[1].do(go("x",cx,250,:qio))
			@icons[1].do(go("y",-25,250,:qio))

			@texts[1].move(sx+cx+2,sy-35-9)

			cx += 36

			@icons[2].do(go("x",cx,250,:qio))
			@icons[2].do(go("y",-25,250,:qio))

			@texts[2].move(sx+cx+2,sy-35-9)

			cx += 36

			@icons[3].do(go("x",cx,250,:qio))
			@icons[3].do(go("y",-16,250,:qio))

			@texts[3].move(sx+cx+2,sy-35)
			
		end


	end

	def select
		sys('select')
		
		idx = 0
		@icons.each{ |i|
			#$tweens.resolve(i)
			
			i.bitmap = $cache.icon("battle/#{@battler.actions[idx]}")

			i.ox = i.width/2
			i.oy = i.height
			idx += 1
		}
		idx = 0
		@texts.each{ |i|
			$tweens.resolve(i)

			i.opacity = 0
			
			i.bitmap = $cache.icon("texts/#{@battler.actions[idx]}")

			i.ox = i.width/2
			i.oy = i.height
			idx += 1
		}

		
		#reposition
		@icons[@idx].bitmap = $cache.icon("battle/#{@battler.actions[@idx]}-on")
		#seq = sequence(go("y",-3,400),go("y",3,400))
		@icons[@idx].do(repeat(seq))
		$scene.hud.set_help(@battler.actions[@idx])
		@icons[@idx].ox = @icons[@idx].width/2
		@icons[@idx].oy = @icons[@idx].height

		@texts[@idx].y -= 10
		@texts[@idx].do(go("y",10,250,:qio))
		@texts[@idx].do(go("opacity",255,250,:qio))

		#@texts[@idx].zoom_x -= 10
		@icons[@idx].zoom_x = 1.0
		@icons[@idx].zoom_y = 1.0
		@icons[@idx].do(seq(go("zoom_x",0.2,50,:qio),go("zoom_x",-0.2,50,:qio)))
		@icons[@idx].do(seq(go("zoom_y",0.2,50,:qio),go("zoom_y",-0.2,50,:qio)))

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
		pos[0] += 13
		pos[1] += 34
			@icons.each{ |i|
			if i.within?(pos[0],pos[1])
				break if @icons.index(i) == @idx
				@idx = @icons.index(i)
				select
			end
		}

	end

end