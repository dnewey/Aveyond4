
class Info_Box

	def initialize(vp)

		@wallpaper = Wallpaper.new(294,90,Cache.menu("Common/back"),vp)
    	#@wallpaper.opacity = 230

		@window = Sprite.new(vp)
		@window.bitmap = Bitmap.new(300,96)
    	@window.bitmap.borderskin("Common/skin-plain")

    	@wallpaper.move(13,378)
    	@window.move(10,375)

	end

	def update
		@wallpaper.update
	end

end