

class Char_Box_Small < SpriteGroup

	attr_accessor :box

	def initialize(vp)

		super()

		@box = Box.new(vp,132,87)
		@box.skin = $cache.menu_common("skin")
		@box.wallpaper = $cache.menu_wallpaper("portback")
		add(@box)

		@port = Sprite.new(vp)
		@port.bitmap = $cache.face_small(["boy",'hib','row'].sample)
		add(@port,31,-10)
		@port.z += 50

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
		@box.dispose
		#@gradient.dispose
		#@port.dispose
	end

	def update
		@box.update
	end

	def setup(char)

	end

end