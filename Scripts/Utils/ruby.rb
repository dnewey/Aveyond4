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
end