
class Info_Box < SpriteGroup

	attr_accessor :title

	def initialize(vp)
		super()		

		@window = Box.new(vp,300,96)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.wallpaper = $cache.menu_wallpaper("diamonds")
    	add(@window)

    	@title = Label.new(vp)
    	@title.fixed_width = 250
    	@title.text = "Tester Name"
    	add(@title,10,10)
    	
    	move(10,375)

	end

	def update
		@window.update
	end

	def change


	end

end