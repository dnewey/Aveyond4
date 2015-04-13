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

	def within?(x,y)
		return false if x < self.x
		return false if y < self.y
		return false if x > self.x + width
		return false if y > self.y + height
		return true
	end

end