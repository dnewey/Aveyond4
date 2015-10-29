
# Spawn and manage weather particles

class Particle < Sprite

  attr_accessor :mx, :my, :sx, :sy, :opac
  
end

class Weather

end

class Weather_RainBroke

	def initialize(vp)

		@stars = []
	    (1..40).each{ |s|
	      s = Particle.new(vp)
	      s.bitmap = $cache.particle('rain')
	      @stars.push(s)
	      s.sx = $scene.map.display_x/4 + rand(640)
	      s.sy = $scene.map.display_y/4
	      s.mx = 0
	      s.my = rand * 2.5
	      s.x = s.sx
	      s.y = s.sy
	   	  s.opac = 150 + rand(100)
	      s.opacity = 250
	      # z = 1 + rand
	      # s.zoom_x = z
	      # s.zoom_y = z

	    }

	end

	def update

		@stars.each{ |s|

	      #s.sx += s.mx * (0.3+rand)
	      s.sy += 1#s.my * (0.3+rand)
	      #s.x = s.sx
	      s.y = s.sy
	      next
	      #s.opacity += 3 if s.opac > s.opacity
	      
	      if s.y > $scene.map.display_y/4 + 720

	        s.mx = rand
	        s.my = rand
	      	#s.sx = $scene.map.display_x/4 + rand(640) - 320
	      	s.sy = $scene.map.display_y/4
	        # if rand > 0.5
	        #   s.sx = rand(-120+750)
	        #   s.sy = -100 + rand(50)
	        # else
	        #   s.sx = -100 + rand(50)
	        #   s.sy = rand(-140+560)
	        # end
	        s.opac = 150 + rand(100)
	        s.opacity = 250
	      end		      
		}

	end

	def dispose

	end

end

class Weather_Rain

	def initialize(vp)

		@stars = []
	    (1..40).each{ |s|
	      s = Particle.new(vp)
	      s.bitmap = $cache.particle('rain')
	      @stars.push(s)
	      s.sx = $scene.map.display_x/4 + rand(640) - 200#-120+800)#rand(640)
	      s.sy = $scene.map.display_y/4 - rand(3080)#+ rand(480+240) - 240 #-140+700)#rand(480)
	      s.mx = rand * 0.5
	      s.my = (rand * 1.5) + 10
	      s.x = s.sx
	      s.y = s.sy
	   	  s.opac = 70 + rand(100)
	      s.opacity = 0
	      # z = 1 + rand
	      # s.zoom_x = z
	      # s.zoom_y = z

	    }

	end

	def update

		@stars.each{ |s|

	      #s.sx += s.mx * (0.3+rand)
	      s.sy += s.my #* (0.3+rand)
	      s.x = s.sx
	      s.y = s.sy

	      s.opacity += 3 if s.opac > s.opacity
	      
	      if s.x > $scene.map.display_x/4 + 860 || s.y > $scene.map.display_y/4+720 || s.x < $scene.map.display_x/4 - 320 || s.y < $scene.map.display_y/4 - 240
	        s.mx = rand
	        s.my = (rand * 2) + 6
	      	s.sx = $scene.map.display_x/4 + rand(640) - 200# - 320#-120+800)#rand(640)
	      	s.sy = $scene.map.display_y/4 - rand(3080) #-140+700)#rand(480)
	        # if rand > 0.5
	        #   s.sx = rand(-120+750)
	        #   s.sy = -100 + rand(50)
	        # else
	        #   s.sx = -100 + rand(50)
	        #   s.sy = rand(-140+560)
	        # end
	        s.opac = 10 + rand(40)
	        s.opacity = 0
	      end		      
		}

	end

	def dispose
		@stars.each{ |s| s.dispose }
	end

end

class Weather_DarkDots

	def initialize(vp)

		@stars = []
	    (1..30).each{ |s|
	      s = Particle.new(vp)
	      s.bitmap = $cache.particle(['yellow','blue'].sample)
	      @stars.push(s)
	      s.sx = $scene.map.display_x/4+ rand(640+220) - 320#-120+800)#rand(640)
	      s.sy = $scene.map.display_y/4+ rand(480+240) - 240 #-140+700)#rand(480)
	      s.mx = rand * 0.5
	      s.my = rand * 0.5
	      s.x = s.sx
	      s.y = s.sy
	   	  s.opac = 10 + rand(40)
	      s.opacity = 0
	      # z = 1 + rand
	      # s.zoom_x = z
	      # s.zoom_y = z

	    }

	end

	def update

		@stars.each{ |s|

	      s.sx += s.mx * (0.3+rand)
	      s.sy += s.my * (0.3+rand)
	      s.x = s.sx
	      s.y = s.sy

	      s.opacity += 3 if s.opac > s.opacity
	      
	      if s.x > $scene.map.display_x/4 + 860 || s.y > $scene.map.display_y/4+720 || s.x < $scene.map.display_x/4 - 320 || s.y < $scene.map.display_y/4 - 240
	        s.mx = rand
	        s.my = rand
	      	s.sx = $scene.map.display_x/4+ rand(640+320) - 320#-120+800)#rand(640)
	      	s.sy = $scene.map.display_y/4+ rand(480+240) - 240 #-140+700)#rand(480)
	        # if rand > 0.5
	        #   s.sx = rand(-120+750)
	        #   s.sy = -100 + rand(50)
	        # else
	        #   s.sx = -100 + rand(50)
	        #   s.sy = rand(-140+560)
	        # end
	        s.opac = 70 + rand(100)
	        s.opacity = 0
	      end		      
		}

	end

def dispose
		@stars.each{ |s| s.dispose }
	end

end

class Weather_FireDots

	def initialize(vp)

		@stars = []
	    (1..50).each{ |s|
	      s = Particle.new(vp)
	      s.bitmap = $cache.particle(['yellow','red'].sample)
	      @stars.push(s)
	      s.sx = $scene.map.display_x/4+ rand(640+220) - 320#-120+800)#rand(640)
	      s.sy = $scene.map.display_y/4+ rand(480+240) - 240 #-140+700)#rand(480)
	      s.mx = rand * 2.5
	      s.my = rand * 2.5
	      s.x = s.sx
	      s.y = s.sy
	   	  s.opac = 10 + rand(40)
	      s.opacity = 0
	      # z = 1 + rand
	      # s.zoom_x = z
	      # s.zoom_y = z

	    }

	end

	def update

		@stars.each{ |s|

	      s.sx += s.mx * (4.3+rand)
	      s.sy += s.my * (4.3+rand)
	      s.x = s.sx
	      s.y = s.sy

	      s.opacity += 3 if s.opac > s.opacity
	      
	      if s.x > $scene.map.display_x/4 + 860 || s.y > $scene.map.display_y/4+720 || s.x < $scene.map.display_x/4 - 320 || s.y < $scene.map.display_y/4 - 240
	        s.mx = rand
	        s.my = rand
	      	s.sx = $scene.map.display_x/4+ rand(640+320) - 320#-120+800)#rand(640)
	      	s.sy = $scene.map.display_y/4+ rand(480+240) - 240 #-140+700)#rand(480)
	        # if rand > 0.5
	        #   s.sx = rand(-120+750)
	        #   s.sy = -100 + rand(50)
	        # else
	        #   s.sx = -100 + rand(50)
	        #   s.sy = rand(-140+560)
	        # end
	        s.opac = 70 + rand(100)
	        s.opacity = 0
	      end		      
		}

	end

def dispose
		@stars.each{ |s| s.dispose }
	end

end

class Weather_LeafDots

	def initialize(vp)

		@stars = []
	    (1..30).each{ |s|
	      s = Particle.new(vp)
	      s.bitmap = $cache.particle(['leaf-1','leaf-2','leaf-3'].sample)
	      @stars.push(s)
	      s.sx = $scene.map.display_x/4+ rand(220) - 320#-120+800)#rand(640)
	      s.sy = $scene.map.display_y/4+ rand(240) - 240 #-140+700)#rand(480)
	      s.mx = rand * 2.5
	      s.my = rand * 2.5
	      s.x = s.sx
	      s.y = s.sy
	      # z = 1 + rand
	      # s.zoom_x = z
	      # s.zoom_y = z

	    }

	end

	def update

		@stars.each{ |s|

	      s.sx += s.mx * (7.3+rand)
	      s.sy += s.my * (7.3+rand)
	      s.x = s.sx
	      s.y = s.sy

	      
	      if s.x > $scene.map.display_x/4 + 860 || s.y > $scene.map.display_y/4+720 || s.x < $scene.map.display_x/4 - 320 || s.y < $scene.map.display_y/4 - 240
	        s.mx = rand
	        s.my = rand
	      	s.sx = $scene.map.display_x/4+ rand(640+320) - 320#-120+800)#rand(640)
	      	s.sy = $scene.map.display_y/4+ rand(480+240) - 240 #-140+700)#rand(480)
	        # if rand > 0.5
	        #   s.sx = rand(-120+750)
	        #   s.sy = -100 + rand(50)
	        # else
	        #   s.sx = -100 + rand(50)
	        #   s.sy = rand(-140+560)
	        # end
	      end		      
		}

	end

def dispose
		@stars.each{ |s| s.dispose }
	end

end

class Weather_MenuDots

	def initialize(vp)

		@stars = []
	    (1..30).each{ |s|
	      s = Particle.new(vp)
	      s.bitmap = $cache.particle(['yellow','blue'].sample)
	      @stars.push(s)
	      s.sx = rand(640+220) - 320#-120+800)#rand(640)
	      s.sy = rand(480+240) - 240 #-140+700)#rand(480)
	      s.mx = rand * 0.5
	      s.my = rand * 0.5
	      s.x = s.sx
	      s.y = s.sy
	   	  s.opac = 10 + rand(40)
	      s.opacity = 0
	      # z = 1 + rand
	      # s.zoom_x = z
	      # s.zoom_y = z

	    }

	end

	def update

		@stars.each{ |s|

	      s.sx += s.mx * (0.3+rand)
	      s.sy += s.my * (0.3+rand)
	      s.x = s.sx
	      s.y = s.sy

	      s.opacity += 3 if s.opac > s.opacity
	      
	      if s.x > 640 || s.y > 480 #|| s.x < $scene.map.display_x/4 - 320 || s.y < $scene.map.display_y/4 - 240
	        s.mx = rand
	        s.my = rand
	      	s.sx = rand(640+220) - 320#-120+800)#rand(640)
	     	s.sy = rand(480+240) - 240 #-140+700)#rand(480)
	        # if rand > 0.5
	        #   s.sx = rand(-120+750)
	        #   s.sy = -100 + rand(50)
	        # else
	        #   s.sx = -100 + rand(50)
	        #   s.sy = rand(-140+560)
	        # end
	        s.opac = 70 + rand(100)
	        s.opacity = 0
	      end		      
		}

	end

def dispose
		@stars.each{ |s| s.dispose }
	end

end