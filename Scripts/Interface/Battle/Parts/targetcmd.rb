
class TargetCmd

	attr_reader :active
	attr_accessor :serpent

	def initialize(vp)

		@vp = vp

		@arrow = Sprite.new(@vp)
		@arrow.bitmap = $cache.menu_common("target")
		@arrow.hide

		@targets_sy = nil
		@targets_sx = nil
		@targets = nil

		@active = nil

		@idx = 0

		# Fighting serpent
		@serpent = false

	end

	def dispose
		@arrow.dispose
	end

	def setup(targets)

		@arrow.show

		@targets = targets

		# Sort targets by y pos
		# Maybe x sort for left and right?
		@targets_sy = targets.sort_by{ |t| t.ev.screen_y }
		@targets_sx = targets.sort_by{ |t| t.ev.screen_x }

		@arrow.do(pingpong("oy",7,400,:qio))

		# Special if fighting serpent
		if @serpent

			# Arrow pos
			t = rand(3)
			@active = targets[t]
			point_at(targets[t])

		else

			# Arrow pos
			@active = targets[0]
			point_at(targets[0])

		end

	end

	def point_at(char)
		@arrow.center(char.ev.screen_x,char.ev.screen_y-char.ev.gfx_height-6)
		@active.ev.flash_dur = 15

		$scene.hud.set_help(char.name)
	end

	def close
		@arrow.hide
	end

	def update

		# Left and right to change
		if $input.right?


			# Get idx of sortings
			idx = @targets_sx.index(@active)

			idx += 1
			if idx >= @targets_sx.count
			  idx -=1
			else
				@active = @targets_sx[idx]
				point_at(@active)
			end
			
		end

		if $input.left?
			# Get idx of sortings
			idx = @targets_sx.index(@active)

			idx -= 1
			if idx < 0
			  idx +=1
			else
				@active = @targets_sx[idx]
				point_at(@active)
			end
		end



		# Left and right to change
		if $input.down?	
			
			# Get idx of sortings
			idx = @targets_sy.index(@active)

			idx += 1
			if idx >= @targets_sy.count
			  idx -=1
			else
				@active = @targets_sy[idx]
				point_at(@active)
			end
			
		end

		if $input.up?
			# Get idx of sortings
			idx = @targets_sy.index(@active)

			idx -= 1
			if idx < 0
			  idx +=1
			else
				@active = @targets_sy[idx]
				point_at(@active)
			end
		end

		pos = $mouse.position
		@targets.each{ |i|
			next if i == @active
			next if pos[0] < i.ev.screen_x - 20
			next if pos[0] > i.ev.screen_x + 20
			next if pos[1] < i.ev.screen_y - i.ev.gfx_height
			next if pos[1] > i.ev.screen_y
			@active = i
			point_at(@active)
		}

	end

end
