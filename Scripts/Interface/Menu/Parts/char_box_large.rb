

class Char_Box_Large < SpriteGroup

	attr_accessor :box

	def initialize(vp,char)

		super()

		@char = $party.get(char)

		@box = Box.new(vp,205,168)
		@box.skin = $cache.menu_common("skin")
		@box.wallpaper = $cache.menu_wallpaper(char)
		add(@box)

		@port = Sprite.new(vp)
		@port.bitmap = $cache.face_large(char)
		#@port.src_rect.width = 155
		add(@port,205-@port.width-9,168-@port.height-8)
		@port.z += 50

		@gradient = Sprite.new(vp)
		@gradient.bitmap = $cache.menu_common("charbox-gradient")
		@gradient.opacity = 160
		add(@gradient,9,100)
		@gradient.z += 50

		@name = Sprite.new(vp)
	    @name.bitmap = $cache.menu_char(char)
	    add(@name,11,12)
	    @name.z += 50
	    #@name.opacity = 100

		@lvl_label = Sprite.new(vp)
		@lvl_label.bitmap = $cache.menu_char("label-lv")
		@lvl_label.opacity = 200
		add(@lvl_label,20,41)
		@lvl_label.z += 50

		@lvl_value = Sprite.new(vp)
		@lvl_value.bitmap = build_value_bmp(@char.level)
		@lvl_value.opacity = 200
		add(@lvl_value,40,40)
		@lvl_value.z += 50


		@mp_bar = Bar.new(vp,180,9)
		add(@mp_bar,11,112)
		@mp_bar.opacity = 180
		@mp_bar.for(:mp)
		@mp_bar.value = @char.mp
		@mp_bar.max = @char.maxmp
		@mp_bar.z += 50

		@mp_label = Sprite.new(vp)
		@mp_label.bitmap = $cache.menu_char("label-mp")
		@mp_label.opacity = 200
		add(@mp_label,12,105)
		@mp_label.z += 50

		@mp_value = Sprite.new(vp)
		@mp_value.bitmap = build_value_bmp(@char.mp)
		@mp_value.opacity = 200
		add(@mp_value,186-@mp_value.bitmap.width,105)
		@mp_value.z += 50

		case char
			when 'boy'
				@mp_label.bitmap = $cache.menu_char("label-sp")
				@mp_bar.for(char)
			when 'ing'
				@mp_bar.for(char)
			when 'phy'
				@mp_label.bitmap = $cache.menu_char("label-rp")
				@mp_bar.for(char)
			else
				@mp_bar.hide
				@mp_label.hide
				@mp_value.hide
		end


		@hp_bar = Bar.new(vp,180,9)
		add(@hp_bar,11,130)
		@hp_bar.opacity = 180
		@hp_bar.value = @char.hp
		@hp_bar.max = @char.maxhp
		@hp_bar.for(:hp)
		@hp_bar.z += 50

		@hp_label = Sprite.new(vp)
		@hp_label.bitmap = $cache.menu_char("label-hp")
		@hp_label.opacity = 200
		add(@hp_label,12,123)
		@hp_label.z += 50

		@hp_value = Sprite.new(vp)
		@hp_value.bitmap = build_value_bmp(@char.hp)
		@hp_value.opacity = 200
		add(@hp_value,186-@hp_value.bitmap.width,123)
		@hp_value.z += 50

		@xp_bar = Bar.new(vp,180,9)
		add(@xp_bar,11,148)
		@xp_bar.opacity = 180
		@xp_bar.value = @char.xp
		@xp_bar.max = @char.next_exp
		@xp_bar.for(:xp)
		@xp_bar.z += 50

		@xp_label = Sprite.new(vp)
		@xp_label.bitmap = $cache.menu_char("label-xp")
		@xp_label.opacity = 200
		add(@xp_label,12,141)
		@xp_label.z += 50

		@xp_value = Sprite.new(vp)
		@xp_value.bitmap = build_value_bmp(@char.xp)
		@xp_value.opacity = 200
		add(@xp_value,186-@xp_value.bitmap.width,141)
		@xp_value.z += 50

	end

	def dispose
		@box.dispose
		@gradient.dispose
		@port.dispose
	end

	def update
		@box.update
	end

	def choose()

	end

	def select
		#$tweens.clear(self)
		@port.do(go("oy",6,100,:qio))
		@box.flash_light
	end

	def deselect
		#$tweens.clear(self)
		@port.do(to("oy",0,-2))
	end

end