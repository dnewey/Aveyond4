
class List_Main < SpriteGroup

	attr_accessor :list

	def initialize(vp)
		super()

		# Left side window
		@window = Box.new(vp)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.color = Color.new(47,45,41)
    	@window.resize(178,362)
    	add(@window)

		# Left side list
		@list = List.new()
		@list.type = :misc

		# @list.item_width = 156
		# @list.item_height = 42
		#@list.item_space = 43

		@list.item_width = 166
		@list.item_height = 34
		@list.item_space = 35
		

		add(@list,6,6)

		data = []
		data.push(['Items',"items/map"])
		data.push(['Journal','items/map'])
		data.push(['Party','items/map'])
		data.push(['Equip','items/map'])
		data.push(['Skills','items/map'])
		data.push(['Profiles','items/map'])
		data.push(['Options','items/map'])
		data.push(['Quit','items/map'])
		data.push(['Load','items/map'])
		data.push(['Save','items/map'])

		@list.setup(data)

		move(10,490)
		@list.refresh

	end

	def dispose
		@window.dispose
		@list.dispose
	end

	def update
		@list.update
	end

end

def _db(*args)
	DataBox.new(args[0],args[1],args[2],args[3])
end