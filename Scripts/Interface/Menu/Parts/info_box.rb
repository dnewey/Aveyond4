
class Info_Box

	def initialize(vp)

		@window = Box.new(vp,300,96)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.wallpaper = $cache.menu_wallpaper("back")

    	@window.move(10,375)

	end

	def update
		@window.update
	end

end