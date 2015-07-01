
# Actor view, show portrait, hp etc

class CharView < SpriteGroup

	attr_reader :box, :port

	def initialize(vp,char,id)

		super()

		@battler = char

		@box = Box.new(vp)
		@box.skin = $cache.menu_common("skin-plain")
    	@box.wallpaper = $cache.menu_wallpaper("back2")
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
		add(@hp_bar,11,118)

		@hp_label = Sprite.new(vp)
		@hp_label.bitmap = $cache.menu_char("label-hp")
		@hp_label.opacity = 200		
		add(@hp_label,12,110)

		@hp_value = Sprite.new(vp)
		@hp_value.bitmap = build_value_bmp(rand*1000)
		@hp_value.opacity = 200
		add(@hp_value,140-@hp_value.bitmap.width,111)
		@hp_value.z += 50


		@mp_bar = Bar.new(vp,130,8)
		add(@mp_bar,11,100)

		@mp_label = Sprite.new(vp)
		@mp_label.bitmap = $cache.menu_char("label-mp")
		@mp_label.opacity = 200
		add(@mp_label,12,92)

		@mp_value = Sprite.new(vp)
		@mp_value.bitmap = build_value_bmp(rand*1000)
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
		end		

	end

	def update

		@box.update
		@hp_bar.update
		@mp_bar.update

		#@hp_text.text = @battler.hp
		@hp_bar.value = @battler.hp
		@hp_bar.max = @battler.maxhp

		# If a state, change background
		if @battler.state?('power')
			@box.wallpaper = $cache.menu_wallpaper("lightning")
		end

	end

	def grin
		@port.bitmap = $cache.face_battle(@battler.id+'-h')
	end

end