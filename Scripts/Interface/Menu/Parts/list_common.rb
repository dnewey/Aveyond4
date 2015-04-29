
class List_Common

	def initialize(vp)

		# Left side window
		@window = Box.new(vp,290,246)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.color = Color.new(47,45,41)
    	@window.move(10,110)

		# Left side list
		@list = List.new()

		@list.item_width = 288
		@list.item_height = 34

		@list.item_space = 35

		@list.x = 16
		@list.y = 116

		data = []
		data.push(_db('menu','Potion'))
		data.push(_db('menu','Journal'))
		data.push(_db('menu','Party'))
		data.push(_db('menu','Equip'))
		data.push(_db('menu','Skills'))
		data.push(_db('menu','Profiles'))
		data.push(_db('menu','Options'))

		@list.setup(data)

	end

	def dispose

	end

	def update
		@list.update
	end

end