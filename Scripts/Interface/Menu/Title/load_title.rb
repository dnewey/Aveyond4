
class Mnu_Load_Title < Mnu_Save

	def initialize(vp)
		super(vp)
		loadmode
		remove_info
	end

	def update

		# Use up inputs
		if $input.cancel? || $input.rclick?
			$scene.show_logo
			$scene.show_char
			$scene.next_menu = "Title"
			close_soon
		end

		super

	end

end