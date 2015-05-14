#==============================================================================
# ** Grid_Base
#==============================================================================

class Grid_Base

	def initialize(vp)

		@vp = vp

		@data = ['Journal','Items','Equip','Skills',
  	 		     'Party','Options','Quit','Load','Save']

		cy = 15

		@buttons = []
		@texts = []

		@data.each{ |item|

			btn = Box.new(vp,170,45)
	     	btn.skin = $cache.menu_common("skin-plain")
	     	btn.wallpaper = $cache.menu_wallpaper(["blue",'green','orange','diamonds'].sample)
	     	btn.move(15,cy)
	     	btn.name = item
	     	@buttons.push(btn)

	     	text = Label.new(vp)
	     	text.font = $fonts.list
	     	text.shadow = $fonts.list_shadow
	     	text.icon = $cache.icon("faces/hib")
	     	text.gradient = true
	     	text.text = item
	     	text.move(25,cy+7)
	     	@texts.push(text)

	     	cy += 51

     	}

     	@glow = Sprite.new(vp)
     	@glow.bitmap = Bitmap.new(@buttons[0].width-12,@buttons[0].height-12)
     	@glow.bitmap.borderskin($cache.menu_common("skin-glow"))
     	@glow.do(pingpong("opacity",-100,300,:quad_in_out))

     	@idx = 0

     	@boxes = @buttons
     	
     	@selected = "Journal"
     	choose(@selected)

	end

	def dispose

		@chars.each{ |c| c.dispose } 

		@glow.dispose
		@icons.each{ |i| i.dispose }
		@texts.each{ |i| i.dispose }
		@buttons.each{ |i| i.dispose }

	end

	def update
		#@menu.update
		#@chars.each{ |c| c.update }

		if $input.action?
			select(@selected)
		end

		if $input.right?

			box = nil
			@boxes.each{ |b| 
			
				if b.name == @selected 
					box = b 
					break
				end
			}

			sx = box.x + box.width
			sy = box.y + box.height/2
			search(sx,sy,3,1)

		end

		if $input.left?

			box = nil
			@boxes.each{ |b| 
			
				if b.name == @selected 
					box = b 
					break
				end
			}

			sx = box.x
			sy = box.y + box.height/2
			search(sx,sy,-3,1)

		end

		if $input.down?

			box = nil
			@boxes.each{ |b| 
			
				if b.name == @selected 
					box = b 
					break
				end
			}

			sx = box.x + box.width/2		
			sy = box.y + box.height
			search(sx,sy,1,3)

		end

		if $input.up?

			box = nil
			@boxes.each{ |b| 
			
				if b.name == @selected 
					box = b 
					break
				end
			}

			sx = box.x + box.width/2		
			sy = box.y
			search(sx,sy,1,-3)

		end

	end

	def search(sx,sy,x,y)

		before = @selected

		cx = sx
		cy = sy

		# Start moving until find something
		while true

			cx += x
			cy += y

			@boxes.each{ |box|
				if box.window.within?(cx,cy)
					return choose(box.name)
				end
			}

			cy = 0 if cy > 480
			cx = 0 if cx > 640
			cy = 480 if cy < 0
			cx = 640 if cx < 0

		end

	end

	def open

		@chars.each{ |c| c.show } 

		@glow.show
		@texts.each{ |i| i.show }
		@buttons.each{ |i| i.show }

	end

	def close

		@chars.each{ |c| c.hide } 

		@glow.hide
		@texts.each{ |i| i.hide }
		@buttons.each{ |i| i.hide }

	end

	def choose(target)

		@selected = target

		# Find the icon if this is journal
		@idx = nil
		if !@buttons.select{ |b| b.name == target }.empty?

			idx = 0
			@buttons.each{ |b|
				break if b.name == target
				idx += 1
			}

			@idx = idx

		end

		glowon = @boxes.find{ |b| b.name == target }

		# Test for changing skin on selected
		#glowon.skin = $cache.menu_common("skin-gold")

		@glow.bitmap = Bitmap.new(glowon.width-12,glowon.height-12)
     	@glow.bitmap.borderskin($cache.menu_common("skin-glow"))
		@glow.move(glowon.x+6,glowon.y+6)

	end

	def select(option)

		

	end

end