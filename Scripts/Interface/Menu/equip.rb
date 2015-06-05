#==============================================================================
# ** Mnu_Equip
#==============================================================================

class Mnu_Equip < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Equip')

		@subtitle.text = "Master of deception"

		#@tabs.push("all")
		#@tabs.push("potions")
		#@tabs.push("keys")

		@menu.dispose
		self.left.delete(@menu)
		
		@grid = Ui_Grid.new(vp)
		@grid.move(15,115)
		@grid.add_button("staff","Staff of Boyle","misc/unknown")
		@grid.add_button("minion","Minion of Boy","misc/unknown")
		@grid.add_button("mid","Protective Armor","misc/unknown")
		@grid.add_button("helm","Some Shoes","misc/unknown")
		@grid.add_button("accessory","Accessorizer","misc/unknown")
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