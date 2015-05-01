
class SpriteGroup

	def initialize
		@sprites = [] # [spr,ox,oy] -- maybe add opacity offset
		@opacity = 255
		@x = 0
		@y = 0
	end

	def update
		@sprites.each{ |s| s[0].update }
	end

	def add(spr,ox=0,oy=0)
		@sprites.push([spr,ox,oy])
	end

	def change(spr,ox,oy)
		@sprites.each{ |s|
			if s[0] == spr
				s[1] = ox
				s[2] = oy
			end
		}
	end

	def move(nx,ny)
		self.x = nx
		self.y = ny
	end

	def x=(v)
		@x = v
		@sprites.each{ |s| s[0].x = v + s[1] }
	end
	def x
		return @x
	end

	def y=(v)
		@y = v
		@sprites.each{ |s| s[0].y = v + s[2] }
	end
	def y
		return @y
	end

	def opacity=(v)
		@opacity = v
		@sprites.each{ |s| s[0].opacity = v }
	end
	def opacity
		return @opacity
	end

	def hide
		self.opacity = 0
	end

	def show
		self.opacity = 255
	end

end