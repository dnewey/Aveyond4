
class List_Main

	attr_accessor :list

	def initialize(vp)

		# Left side window
		@window = Box.new(vp)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.color = Color.new(47,45,41)

    	@window.move(10,10)

		# Left side list
		@list = List.new()

		@list.item_width = 156
		@list.item_height = 42

		@list.item_space = 43

		@list.x = 16
		@list.y = 16


		data = []
		data.push(_db('menu','Items'))
		data.push(_db('menu','Journal'))
		data.push(_db('menu','Party'))
		data.push(_db('menu','Equip'))
		data.push(_db('menu','Skills'))
		data.push(_db('menu','Profiles'))
		data.push(_db('menu','Options'))
		data.push(_db('menu','Help'))
		data.push(_db('menu','Quit'))
		data.push(_db('menu','Load'))
		data.push(_db('menu','Save'))

		@list.setup(data)

	end

	def dispose

	end

	def update
		@list.update
	end

end

def _db(*args)
	DataBox.new(args[0],args[1],args[2],args[3])
end