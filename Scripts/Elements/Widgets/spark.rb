
class Spark < Sprite

	def initialize(fx,vp)
		super(vp)

		self.bitmap = $cache.menu("Sparks/#{fx}")

		@frame = -1

		# No frame per row

		@delay = 1
		@next = 0

		update



	end

	def width
		return self.bitmap.width / 5
	end

	def height
		return self.bitmap.width / 5
	end

	def update

		# Step counters
		@next -= 1
		if @next < 1
			@next = @delay

			@frame += 1

			fx = @frame % 5 # frames_per_row
			fy = @frame / 5

			# Refresh
			
			self.src_rect = Rect.new(fx*width,fy*height,width,height)


		end

	end

end