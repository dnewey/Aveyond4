

class Bar < Sprite

	attr_accessor :value, :max

	def initialize(vp,w,h)

		super(vp)

		
		@value = 100
		@drawn = @value

		@target = @value
		@max = 100

		@width = w
		@height = h

		@base_color = Color.new(46,46,46,200)
		@ghost_color = Color.new(0,255,0,50)
		@bar_color = Color.new(0,255,0,255)

		self.bitmap = Bitmap.new(w,h)

		redraw

	end

	def update
		if @drawn != @value.to_i
			redraw
		end
	end

	def redraw

		@drawn = @value.to_i

		# Draw the 3 layers
		self.bitmap.clear
		self.bitmap.fill(@base_color)

		# Draw ghost
		if @target > @value
			gw = ((@target.to_f/@max) * @width).to_i
			self.bitmap.fill_rect(0,0,gw,@height,@ghost_color)
		end

		# Draw next
		vw = ((@value.to_f/@max) * @width).to_i
		self.bitmap.fill_rect(0,0,vw,@height,@bar_color)

	end

end