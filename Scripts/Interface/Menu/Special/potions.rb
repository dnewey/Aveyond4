#==============================================================================
# ** Mnu_Potions
#==============================================================================

class Mnu_Potions < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('potions')
		@subtitle.text = "Making potions"		

		@menu.list.type = :potion
		@menu.list.setup($party.potions)

		@page = Right_Potion.new(vp)
		self.right.push(@page)

		@page.setup("truth")		

		#change(data[0]) if !data.empty?

		open

	end

	def update
		super

	end

	def change(option)

		@page.setup(option)		

	end

	def select(option)	
		
	end

end