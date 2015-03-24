 class Array
 	def count
 		return length
 	end
 	def sample
      self[rand(length)]
  	end

 end

 class String
  def is_integer?
    self.to_i.to_s == self
  end
end

class FalseClass; def to_i; 0 end end
class TrueClass; def to_i; 1 end end

class Bitmap

	def fill(color)
		self.fill_rect(0,0,self.width,self.height,color)
	end

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

	def vert(src)
    	blt(0,0,src,Rect.new(0,0,src.width,10)) # top left
    	blt(0,height-10,src,Rect.new(0,src.height-10,src.width,10)) # bottom right
    
    	stretch_blt(Rect.new(0,10,10,height-20),src,Rect.new(0,10,10,10))
	end

end

class Fixnum
	def odd?
		return self % 2 == 1
	end
end

class Sprite
	def hide
		self.visible = false
	end
	def show
		self.visible = true
	end
	def move(x,y)
		self.x = x
		self.y = y
	end

	def width
		return self.bitmap.width
	end

	def height 
		return self.bitmap.height
	end
end