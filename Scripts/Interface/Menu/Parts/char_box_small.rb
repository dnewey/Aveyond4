

class Char_Box_Small < SpriteGroup

	attr_accessor :box

	def initialize(vp,char)

		super()

		@char = $party.get(char)

		@box = Box.new(vp,132,87)
		@box.skin = $cache.menu_common("skin")
		@box.wallpaper = $cache.menu_wallpaper("portback")
		add(@box)

		@port = Sprite.new(vp)
		@port.bitmap = $cache.face_small(char)
		add(@port,123-@port.width,78-@port.height)
		@port.z += 50

		@gradient = Sprite.new(vp)
		@gradient.bitmap = $cache.menu_common("charbox-gradient-small")
		@gradient.opacity = 160
		add(@gradient,5,30)

		@name = Label.new(vp)
	    @name.font = $fonts.list
	    @name.shadow = $fonts.list_shadow
	    @name.gradient = true
	    @name.text = @char.name
	    add(@name,6,4)

		@level = Label.new(vp)
	    @level.font = $fonts.list
	    @level.shadow = $fonts.list_shadow
	    @level.gradient = true
	    @level.text = "15"
	    add(@level,20,27)

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