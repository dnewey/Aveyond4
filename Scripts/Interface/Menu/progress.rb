#==============================================================================
# ** Mnu_Progress
#==============================================================================

class Mnu_Progress < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('progress')
		@subtitle.text = "Good so far"

		remove_menu
		remove_info


		# A bunch of images with mouseover text

		# Grid selection system, without the box and wallpaper

		open

	end

	def update
		super


	end

	def change(option)


	end

	def select(option)	
		
	end


end