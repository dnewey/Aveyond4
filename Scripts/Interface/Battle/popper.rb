

class Popper < Sprite

	attr_accessor :value

	def initialize(vp)
		super(vp)

		@value = 0
		@old_value = 0

		self.bitmap = Bitmap.new(200,50)
		self.bitmap.font = $fonts.namebox

		refresh

	end

	def update

		if @value != @old_value
			refresh
		end

	end

	def done?
		return self.opacity == 0
	end

	def refresh

		# Draw the value out!
		self.bitmap.clear
		self.bitmap.draw_text(0,0,200,50,@value.to_i.to_s,2)

	end

end