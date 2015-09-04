#==============================================================================
# ** Mnu_Journal
#==============================================================================

class Mnu_Journal < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('journal')

		@tabs.push("all")
		@tabs.push("main")
		@tabs.push("side")

		@menu.list.type = :quest
		@menu.list.setup($progress.quests.reverse)

		@page = Right_Journal.new(vp)
		self.right.push(@page)

		open

		# Open first
		change($progress.quests[0]) if !$progress.quests.empty?

	end

	def update
		super
	end

	def tab(option)

		# Reload the quest list limited to this tab
		data = $progress.quests.reverse

		if option == "main"
			data = data.select{ |q| $data.quests[q].type == 'main' }
		end

		if option == "side"
			data = data.select{ |q| $data.quests[q].type != 'main' }
		end

		@menu.list.setup(data)
		@menu.list.slide

	end

	def change(option)

		@page.clear

		@page.title = $data.quests[option].name
		@page.description = $data.quests[option].description

		@page.add_reqs($data.quests[option].req)
		@page.add_zone($data.quests[option].location)

	end

	def select(option)

	end

end