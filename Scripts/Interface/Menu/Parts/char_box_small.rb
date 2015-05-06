

class Char_Box_Small < SpriteGroup

	def initialize(vp)

		super()

		@window = Box.new(vp,130,84)
		@window.skin = $cache.menu_common("skin")
		@window.wallpaper = $cache.menu_wallpaper("portback")
		add(@window)

		@port = Sprite.new(vp)
		@port.bitmap = $cache.menu_face_small("boy")
		add(@port,31,-15)

		@gradient = Sprite.new(vp)
		@gradient.bitmap = $cache.menu_common("charbox-gradient-small")
		@gradient.opacity = 160
		add(@gradient,5,30)



		@xp_bar = Bar.new(vp,106,8)
		add(@xp_bar,11,64)

		@xp_label = Sprite.new(vp)
		@xp_label.bitmap = $cache.menu_char("label-rp")
		@xp_label.opacity = 200
		add(@xp_label,12,56)

	end

	def dispose
		@window.dispose
		#@gradient.dispose
		#@port.dispose
	end

	def setup(char)

	end

end