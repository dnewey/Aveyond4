
class List_Common

	def initialize(vp)

		# Left side window
		@back = Sprite.new(vp)
		@back.bitmap = Bitmap.new(164,444)
		@back.bitmap.fill(Color.new(47,45,41))

		@window = Sprite.new(vp)
		@window.bitmap = Bitmap.new(170,450)
    	@window.bitmap.borderskin("Common/skin-plain")

    	@back.move(13,13)
    	@window.move(10,10)

		# Left side list
		@list = List.new(vp)

		@list.item_width = 156
		@list.item_height = 42

		@list.item_space = 43

		@list.x = 16
		@list.y = 16


		data = []
		(0..100).to_a.each{ |i|
			dta = DataBox.new(i)
			data.push(dta)
		}

		@list.setup(data)

	end

	def dispose

	end

	def update
		@list.update
	end

end