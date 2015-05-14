#==============================================================================
# ** Mnu_Items
#==============================================================================

class Mnu_Journal < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('journal')

		@tabs.push("all")
		@tabs.push("main")
		@tabs.push("side")

		@menu.list.type = :quest

		data = $progress.quests

		@menu.list.setup(data)

		@page = Right_Page.new(vp)
		self.right.push(@page)

		change(data[0]) if !data.empty?

	end

	def update
		super

		# Inputs maybe?

		# Probably for using healing items?

	end

	def change(option)

		return

		@page.clear

		# Change page to show this quest
		#@info.title.text = option

		@page.title = $data.quests[option].name
		@page.description = $data.quests[option].description
		@page.add_zone($data.quests[option].location)

	end

	def select(option)	
		
	end


end