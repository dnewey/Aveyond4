#==============================================================================
# ** Mnu_Skills
#==============================================================================

class Mnu_Skills < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('skills')

		@tabs.push("all")
		@tabs.push("main")
		@tabs.push("side")

		@menu.list.type = :quest

		data = $progress.quests

		@menu.list.setup(data)

		@page = Right_Page.new(vp)
		@right.push(@page)

		change(data[0]) if !data.empty?

	end

	def update
		super

		# Inputs maybe?

		# Probably for using healing items?

	end

	def change(option)

		@page.clear


	end

	def select(option)	
		
	end

end