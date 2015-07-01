#==============================================================================
# ** Mnu_Profile
#==============================================================================

class Mnu_Profile < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Profile')
		@subtitle.text = "Master of deception"

		@char = $party.get($menu.char)

		@menu.dispose
		self.left.delete(@menu)

		@box = Box.new(vp,300,302)
		@box.skin = $cache.menu_common("skin")
		@box.wallpaper = $cache.menu_wallpaper("diamonds")
		@box.move(15,115)
		self.left.push(@box)
		
		@grid = Ui_Grid.new(vp)
		@grid.move(15,425)
		@grid.add_wide('done',"Done","misc/unknown")
		self.left.push(@grid)

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

		@port = Port_Full.new(vp)
		self.right.push(@port)

		@info.dispose
		self.left.delete(@info)

	end

	def update
		super

		@grid.update

		# Cancel out of grid
		if $input.cancel? || $input.rclick? || $input.action? || $input.click?
			$scene.change_sub("Char")
	 		cancel
		end
		
	end

end