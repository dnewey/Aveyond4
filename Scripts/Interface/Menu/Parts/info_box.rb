
class Info_Box < SpriteGroup

	attr_accessor :title

	def initialize(vp)
		super()		

		@window = Box.new(vp,300,60)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.wallpaper = $cache.menu_wallpaper("diamonds")
    	add(@window)

    	@title = Label.new(vp)
    	@title.fixed_width = 250
    	@title.icon = $cache.icon("items/map")
    	@title.text = "Active Quests:"
    	add(@title,12,13)
    	
    	move(10,410)

	end

	def dispose
		@window.dispose
		@title.dispose
	end

	def update
		@window.update
	end

	def change


	end

end