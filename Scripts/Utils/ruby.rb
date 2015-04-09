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