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
		@tabs.change = Proc.new{ |option| self.tab(option) }
		@left.push(@tabs)

		@subtitle = Label.new(vp)
		@subtitle.font = $fonts.subtitle
		@subtitle.move(116,72)
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

	def remove_menu
		@menu.dispose
		self.left.delete(@menu)
	end

	def remove_info
		@info.dispose
		self.left.delete(@info)
	end

	def dispose
		(@left + @right + @other).each{ |i| i.dispose }
	end

	def update

		if !@close_soon
			(@left + @right + @other).each{ |i| i.update }
		end

		if @close_soon && !@closing
			@close_delay -= 1
			if @close_delay <= 0
				close
			end
		end

		return if @close_soon

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

	def close_soon(d=10)
		sys('cancel')
		@close_soon = true
		@close_delay = d
	end

	def close_now
		sys('cancel')
		@close_soon = true
		@close_delay = 0
	end

	def done?
		return @closing && $tweens.done?(self)
	end

end