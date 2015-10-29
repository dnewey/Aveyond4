#==============================================================================
# ** Mnu_Help
#==============================================================================

class Mnu_Help < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('help')
		@subtitle.text = "How to play the game"

		@menu.list.type = :misc

		data = []
		$data.help.values.each{ |h|
			data.push([h.id,h.name,h.icon])
		}

		@page = Right_Journal.new(vp)
		@right.push(@page)

		@menu.list.setup(data)		

		open

		#change(data[0]) if !data.empty?

	end

	def update
		super

		# Inputs maybe?

		# Probably for using healing items?

	end

	def change(option)

		option = option[0]

		#return

		@page.clear

		# Change page to show this quest
		#@info.title.text = option

		@page.title = $data.help[option].name
		@page.description = $data.help[option].description

		#@page.add_reqs($data.quests[option].req)
		#@page.add_zone($data.quests[option].location)

	end

	def select(option)	
		
	end


end