#==============================================================================
# ** Mnu_Status
#==============================================================================

class Mnu_Status < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Status')
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
		data.push(["faces/boy","Level 1 (20 of 600 XP)"])
		data.push(["faces/boy","Health 100 / 5000"])
		data.push(["faces/boy","Shadow 100 / 5000"])
		data.push(["faces/boy","Strength 34 (20 + 14)"])
		data.push(["faces/boy","Defense 34"])
		data.push(["faces/boy","Evasion 34"])
		data.push(["faces/boy","Critical 34"])
		data.push(["faces/boy","Luck 34"])
		data.push(["faces/boy","Luck 34"])


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