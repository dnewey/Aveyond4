
class Info_Box < SpriteGroup

	attr_accessor :title

	def initialize(vp)
		super()		

		@window = Box.new(vp,150,60)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.wallpaper = $cache.menu_wallpaper("diamonds")
    	add(@window)

    	@gold = Label.new(vp)
    	@gold.font = $fonts.pop_text
    	@gold.icon = $cache.icon("misc/coins")
    	@gold.text = "250G"
    	add(@gold,12,15)

    	# @zone = Label.new(vp)
    	# @zone.font = $fonts.pop_text
    	# @zone.icon = $cache.icon("items/map")
    	# @zone.text = "Whisper Woods"
    	# add(@zone,100,15)
    	
    	move(15,413)

	end

	def dispose
		@window.dispose
		@gold.dispose
		#@zone.dispose
	end

	def update
		@window.update
	end

	def change


	end

end
