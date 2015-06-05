
class Mnu_Party < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('party')

		

		@menu.hide
		
		@grid = Ui_Grid.new(vp)
		@grid.move(15,115)
		@grid.add_button("Test","Change Party","misc/unknown")
		@grid.add_button("Test","Choose Leader","misc/unknown")
		@grid.add_button("Test","Friendships","misc/unknown")

	end

	def update
		super

		# Inputs maybe?

		# Probably for using healing items?

	end

	def change(option)

		@page.clear


	end

	def select(option)	
		
	end

end