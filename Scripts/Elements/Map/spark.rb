
class Spark < Sprite

	def initialize(fx,x,y,vp)
		super(vp)

		#self.zoom_x = 1.2
		#self.zoom_y = 1.2

		@reverse = false
		@idx = -1
		@next = 0

		# fx is database id, also gfx name
		# If not in database, use defaults

		self.bitmap = $cache.animation(fx)

		# Defaults
		@frames = 25
		@delay = 0

		@fade_out = true

		self.opacity = 122
		self.blend_type = 0

		@sound = nil
		@sound_delay = 0

		if $data.anims.has_key?(fx)

			anim = $data.anims[fx]
			@loop = true if anim.loop == "true"
			@frames = anim.frames
			@delay = anim.delay
			@fadeout = anim.fadeout
			self.opacity = anim.opacity
			case anim.order
				when 'below'
					self.z = 0
				when 'same'
				when 'above'
					self.z = 5000
			end

			@idx = anim.offset.to_i if anim.offset != nil

			#self.blend_type = anim.blend if anim.blend != nil

			# Split sound input
			if anim.sound != ''
				dta = anim.sound.split('=>')
				if dta.count > 1
					@sound_delay = dta[1].to_i
				end
				@sound = dta[0]
			end

		end

		self.center(x,y)
		
		update

	end

	def reverse
		@reverse = true
	end

	def width
		return self.bitmap.width / 5
	end

	def height
		return self.bitmap.width / 5
	end

	def done?
		return false if @fade_out && self.opacity > 0
		return @idx == @frames && !@loop
	end

	def update

		#self.ox = -$scene.map.display_x
    	#self.oy = -$scene.map.display_y

		# Step counters
		@next -= 1
		if @next < 1
			@next = @delay

			@idx += 1

			if @idx > @frames
				@loop ? @idx = 0 : @idx = @frames 
			end

			if @fadeout && !@loop
				self.opacity -= 30 if @idx >= @frames - 2
			end

			if @sound && @idx == @sound_delay
				sfx(@sound)
			end

			idx = @idx
			if @reverse
				idx = @frames - @idx
			end



			fx = idx % 5 # frames_per_row
			fy = idx / 5



			# Refresh
			
			self.src_rect = Rect.new(fx*width,fy*height,width,height)


		end

	end

end