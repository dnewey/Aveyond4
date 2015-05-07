
# Spawn and manage weather particles

class Particle < Sprite

  attr_accessor :mx, :my, :sx, :sy
  
end

class Weather

	def initialize(vp)

		@stars = []
	    (1..15).each{ |s|
	      s = Particle.new(vp)
	      s.bitmap = $cache.particle(['yellow','blue'].sample)
	      @stars.push(s)
	      s.sx = rand(640)
	      s.sy = rand(480)
	      s.mx = rand
	      s.my = rand
	      s.x = s.sx
	      s.y = s.sy
	      s.opacity = 70 + rand(100)
	    }

	end

	def update

		@stars.each{ |s|
	      s.sx += s.mx * (0.5+rand)
	      s.sy += s.my * (0.5+rand)
	      s.x = s.sx
	      s.y = s.sy
	      
	      if s.x > 660 || s.y > 500
	        s.mx = rand
	        s.my = rand
	        if rand > 0.5
	          s.sx = rand(480)
	          s.sy = -100 + rand(50)
	        else
	          s.sx = -100 + rand(50)
	          s.sy = rand(320)
	        end
	        s.opacity = 70 + rand(100)
	      end		      
		}

	end

end