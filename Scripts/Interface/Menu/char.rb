#==============================================================================
# ** Mnu_Char
#==============================================================================

class Mnu_Char < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('boy')

		@subtitle.text = "Master of deception"

		#@tabs.push("all")
		#@tabs.push("potions")
		#@tabs.push("keys")

		@menu.dispose
		self.left.delete(@menu)
		
		@grid = Ui_Grid.new(vp)
		@grid.move(15,115)
		@grid.add_wide("equip","Equip","misc/unknown")
		@grid.add_wide("skills","Skills","misc/unknown")
		@grid.add_wide("status","Status","misc/unknown")
		@grid.add_wide("profile","Profile","misc/unknown")
		self.left.push(@grid)


		@port = Port_Full.new(vp)
		self.right.push(@port)

	end

	def update
		super

		@grid.update
		
	end

	def change(option)
		
	end

	def select(option)	
		
	end

end