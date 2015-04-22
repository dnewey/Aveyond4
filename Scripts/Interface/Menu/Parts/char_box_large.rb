

class Char_Box_Large

	def initialize(vp)

	    @wallpaper = Wallpaper.new(201,156,$cache.menu("Common/portback"),vp)
	    #@wallpaper.opacity = 230

		@gradient = Sprite.new(vp)
		@gradient.bitmap = $cache.menu("Common/charbox-gradient")
		@gradient.opacity = 90

		@window = Sprite.new(vp)
		@window.bitmap = Bitmap.new(205,160)
		@window.bitmap.borderskin

		@port = Sprite.new(vp)
		@port.bitmap = $cache.face("boy")

	end

	def setup(char)

	end

	def move(x,y)
		@window.move(x,y)
		@gradient.move(x+2,y+50)
		@wallpaper.move(x+2,y+2)		
		@port.move(x+17,y-27)
	end

end