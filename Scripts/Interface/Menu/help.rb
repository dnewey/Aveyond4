#==============================================================================
# ** Mnu_Help
#==============================================================================

class Mnu_Help < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('help')
		@subtitle.text = "HELP HELP"

		log_scr("HUH")

		@menu.list.type = :quest

		data = $progress.quests

		@page = Right_Page.new(vp)
		self.right.push(@page)

		@menu.list.setup(data)

		

		#change(data[0]) if !data.empty?

	end

	def update
		super

		# Inputs maybe?

		# Probably for using healing items?

	end

	def change(option)

		#return

		@page.clear

		# Change page to show this quest
		#@info.title.text = option

		@page.title = $data.quests[option].name
		@page.description = $data.quests[option].description

		@page.add_reqs($data.quests[option].req)
		@page.add_zone($data.quests[option].location)

	end

	def select(option)	
		
	end


end