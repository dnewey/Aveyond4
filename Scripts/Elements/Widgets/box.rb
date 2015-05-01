
class Box 

	def initialize(vp,w=100,h=100)

		@wallpaper = Sprite.new(vp)
		@window = Sprite.new(vp)		

		@skin = nil
		@src = nil

		@width = w
		@height = h

		@alpha = 230		

		# Position
		@px, @py = 0.0, 0.0

		# Display position, integer
		@dx, @dy = 0, 0

		# Anim speed
		@sx = 0.2
		@sy = 0.2

	end

	def dispose
		@wallpaper.dispose
		@window.dispose
	end

	def skin=(bmp)
		@skin = bmp
		@window.bitmap = Bitmap.new(@width,@height)
		@window.bitmap.borderskin(@skin)
	end

	def wallpaper=(w)
		@src = w
		@wallpaper.bitmap = Bitmap.new(@width-8,@height-8)
		redraw
	end

	def color=(c)
		@color = c
		@wallpaper.bitmap = Bitmap.new(@width-8,@height-8)
		@wallpaper.bitmap.fill(c)
	end

	def opacity=(o)
		@wallpaper.opacity = o
		@window.opacity = o
	end

	def x=(v)
		@wallpaper.x = v+4
		@window.x = v
	end

	def y=(v)
		@wallpaper.y = v+4
		@window.y = v
	end

	def move(x,y)
		self.x = x
		self.y = y
	end

	def width() return @width end
	def height() return @height end

	def resize(w,h)
		@width = w
		@height = h
		@window.bitmap = Bitmap.new(w,h)
		@window.bitmap.borderskin(@skin)
		@wallpaper.bitmap = Bitmap.new(w-8,h-8)	
		if @src != nil	
			redraw
		else
			@wallpaper.bitmap.fill(@color)
		end
	end

	def update

		# Redraw the bmp if needed
		@px += @sx
		@py += @sy

		# Mod to width of bmp
		@px -= @src.width if @px > @src.width
		@px += @src.width if @px < -@src.width
		@py -= @src.height if @py > @src.height
		@py += @src.height if @py < @src.height		

		if @px.to_i != @dx || @py.to_i != @dy
			@dx = @px.to_i
			@dy = @py.to_i
			redraw
		end

	end

	def redraw

		@wallpaper.bitmap.clear

		cx = -@dx
		cy = -@dy

		while cx < @width

			while cy < @height

				rct = @src.rect
				# If draw's over, cancel
				# Also for offset for first

				@wallpaper.bitmap.blt(cx,cy,@src,rct,@alpha)

				cy += @src.height

			end

			cy = -@dy
			cx += @src.width
			#log_info("DRAW #{cx}")

		end

	end

end