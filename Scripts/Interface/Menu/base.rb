#==============================================================================
# ** Mnu_Base
#==============================================================================

class Mnu_Base

	attr_reader :left, :right, :other

	def initialize(vp)

		@closing = false
		@close_soon = false
		@close_delay = 0

		@left = []
		@right = []
		@other = []

		@title = Page_Title.new(vp)
		@left.push(@title)

		@tabs = Page_Tabs.new(vp)
		@left.push(@tabs)

		@subtitle = Label.new(vp)
		@subtitle.move(116,74)
		@left.push(@subtitle)


		@menu = List_Common.new(vp)
		@menu.list.select = Proc.new{ |option| self.select(option) }
		#@menu.list.cancel = Proc.new{ |option| self.cancel(option) }
		@menu.list.change = Proc.new{ |option| self.change(option) }
		@left.push(@menu)

		 @info = Info_Box.new(vp)
		 @left.push(@info)

		# Anything else is per page

		

	end

	def dispose
		(@left + @right + @other).each{ |i| i.dispose }
	end

	def update
		(@left + @right + @other).each{ |i| i.update }

		if @close_soon && !@closing
			@close_delay -= 1
			if @close_delay <= 0
				close
			end
		end

		# If anim in done, change state
		if $input.cancel? || $input.rclick?
			close_now
			$scene.queue_menu("Main")
		end
	end

	def close

		@left.each{ |a| $tweens.clear(a) }
		@right.each{ |a| $tweens.clear(a) }
		@other.each{ |a| $tweens.clear(a) }

		dur = 200
		dist = 30

		@closing = true
		#(@left + @right + @other).each{ |i| i.opacity = 0 }
		@left.each{ |i| i.do(go("opacity",-255,dur,:qio))}
		@left.each{ |i| i.do(go("x",-dist,dur,:qio))}
		@right.each{ |i| i.do(go("opacity",-255,dur,:qio))}
		@right.each{ |i| i.do(go("x",dist,dur,:qio))}
		@other.each{ |i| i.do(go("opacity",-255,dur,:qio))}
		self.do(delay(dur))

	end

	def open

		dur = 200
		dist = 30

		# Hide everything, animate in
		(@left + @right + @other).each{ |i| i.opacity = 0 }
		@left.each{ |i| i.do(go("opacity",255,dur,:qio))}
		@left.each{ |i| i.x -= dist; i.do(go("x",dist,dur,:qio))}
		@right.each{ |i| i.do(go("opacity",255,dur,:qio))}
		@right.each{ |i| i.x += dist; i.do(go("x",-dist,dur,:qio))}
		@other.each{ |i| i.do(go("opacity",255,dur,:qio))}
		self.do(delay(dur))
	end

	def close_soon
		@close_soon = true
		@close_delay = 10	
	end

	def close_now
		@close_soon = true
		@close_delay = 0
	end

	def done?
		return @closing && $tweens.done?(self)
	end

end