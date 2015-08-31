
class Info_Box < SpriteGroup

	attr_accessor :title

	def initialize(vp)
		super()		

		@window = Box.new(vp,190,56)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.wallpaper = $cache.menu_wallpaper("diamonds")
    	add(@window)

    	@gold = Label.new(vp)
    	@gold.font = $fonts.pop_text
    	@gold.icon = $cache.icon("misc/coins")
    	@gold.text = "#{$party.gold}G"
    	add(@gold,12,15)

    	@magics = Label.new(vp)
    	@magics.font = $fonts.pop_text
    	@magics.icon = $cache.icon("misc/magics")
    	@magics.text = "#{$party.magics}"
    	add(@magics,100,15)

    	# @zone = Label.new(vp)
    	# @zone.font = $fonts.pop_text
    	# @zone.icon = $cache.icon("items/map")
    	# @zone.text = "Whisper Woods"
    	# add(@zone,100,15)
    	
    	move(15,416)

	end

	def dispose
		@window.dispose
		@gold.dispose
		@magics.dispose
		#@zone.dispose
	end

	def update
		@window.update
	end

end
