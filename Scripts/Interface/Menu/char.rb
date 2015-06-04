#==============================================================================
# ** Mnu_Char
#==============================================================================

class Mnu_Char < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change($menu.char)

		@subtitle.text = "Master of deception"

		#@tabs.push("all")
		#@tabs.push("potions")
		#@tabs.push("keys")

		data = []
		data.push(['Equip',"misc/unknown"])
		data.push(['Skills',"misc/unknown"])
		data.push(['Status',"misc/unknown"])

		@menu.list.type = :misc
		@menu.list.setup(data)

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