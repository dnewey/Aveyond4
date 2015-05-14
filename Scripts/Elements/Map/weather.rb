
# Spawn and manage weather particles

class Particle < Sprite

  attr_accessor :mx, :my, :sx, :sy
  
end

class Weather

end

class Weather_DarkDots

	def initialize(vp)

		@stars = []
	    (1..100).each{ |s|
	      s = Particle.new(vp)
	      s.bitmap = $cache.particle(['yellow','blue'].sample)
	      @stars.push(s)
	      s.sx = rand(-120+800)#rand(640)
	      s.sy = rand(-140+700)#rand(480)
	      s.mx = rand
	      s.my = rand
	      s.x = s.sx
	      s.y = s.sy
	      s.opacity = 70 + rand(100)
	    }

	end

	def update

		@stars.each{ |s|

		  s.ox = $map.display_x / 4
		  s.oy = $map.display_y / 4

	      s.sx += s.mx * (0.5+rand)
	      s.sy += s.my * (0.5+rand)
	      s.x = s.sx
	      s.y = s.sy
	      
	      if (s.x > 800 + ($map.display_x/4) || s.y > 720 + ($map.display_y/4)) ||
	      	s.x < -100 + ($map.display_x/4) || s.y < -100  + ($map.display_y/4)
	        s.mx = rand
	        s.my = rand
	        s.sx = rand(-120+500)
	        s.sy = rand(-140+350)
	        # if rand > 0.5
	        #   s.sx = rand(-120+750)
	        #   s.sy = -100 + rand(50)
	        # else
	        #   s.sx = -100 + rand(50)
	        #   s.sy = rand(-140+560)
	        # end
	        s.opacity = 70 + rand(100)
	      end		      
		}

	end

end