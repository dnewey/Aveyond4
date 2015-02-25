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

class Bitmap

	def fill(color)
		self.fill_rect(0,0,self.width,self.height,color)
	end

end