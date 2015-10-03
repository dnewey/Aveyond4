
class Mnu_Options_Title < Mnu_Options

	def initialize(vp)
		super(vp)
		@port.dispose
		@right.delete(@port)
		#@title.y = -1000
		#@subtitle.y = -1000
		remove_info
	end

	def update

		# Use up inputs
		if $input.cancel? || $input.rclick?
			$scene.show_logo
			$scene.next_menu = "Title"
			close_soon
		end

		super

	end

end