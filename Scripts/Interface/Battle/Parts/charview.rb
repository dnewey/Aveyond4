
# Actor view, show portrait, hp etc

class CharView < SpriteGroup

	def initialize(vp,char,id)

		super()

		@box = Box.new(vp)
		@box.skin = Cache.menu("Common/skin-plain")
    	@box.wallpaper = Cache.menu("Common/back2")
		@box.resize(153,135)
		add(@box)   

		@port = Sprite.new(vp)
		@port.bitmap = Cache.menu("Char/boy")
		add(@port,34,-20)

		@shadow = Sprite.new(vp)
		@shadow.bitmap = Cache.menu("charview-shadow")
		add(@shadow,6,74)

		@xform = Sprite.new(vp)
		@xform.bitmap = Cache.menu("charview-frog") if rand(10) > 3
		add(@xform,15,65)



		# Health
		#bars

		@hp_label = Sprite.new(vp)
		@hp_label.bitmap = Cache.menu("label-hp")
		add(@hp_label,8,112)



		@mp_label = Sprite.new(vp)
		@mp_label.bitmap = Cache.menu("label-mp")
		add(@mp_label,8,92)

	end

	def update

		@box.update

	end

end