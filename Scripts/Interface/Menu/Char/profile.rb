#==============================================================================
# ** Mnu_Profile
#==============================================================================

class Mnu_Profile < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Profile')
		@title.icon($menu.char)
		@subtitle.text = "Master of deception"

		@char = $party.get($menu.char)

		remove_menu
		remove_info

		@box = Box.new(vp,300,350)
		@box.skin = $cache.menu_common("skin")
		@box.wallpaper = $cache.menu_wallpaper("diamonds")
		@box.move(15,115)
		self.left.push(@box)
		
		data = []
		data.push(["faces/boy","Name: Boyle"])
		data.push(["faces/boy","Home: Wyrmwood"])
		data.push(["faces/boy","Age: 29¾"])

		cx = 30
		cy = 125

		data.each{ |d|

			lbl = Label.new(vp)
			lbl.icon = $cache.icon(d[0])
	     	lbl.font = $fonts.list
	     	lbl.shadow = $fonts.list_shadow
	     	lbl.text = d[1]
	     	lbl.move(cx,cy)
	     	self.left.push(lbl)

	     	cy += 31

	     }

	    @desc = Area.new(vp)
    	@desc.font = $fonts.pop_text
    	@desc.text = "Boyle Wolfman, more wolf than man and even less man than dingo. Next line."
    	@desc.move(cx,cy)
    	self.left.push(@desc)

		@port = Port_Full.new(vp)
		self.right.push(@port)

		open

	end

	def update
		
		# Cancel out of grid
		if $input.cancel? || $input.rclick?
			@left.each{ |a| $tweens.clear(a) }
			@right.each{ |a| $tweens.clear(a) }
			@other.each{ |a| $tweens.clear(a) }
			$scene.queue_menu("Char")
			close_now
		end
		
		super
		
	end

end