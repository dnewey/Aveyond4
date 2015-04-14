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

