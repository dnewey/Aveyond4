#==============================================================================
# ** Mnu_Items
#==============================================================================

class Mnu_Save < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('save')
		@subtitle.text = "Choose a file to save!"

		#@tabs.push("recent") # Could keep 10 auto saves?
		#@tabs.push("saves")
		#@tabs.push("autos") # Could keep 10 auto saves?

		# Saves can be named somehow
		# Grid pops up, "replace", "rename"?

		@menu.list.type = :file
		@menu.list.setup($files.save_file_list)

		@page = Right_Page.new(vp)
		@right.push(@page)

		@pic = Sprite.new(vp)		
		@pic.move(340,324)

		open

	end

	def update
		super


	end

	def change(option)

		# Load up the header
		header = $files.headers[option]

		if header == nil

			@page.title("- Empty -","misc/dots")
			@pic.bitmap = nil

		else

			@page.title("Save #{option} - #{header[:time]}","faces/#{header[:leader]}")
			@pic.bitmap = Bitmap.new("#{$appdata}//Av4-#{option}.png")

		end

	end

	def select(option)	

		#log_info(option)
		$files.save_game(option)
		
	end
end