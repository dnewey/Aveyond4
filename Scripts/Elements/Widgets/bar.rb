

def build_value_bmp(num)

	# prepare number data
    data = num.to_i.to_s.split(//)
    nums = []
    data.each{ |n| nums.push(n.to_i) }

    # build the gfx of this number
    src = $cache.menu_common("stat-nums")
    cw = src.width/10
    ch = src.height#/7

    # prepare the final image
    width = 0
    nums.each{ |n| width+=cw*0.75 }
    bmp = Bitmap.new(width,ch)
    c = 0

    nums.each{ |n|

      s = n * cw

      bmp.blt(c,0,src,Rect.new(s,0,cw,ch))
      c += cw*0.65

    }

    return bmp

end

class Bar < Sprite

	attr_accessor :value, :max

	def initialize(vp,w,h)

		super(vp)

		
		@value = 100
		@drawn = @value

		@target = @value
		@max = 1.0

		@width = w
		@height = h

		@base_color = Color.new(46,46,46,200)
		@ghost_color = Color.new(0,255,0,50)
		@bar_color = Color.new(0,255,0,255)

		@border = Color.new(255,255,255,255)
		#@border = Color.new(0,0,0,150)

		self.bitmap = Bitmap.new(w,h)

		redraw

	end

	def for(which)
		case which
			when :hp
				@ghost_color = Color.new(255,87,38,50)
				@bar_color = Color.new(255,87,38,255)
			when :xp
				@ghost_color = Color.new(44,178,34,50)
				@bar_color = Color.new(44,178,34,255)
			when 'boy'
				@ghost_color = Color.new(102,31,232,50)
				@bar_color = Color.new(102,31,232,255)
			when 'ing','hib',:mp
				@ghost_color = Color.new(52,75,252,50)
				@bar_color = Color.new(52,75,252,255)
			when 'phy'
				@ghost_color = Color.new(232,31,50,50)
				@bar_color = Color.new(232,31,50,255)
		end
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

		# Draw border
		if @border
			self.bitmap.fill_rect(0,0,@width,1,@border)
			self.bitmap.fill_rect(0,@height-1,@width,1,@border)
			self.bitmap.fill_rect(0,1,1,@height-2,@border)
			self.bitmap.fill_rect(@width-1,1,1,@height-2,@border)
		end

	end

end