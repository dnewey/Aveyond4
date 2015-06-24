#==============================================================================
# ** Mnu_Items
#==============================================================================

class Mnu_Save < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('save')

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



	end

	def select(option)	
		
	end
end