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

		@menu.list.type = :equip
		@menu.list.setup($party.get('boy').equip_list)

		@port = Port_Full.new(vp)
		self.right.push(@port)

	end

	def update
		super
		
	end

	def change(option)
		
	end

	def select(option)	
		
	end

end