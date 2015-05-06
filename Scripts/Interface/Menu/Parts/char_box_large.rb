

class Char_Box_Large < SpriteGroup

	def initialize(vp)

		super()

		@window = Box.new(vp,205,160)
		@window.skin = $cache.menu_common("skin")
		@window.wallpaper = $cache.menu_wallpaper("portback")
		add(@window)

		@port = Sprite.new(vp)
		@port.bitmap = $cache.menu_face("boy")
		@port.src_rect.width = 155
		add(@port,42,-30)

		@gradient = Sprite.new(vp)
		@gradient.bitmap = $cache.menu_common("charbox-gradient")
		@gradient.opacity = 160
		add(@gradient,2,50)




		@mp_bar = Bar.new(vp,180,8)
		add(@mp_bar,11,102)

		@mp_label = Sprite.new(vp)
		@mp_label.bitmap = $cache.menu_char("label-mp")
		@mp_label.opacity = 200
		add(@mp_label,12,94)


		@hp_bar = Bar.new(vp,180,8)
		add(@hp_bar,11,120)

		@hp_label = Sprite.new(vp)
		@hp_label.bitmap = $cache.menu_char("label-hp")
		@hp_label.opacity = 200
		add(@hp_label,12,112)


		@xp_bar = Bar.new(vp,180,8)
		add(@xp_bar,11,138)

		@xp_label = Sprite.new(vp)
		@xp_label.bitmap = $cache.menu_char("label-rp")
		@xp_label.opacity = 200
		add(@xp_label,12,130)



	end

	def dispose
		@window.dispose
		@gradient.dispose
		@port.dispose
	end

	def setup(char)

	end

end