#==============================================================================
# ** Mnu_Items
#==============================================================================

class Mnu_Save < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('save')

		#@tabs.push("recent") # Could keep 10 auto saves?
		#@tabs.push("saves")
		#@tabs.push("autos") # Could keep 10 auto saves?

		@menu.list.type = :file

		# Saves can be named somehow
		# Grid pops up, "replace", "rename"?

		data = $files.save_file_list

		@menu.list.setup(data)

		@page = Right_Page.new(vp)
		@right.push(@page)

		#change(data[0]) if !data.empty?

	end

	def update
		super

		# Inputs maybe?

		# Probably for using healing items?

	end

	def change(option)


	end

	def select(option)	

		log_info(option)
		$files.save_game(option)
		
	end
end