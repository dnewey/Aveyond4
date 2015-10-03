#==============================================================================
# ** Mnu_Title
#==============================================================================

class Mnu_Title

	def initialize(vp)

		@vp = vp
		@closing = false
		@close_soon = false
		@close_delay = 0

		@data = ['new','continue','options','quit']
		cx = 135
		cy = 110

		@buttons = []

		@data.each{ |item|

			btn = Sprite.new(@vp)
	     	btn.bitmap = $cache.title("btn-#{item}")
	     	btn.ox = btn.bitmap.width / 2
	     	btn.move(cx,cy)
	     	@buttons.push(btn)

	     	cy += 40

     	}

     	@selected = 0
     	choose(0)

	end

	def dispose

		@buttons.each{ |i| i.dispose }

	end

	def update

		if @close_soon && !@closing
			@close_delay -= 1
			if @close_delay <= 0
				close
			end
		end

		if $input.down?
			choose(@selected + 1)
		end

		if $input.up?
			choose(@selected - 1)
		end

		if $input.action?
			case @selected
				when 0
					log_sys("START NEW GAME")

				when 1
					$scene.hide_logo
					$scene.hide_char
					$scene.next_menu = "Continue"
					close_soon

				when 2
					$scene.hide_logo
					$scene.next_menu = "Options"
					close_soon

				when 3
					$game.quit
			end
		end

	end

	def choose(idx)
		if idx > @buttons.count - 1
			idx = 0
		end
		if idx < 0
			idx = @buttons.count - 1
		end
		@selected = idx
		@buttons.each{ |b| b.opacity = 150 }
		@buttons[@selected].opacity = 255
	end

	def close_soon(delay=10)
		@close_soon = true
		@close_delay = delay
	end

	def close

		@closing = true

		# Everything fade out
     	(@buttons).each{ |c|
     		c.do(go("opacity",-255,200,:linear))
     	}

     	dist = 30
     	(@buttons).each{ |c|
     		c.do(go("x",-dist,200,:qio))
     	}

     	self.do(delay(200))

	end

	def closing?
		return @closing
	end

	def done?
		return @closing && $tweens.done?(self)
	end

end