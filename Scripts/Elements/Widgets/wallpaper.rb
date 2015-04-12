

class Wallpaper < Sprite

	# Doesn't have to be viewport tbh

	def initialize(w,h,src,vp)

		super(vp)

		@src = src

		@width = w
		@height = h

		self.bitmap = Bitmap.new(w,h)

		@px = 0.0
		@py = 0.0

		@dx = 0  # Diplay x, integer
		@dy = 0

		@sx = 0.2
		@sy = 0.2

		redraw

	end

	def width() return @width end
	def height() return @height end

	def resize(w,h)
		@width = w
		@height = h
		self.bitmap = Bitmap.new(w,h)
		redraw
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

		cx = -@dx
		cy = -@dy

		while cx < @width

			while cy < @height

				rct = @src.rect
				# If draw's over, cancel
				# Also for offset for first

				self.bitmap.blt(cx,cy,@src,rct)

				cy += @src.height

			end

			cy = -@dy
			cx += @src.width
			#log_info("DRAW #{cx}")

		end

	end

end