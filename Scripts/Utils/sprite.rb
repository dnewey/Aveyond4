# Extensions to sprite class

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

	def center(x,y)
		self.x = x - width/2
		self.y = y - height/2
	end

	def width
		return self.bitmap.width
	end

	def height 
		return self.bitmap.height
	end

	def within?(x,y,px=0,py=0)
		return false if x < self.x - px
		return false if y < self.y - py
		return false if x > self.x + width + px
		return false if y > self.y + height + py
		return true
	end

end