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
		@pic.bitmap = Bitmap.new("#{$appdata}//Av4-1.png")
		@pic.move(340,280)

	end

	def update
		super


	end

	def change(option)

		# Load up the header
		file = $files.headers[option]

		if file == nil

			@page.title = "NO FILE"

		else

			@page.title = file[:name]

		end


	end

	def select(option)	

		log_info(option)
		$files.save_game(option)
		
	end
end