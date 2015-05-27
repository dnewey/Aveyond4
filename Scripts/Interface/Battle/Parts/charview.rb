
# Actor view, show portrait, hp etc

class CharView < SpriteGroup

	def initialize(vp,char,id)

		super()

		@battler = char

		@box = Box.new(vp)
		@box.skin = $cache.menu_common("skin-plain")
    	@box.wallpaper = $cache.menu_wallpaper("back2")
		@box.resize(153,135)
		add(@box)   

		@port = Sprite.new(vp)
		@port.bitmap = $cache.menu_char("boy")
		add(@port,34,-20)

		@shadow = Sprite.new(vp)
		@shadow.bitmap = $cache.menu_char("battlehud-shadow")
		add(@shadow,6,74)

		@xform = Sprite.new(vp)
		@xform.bitmap = $cache.menu_char("Transforms/frog") if rand(10) > 3
		add(@xform,15,65)

		# Health
		#bars

		@hp_bar = Bar.new(vp,110,8)
		add(@hp_bar,11,118)

		@hp_label = Sprite.new(vp)
		@hp_label.bitmap = $cache.menu_char("label-hp")
		@hp_label.opacity = 200
		add(@hp_label,12,110)

		@hp_text = Label.new(vp)
		@hp_text.font = $fonts.hud_hp
		@hp_text.text = 23
		add(@hp_text,120,110)

		@mp_bar = Bar.new(vp,110,8)
		add(@mp_bar,11,100)

		@mp_label = Sprite.new(vp)
		@mp_label.bitmap = $cache.menu_char("label-mp")
		@mp_label.opacity = 200
		add(@mp_label,12,92)

	end

	def update

		@box.update
		@hp_bar.update
		@mp_bar.update

		@hp_text.text = @battler.hp
		@hp_bar.value = @battler.hp
		@hp_bar.max = @battler.maxhp

	end

end