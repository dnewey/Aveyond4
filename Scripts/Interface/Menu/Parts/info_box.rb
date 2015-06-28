
class Info_Box < SpriteGroup

	attr_accessor :title

	def initialize(vp)
		super()		

		@window = Box.new(vp,300,60)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.wallpaper = $cache.menu_wallpaper("diamonds")
    	add(@window)

    	@gold = Label.new(vp)
    	@gold.font = $fonts.pop_type
    	@gold.icon = $cache.icon("misc/coins")
    	@gold.text = "250G"
    	add(@gold,12,8)

    	@zone = Label.new(vp)
    	@zone.font = $fonts.pop_type
    	@zone.icon = $cache.icon("misc/coins")
    	@zone.text = "Whisper Woods"
    	add(@zone,100,8)
    	
    	move(15,413)

	end

	def dispose
		@window.dispose
		@gold.dispose
		@zone.dispose
	end

	def update
		@window.update
	end

	def change


	end

end
