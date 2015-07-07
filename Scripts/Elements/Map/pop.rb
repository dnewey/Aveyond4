
class Pop < Sprite

	def initialize(ein,eout,vp)
		super(vp)

		anim_seq = seq()

		case ein

			when :fade
				self.opacity = 0
				#anim_seq.push(set("opacity",0))
				anim_seq.push(go("opacity",255,500,:qio))

			when :blast
				self.zoom_x = 1
				self.zoom_y = 0
				#anim_seq.push(para(go("zoom_x",1,500,:bounce_io),go("zoom_y",1,500,:bounce_io)))
				anim_seq.push(go("zoom_y",1,700,:bounce_o))

		end

		anim_seq.push(delay(1000))

		case eout

			when :fade
				anim_seq.push(go("opacity",-255,500,:qio))

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

	def number=(num)

		# prepare number data
	    data = num.to_i.to_s.split(//)
	    nums = []
	    data.each{ |n| nums.push(n.to_i) }

	    # build the gfx of this number
	    src = $cache.numbers('pop_18')
	    cw = src.width/10
	    ch = src.height

	    # Colors
	    colors = [:yellow,:orange,:purple,:green,:red,:gray,:white]
	    ic = 0#colors.index(color)
	    
	    # prepare the final image
	    width = 0
	    nums.each{ |n| width+=cw*0.75 }
	    bmp = Bitmap.new(width,ch)
	    c = 0

	    nums.each{ |n|

	      s = n * cw

	      bmp.blt(c,0,src,Rect.new(s,ic*ch,cw,ch))
	      c += cw*0.65

	    }

	    self.bitmap = bmp
	    
		self.ox = width/2
		self.oy = height/2 

	end


end