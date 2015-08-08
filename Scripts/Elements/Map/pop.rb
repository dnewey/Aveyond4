
class Pop < Sprite

	attr_accessor :anim_delay

	def initialize(ein,eout,vp)
		super(vp)

		@anim_in = ein
		@anim_out = eout
		@anim_delay = 800

	end

	def start

		anim_seq = seq()

		case @anim_in

			when :rise
				self.opacity = 0
				anim_seq.push(go("opacity",255,300,:qio))
				anim_seq.push(go("y",-20,1500,:qo))

			when :fall
				anim_seq.push(go("y",-5,100,:qio))
				anim_seq.push(go("y",25,450,:bounce_o))

			when :fade
				self.opacity = 0
				#anim_seq.push(set("opacity",0))
				anim_seq.push(go("opacity",255,500,:qio))

			when :blast
				self.zoom_x = 1
				self.zoom_y = 0
				#anim_seq.push(para(go("zoom_x",1,500,:bounce_io),go("zoom_y",1,500,:bounce_io)))
				anim_seq.push(go("zoom_y",1,700,:bounce_o))

			when :lower
				self.opacity = 200
				anim_seq.push(go("y",15,1050,:quad_in))

		end

		anim_seq.push(delay(@anim_delay))

		case @anim_out

			when :fade
				anim_seq.push(go("opacity",-255,500,:qio))

			when :fade_quick
				anim_seq.push(go("opacity",-255,350,:qio))

			when :blast
				#anim_seq.push(para(go("zoom_x",1,500,:bounce_io),go("zoom_y",1,500,:bounce_io)))
				anim_seq.push(go("zoom_y",-1,700,:bounce_i))				

		end

		self.do(anim_seq)

	end

	def icon=(ico)

		self.bitmap = $cache.icon(ico)

		self.ox = width/2
		self.oy = height/2

	end

	def number(num,color,suffix=nil)

		# prepare number data
	    data = num.to_i.to_s.split(//)
	    nums = []
	    data.each{ |n| nums.push(n.to_i) }


	    # Default to dmg color for now
	    #color = :dmg

	    # Colors
	    colors = [:dmg,:mp,:sp,:rp,:hp,:hp2]
	    ic = colors.index(color)


	    # build the gfx of this number
	    src = $cache.numbers('pops')
	    cw = src.width/10
	    ch = src.height/colors.count

	    # Char width is now custom, same as cx
	    offsets = [0,17,33,50,67,84,101,117,134,151]
	    widths = [16,16,16,16,17,16,16,16,15,16]
	    
	    # prepare the final image
	    width = 0
	    nums.each{ |n| width+=cw }

	    # Add suffix
	    if suffix != nil
	    	suff_bmp = $cache.numbers(suffix.to_s)
	    	width += suff_bmp.width
	    end

	    # Create the bmp
	    bmp = Bitmap.new(width,ch)
	    
	    # Cursor
	    c = 0

	    nums.each{ |n|

	      s = offsets[n]
	      cw = widths[n]

	      bmp.blt(c,0,src,Rect.new(s,ic*ch,cw,ch))
	      c += cw - 3

	    }

	    # Blt the suffix
	    if suffix != nil
	    	bmp.blt(width-suff_bmp.width-3,3,suff_bmp,suff_bmp.rect)
	    end

	    self.bitmap = bmp
	    
		self.ox = width/2
		self.oy = height/2 

	end

	def image(img)

		# For critical and that
		self.bitmap = $cache.numbers(img)
		self.ox = self.bitmap.width/2
		self.oy = self.bitmap.height/2

	end


end