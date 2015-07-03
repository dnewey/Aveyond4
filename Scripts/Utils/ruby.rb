 class Array
 	def count
 		return length
 	end
 	def sample(n=nil)
    if n != nil
      result = []
      data = shuffle
      n.times{
        next if data.empty?
        result.push(data.shift)
      }
      return result      
    else
      self[rand(length)]
    end
      #
  end
  def shuffle
    return self.sort_by { rand }
  end
 end

 class String
  def is_integer?
    self.to_i.to_s == self
  end
  def numeric?
    return true if self =~ /\A\d+\Z/
    true if Float(self) rescue false
  end
  def to_b
    return self == "true"
  end
end

class FalseClass; def to_i; 0 end end
class TrueClass; def to_i; 1 end end


class Fixnum
	def odd?
		return self % 2 == 1
	end
  def include?(a)
    false
  end
end

