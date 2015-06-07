

class Char_Box_Large < SpriteGroup

	attr_accessor :box

	def initialize(vp,char)

		super()

		@box = Box.new(vp,205,168)
		@box.skin = $cache.menu_common("skin")
		@box.wallpaper = $cache.menu_wallpaper("lightning")
		add(@box)

		@port = Sprite.new(vp)
		@port.bitmap = $cache.face_large(char)
		#@port.src_rect.width = 155
		add(@port,205-@port.width-9,168-@port.height-8)
		@port.z += 50

		@gradient = Sprite.new(vp)
		@gradient.bitmap = $cache.menu_common("charbox-gradient")
		@gradient.opacity = 160
		add(@gradient,2,55)
		@gradient.z += 50


		@mp_bar = Bar.new(vp,180,8)
		add(@mp_bar,11,112)
		@mp_bar.z += 50

		@mp_label = Sprite.new(vp)
		@mp_label.bitmap = $cache.menu_char("label-mp")
		@mp_label.opacity = 200
		add(@mp_label,12,104)
		@mp_label.z += 50

		@hp_bar = Bar.new(vp,180,8)
		add(@hp_bar,11,130)
		@hp_bar.z += 50

		@hp_label = Sprite.new(vp)
		@hp_label.bitmap = $cache.menu_char("label-hp")
		@hp_label.opacity = 200
		add(@hp_label,12,122)
		@hp_label.z += 50

		@xp_bar = Bar.new(vp,180,8)
		add(@xp_bar,11,148)
		@xp_bar.z += 50

		@xp_label = Sprite.new(vp)
		@xp_label.bitmap = $cache.menu_char("label-rp")
		@xp_label.opacity = 200
		add(@xp_label,12,140)
		@xp_label.z += 50



	end

	def dispose
		@box.dispose
		@gradient.dispose
		@port.dispose
	end

	def update
		@box.update
	end

	def setup(char)

	end

end