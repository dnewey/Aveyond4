

class Char_Box_Small < SpriteGroup

	attr_accessor :box

	def initialize(vp,char)

		super()

		@char = $party.get(char)

		@box = Box.new(vp,132,87)
		@box.skin = $cache.menu_common("skin")
		@box.wallpaper = $cache.menu_wallpaper(char)
		add(@box)

		@port = Sprite.new(vp)
		@port.bitmap = $cache.face_small(char)
		add(@port,123-@port.width,80-@port.height)
		@port.z += 50

		@gradient = Sprite.new(vp)
		@gradient.bitmap = $cache.menu_common("charbox-gradient-small")
		#@gradient.opacity = 10
		add(@gradient,7,46)
		@gradient.z += 50

		@name = Label.new(vp)
	    @name.font = $fonts.list
	    @name.shadow = $fonts.list_shadow
	    @name.gradient = true
	    @name.text = @char.name
	    add(@name,6,4)
	    @name.z += 50

		@level = Label.new(vp)
	    @level.font = $fonts.list
	    @level.shadow = $fonts.list_shadow
	    @level.gradient = true
	    @level.text = @char.level.to_s
	    add(@level,20,27)
	    @level.z += 50


		@xp_bar = Bar.new(vp,106,8)
		add(@xp_bar,11,64)
		@xp_bar.opacity = 180
		@xp_bar.value = @char.xp
		@xp_bar.max = @char.next_exp
		@xp_bar.for(:xp)
		@xp_bar.z += 50

		@xp_label = Sprite.new(vp)
		@xp_label.bitmap = $cache.menu_char("label-xp")
		@xp_label.opacity = 200
		add(@xp_label,12,56)
		@xp_label.z += 50

		@xp_value = Sprite.new(vp)
		@xp_value.bitmap = build_value_bmp(@char.xp)
		@xp_value.opacity = 200
		add(@xp_value,186-@xp_value.bitmap.width,141)
		@xp_value.z += 50

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

	def select
		#$tweens.clear(self)
		@port.do(go("oy",3,100,:qio))
		@box.flash_light
	end

	def deselect
		#$tweens.clear(self)
		@port.do(to("oy",0,-1))
	end

end