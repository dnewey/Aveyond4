
class SpriteGroup

	def initialize
		@sprites = []
		@opacity = 255
		@x = 0
		@y = 0
	end

	def add(spr,ox=0,oy=0)
		@sprites.push([spr,ox,oy])
	end

	def move(spr,ox,oy)
		@sprites.each{ |s|
			if s[0] == spr
				s[1] = ox
				s[2] = oy
			end
		}
	end

	def x=(v)
		@x = v
		@sprites.each{ |s|
			s[0].x = v + s[1]
		}
	end
	def x
		return @x
	end

	def y=(v)
		@y = v
		@sprites.each{ |s|
			s[0].y = v + s[2]
		}
	end
	def y
		return @y
	end

	def opacity=(v)
		@opacity = v
		@sprites.each{ |s|
			s[0].opacity = v
		}
	end
	def opacity
		return @opacity
	end

end