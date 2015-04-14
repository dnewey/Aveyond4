class Bitmap

	def fill(color)
		self.fill_rect(0,0,self.width,self.height,color)
	end

	# xp windowskin style
	def windowskin(skin)
		src = Cache.windowskin(skin)
		dest = rect.dup
		dest.x += 3
		dest.y += 3
		dest.width -= 6
		dest.height -= 6
		stretch_blt(dest,src,Rect.new(0,0,128,128),210)

		w = 16
		h = 16
		sx = 128
		sy = 0

		o = 255

		# CORNERS
	    blt(0,0,src,Rect.new(sx,sy,w,h),o) # top left
	    blt(width-w,0,src,Rect.new(sx+48,sy,w,h),o) # top right
	    blt(0,height-h,src,Rect.new(sx,sy+48,w,h),o) # bottom left
	    blt(width-w,height-h,src,Rect.new(sx+48,sy+48,w,h),o) # bottom right
	    
	    #dest_rect, bmp, src_rect

	   #  # Middle
	   #stretch_blt(Rect.new(w,h,width-16,height-16),src,Rect.new(sx+16,0,w,h),o)

	   #  # left side
	   stretch_blt(Rect.new(0,h,w,height-32),src,Rect.new(sx,h+16,w,h),o)

	   #  # Right
	     stretch_blt(Rect.new(width-w,h,w,height-32),src,Rect.new(sx+48,h,w,h),o)

	   #  #top
	   stretch_blt(Rect.new(w,0,width-32,h),src,Rect.new(sx+16,0,w,h),o)

	   # #bottom
	   stretch_blt(Rect.new(w,height-h,width-32,h),src,Rect.new(sx+16,h+32,w,h),o)


	end

	def borderskin(gfx = "Common/skin")

		src = Cache.menu(gfx)

		# 32px corners, 64px edges

		w = 32
		h = 32

		# CORNERS
	    blt(0,0,src,Rect.new(0,0,w,h)) # top left
	    blt(width-w,0,src,Rect.new(96,0,w,h)) # top right

	    blt(0,height-h,src,Rect.new(0,96,w,h)) # bottom left
	    blt(width-w,height-h,src,Rect.new(96,96,w,h)) # bottom right
	    
	   # left side
	   stretch_blt(Rect.new(0,h,w,height-64),src,Rect.new(0,h+16,w,h))

	   # Right
	   stretch_blt(Rect.new(width-w,h,w,height-64),src,Rect.new(96,h,w,h))

	   # top
	   stretch_blt(Rect.new(w,0,width-64,32),src,Rect.new(32,0,64,32))

	   # bottom
	   stretch_blt(Rect.new(w,height-h,width-64,32),src,Rect.new(32,96,64,32))

	end

	def skin(src)
		
		w = src.width/3
		h = src.height/3


		# Inside
		dest = Rect.new(w,h,width-w,height-h)
		srect = Rect.new(w,h,w,h)
		stretch_blt(dest,src,srect)
    	
		# CORNERS
	    blt(0,0,src,Rect.new(0,0,w,h)) # top left
	    blt(width-w,0,src,Rect.new(w*2,0,w,h)) # top right

	    blt(0,height-h,src,Rect.new(0,h*2,w,h)) # bottom left
	    blt(width-w,height-h,src,Rect.new(w*2,h*2,w,h)) # bottom right
	    
	   # left side
	   stretch_blt(Rect.new(0,h,w,height-h),src,Rect.new(0,w,w,h))

	   # Right
	   stretch_blt(Rect.new(width-w,h,w,height-h),src,Rect.new(w*2,h,w,h))

	   # top
	   stretch_blt(Rect.new(w,0,width-w,h),src,Rect.new(w,0,w,h))

	   # bottom
	   stretch_blt(Rect.new(w,height-h,width-w,h),src,Rect.new(w,h*2,w,h))




	end

	def vskin(src)
		size = src.height/3
    	blt(0,0,src,Rect.new(0,0,src.width,size)) # top left
    	blt(0,height-size,src,Rect.new(0,size*2,src.width,size)) # bottom right    
    	stretch_blt(Rect.new(0,size,size,height-size),src,Rect.new(0,size,src.width,size))
	end

	def hskin(src)
		size = src.width/3
    	blt(0,0,src,Rect.new(0,0,size,src.height)) #left
    	blt(width-size,0,src,Rect.new(size*2,0,size,src.height)) # bottom right    
    	stretch_blt(Rect.new(size,0,width-size*2,src.height),src,Rect.new(size,0,size,src.height))
	end

end
