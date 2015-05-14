


class Ui_Popper < SpriteGroup

	attr_accessor :title

	def initialize(vp)
		super()		

		@vp = vp

		# Resize to whatever is needed
		@window = Box.new(vp,300,54)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.wallpaper = $cache.menu_wallpaper("diamonds")
    	@window.scroll(0.2,0.2)
    	add(@window)

    	@before = Label.new(vp)
    	@before.font = $fonts.message
    	add(@before,16,10)

    	@after = Label.new(vp)
    	@after.font = $fonts.message
    	add(@after,106,10)

	end

	def center(x,y)
		move(x-@window.width/2,y+60)
	end

	def dispose

		self.sprites.each{ |s|
			s[0].dispose
		}

	end

	def update
		@window.update
	end

	def color=(c)
		@window.wallpaper = $cache.menu_wallpaper(c)
	end

	def setup(a,ia,b,ib)

		data = $data.items[id]

		@before.text = a
		@before.icon = ia
		
		@after.text = b
		@after.icon = ib


		tw = @before.width + @after.width

		@window.resize(tw+26,54)
		
		change(@after,@before.x + @before.width+10,10)

		center(320,230)

		# Launch sparks?
		#sprk = $scene.add_spark("redstar",420,300,@vp)
		#

		# Animate in
		self.opacity = 0
		self.do(go("opacity",255,250,:qio))
		self.do(seq(go("y",-15,100,:qio),go("y",40,300,:bounce_o)))


	end

end