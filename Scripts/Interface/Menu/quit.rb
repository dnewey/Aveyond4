
class Mnu_Quit < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('quit')
		@subtitle.text = "YE WIMP!"

		remove_menu
		remove_info
		
		@grid = Ui_Grid.new(vp)
		@grid.move(135,135)
		@grid.add_wide("save","Save and Quit","misc/unknown")
		@grid.add_wide("quit","Quit Without Saving","misc/unknown")
		@grid.add_wide("continue","Continue Playing","misc/unknown")
		self.left.push(@grid)

		open

	end

	def update
		super

		@grid.update

		# Cancel out of grid
		if $input.cancel? || $input.rclick?
			@left.each{ |a| $tweens.clear(a) }
			@right.each{ |a| $tweens.clear(a) }
			@other.each{ |a| $tweens.clear(a) }
			close
		end

	end

	def change(option)


	end

	def select(option)	
		
	end

end