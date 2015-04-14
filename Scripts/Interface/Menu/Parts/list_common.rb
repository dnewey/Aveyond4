
class List_Common

	def initialize(vp)

		# Left side window
		@back = Sprite.new(vp)
		@back.bitmap = Bitmap.new(290,246)
		@back.bitmap.fill(Color.new(47,45,41))

		@window = Sprite.new(vp)
		@window.bitmap = Bitmap.new(300,256)
    	@window.bitmap.borderskin("Common/skin-plain")

    	@back.move(13,113)
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