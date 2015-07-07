
# Actor view, show portrait, hp etc

class CharView < SpriteGroup

	attr_reader :box, :port

	def initialize(vp,char,id)

		super()

		@down = false
		@revert = false
		@revert_delay = 0

		@battler = char

		@box = Box.new(vp)
		@box.skin = $cache.menu_common("skin-plain")
    	@box.wallpaper = $cache.menu_wallpaper(char.id)
		@box.resize(153,135)
		add(@box)   

		@port = Sprite.new(vp)
		@port.bitmap = $cache.face_battle(char.id)
		add(@port,153-@port.width-10,135-@port.height-10)

		@shadow = Sprite.new(vp)
		@shadow.bitmap = $cache.menu_char("battlehud-shadow")
		add(@shadow,6,74)

		# @xform = Sprite.new(vp)
		# @xform.bitmap = $cache.menu_char("Transforms/frog") if rand(10) > 3
		# add(@xform,15,65)

		# Health
		#bars

		@hp_bar = Bar.new(vp,130,8)
		@hp_bar.for(:hp)
		#@hp_bar.value = @battler.hp_percent
		add(@hp_bar,11,118)

		@hp_label = Sprite.new(vp)
		@hp_label.bitmap = $cache.menu_char("label-hp")
		@hp_label.opacity = 200		
		add(@hp_label,12,110)

		@hp_value = Sprite.new(vp)
		@hp_value.bitmap = build_value_bmp(@battler.hp)
		@hp_value.opacity = 200
		add(@hp_value,140-@hp_value.bitmap.width,111)
		@hp_value.z += 50

		@mp_bar = Bar.new(vp,130,8)
		#@mp_bar.value = @battler.mp
		add(@mp_bar,11,100)

		@mp_label = Sprite.new(vp)
		@mp_label.bitmap = $cache.menu_char("label-mp")
		@mp_label.opacity = 200
		add(@mp_label,12,92)

		@mp_value = Sprite.new(vp)
		@mp_value.bitmap = build_value_bmp(@battler.mp)
		@mp_value.opacity = 200
		add(@mp_value,140-@mp_value.bitmap.width,93)
		@mp_value.z += 50


		# Show the right mana bar
		case @battler.id
			when 'boy','ing','hib','phy'
				@mp_bar.for(@battler.id)
			else
				@mp_label.hide
				@mp_bar.hide
				@mp_value.hide
		end		

	end

	def update

		@box.update
		@port.update


		@hp_bar.value = @battler.hp
		@mp_bar.value = @battler.mp

		@hp_bar.max = @battler.maxhp
		@mp_bar.max = @battler.maxmp

		@hp_value.bitmap = build_value_bmp(@battler.hp)
		@mp_value.bitmap = build_value_bmp(@battler.mp)

		@hp_bar.update
		@mp_bar.update

		if @revert && !@down
			@revert_delay -= 1
			if @revert_delay <= 0
				@revert = false
				@port.bitmap = $cache.face_battle(@battler.id)		
			end
		end

		# If a state, change background
		if @battler.state?('power')
			@box.wallpaper = $cache.menu_wallpaper("lightning")
		end

	end

	def level
		return if @down
		@port.bitmap = $cache.face_battle(@battler.id+'-x')
		@revert = true
		@revert_delay = 75
	end

	def grin
		return if @down
		@port.bitmap = $cache.face_battle(@battler.id+'-h')
		@revert = true
		@revert_delay = 75
		@port.flash(Color.new(240,230,50,150),20)
	end

	def damage
		return if @down
		@port.bitmap = $cache.face_battle(@battler.id+'-a')
		@revert = true
		@revert_delay = 75
		@port.flash(Color.new(240,0,0,150),20)
	end

	def win
		return if @down
		@port.bitmap = $cache.face_battle(@battler.id+'-h')
	end

	def down
		@down = true
		@port.bitmap = $cache.face_battle(@battler.id+'-d')
	end

	def revive
		@down = false
		@port.bitmap = $cache.face_battle(@battler.id)		
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