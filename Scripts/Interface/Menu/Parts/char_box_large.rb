

class Char_Box_Large < SpriteGroup

	def initialize(vp)

		super()

		@window = Box.new(vp,205,160)
		@window.skin = $cache.menu_common("skin")
		@window.wallpaper = $cache.menu_wallpaper("portback")
		add(@window)

		@gradient = Sprite.new(vp)
		@gradient.bitmap = $cache.menu_common("charbox-gradient")
		@gradient.opacity = 90
		add(@gradient,2,50)

		@port = Sprite.new(vp)
		@port.bitmap = $cache.menu_char("boy")
		add(@port,48,15)

	end

	def setup(char)

	end

end