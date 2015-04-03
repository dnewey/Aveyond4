
class TargetCmd

	def initialize(vp)

		@vp = vp

		@arrow = Sprite.new(@vp)
		@arrow.bitmap = Cache.menu("Battle/arrow")

		@idx = 0

	end

	def setup(targets)

		# Arrow pos
		point_at(targets[0][1])

	end

	def point_at(char)
		@arrow.center(char.screen_x,char.screen_y)
	end

	def close
		
	end

	def update

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