
class Spark < Sprite

	def initialize(fx,vp)
		super(vp)

		self.bitmap = $cache.menu("Sparks/#{fx}")

		@total_frames = fx.split(".")[1].to_i
		@total_frames -= 1

		@frame = 1

		# No frame per row

		self.opacity = 25

		@delay = 2

		@next = 0

		# Can fade out when done
		@fade_out = true

		update

	end

	def width
		return self.bitmap.width / 5
	end

	def height
		return self.bitmap.width / 5
	end

	def done?
		return false if @fade_out && self.opacity > 0
		return @frame == @total_frames
	end

	def update

		# Step counters
		@next -= 1
		if @next < 1
			@next = @delay

			@frame += 1

			@frame = @total_frames if @frame > @total_frames

			self.opacity -= 15 if @total_frames == @frame

			fx = @frame % 5 # frames_per_row
			fy = @frame / 5



			# Refresh
			
			self.src_rect = Rect.new(fx*width,fy*height,width,height)


		end

	end

end