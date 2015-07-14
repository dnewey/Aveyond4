#==============================================================================
# ** Mnu_Potions
#==============================================================================

class Mnu_Potions < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('potions')
		@subtitle.text = "Making potions"		

		@menu.list.type = :potion

		#data = $progress.potions

		@page = Right_Page.new(vp)
		self.right.push(@page)

		#@menu.list.setup(data)

		#change(data[0]) if !data.empty?

		open

	end

	def update
		super

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