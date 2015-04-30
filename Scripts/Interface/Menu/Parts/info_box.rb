
class Info_Box < SpriteGroup

	def initialize(vp)
		super()		

		@window = Box.new(vp,300,96)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.wallpaper = $cache.menu_wallpaper("back")
    	add(@window)
    	
    	move(10,375)

	end

	def update
		@window.update
	end

end