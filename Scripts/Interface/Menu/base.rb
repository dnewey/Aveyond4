#==============================================================================
# ** Mnu_Base
#==============================================================================

class Mnu_Base

	attr_reader :left, :right, :other

	def initialize(vp)

		@closing = false

		@left = []
		@right = []
		@other = []

		@title = Page_Title.new(vp)
		@left.push(@title)

		@tabs = Page_Tabs.new(vp)
		@left.push(@tabs)

		@menu = List_Common.new(vp)
		@menu.list.select = Proc.new{ |option| self.select(option) }
		@menu.list.cancel = Proc.new{ |option| self.cancel(option) }
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

		# If anim in done, change state
	end

	def close
		@closing = true
		@left.each{ |i|
			# Animate each thing sliding left and fading out
		}
	end

	def open
		# Hide everything, animate in
		(@left + @right + @other).each{ |i| i.opacity = 0 }
		@left.each{ |i| i.do(go("opacity",255,400,:qio))}
		@left.each{ |i| i.x -= 50; i.do(go("x",50,400,:qio))}
		@right.each{ |i| i.do(go("opacity",255,500,:qio))}
		@right.each{ |i| i.x += 50; i.do(go("x",-50,400,:qio))}
		@other.each{ |i| i.do(go("opacity",255,500,:qio))}
	end

	def cancel(option)
		close
	end

	def done?
		return @closing # && NO TWEENS GOING
	end

end