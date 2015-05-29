#==============================================================================
# ** Ui_Grid
#==============================================================================

# Cut the old layout system
# Change to a dynamic style
# add_vert and add_hor
# Adds to the right or below, perhaps above even?
# Above could be used for bottom bar?

class Ui_Grid

	attr_reader :idx

	def initialize(vp)

		@vp = vp

		@layout = :vertical

		@cx = 0
		@cy = 0

		@fix_width = 0

		@boxes = []
		@contents = []

     	@glow = Sprite.new(vp)
     	@glow.bitmap = Bitmap.new(100,100)
     	@glow.bitmap.borderskin($cache.menu_common("skin-glow"))
     	@glow.do(pingpong("opacity",-100,300,:quad_in_out))
     	@glow.z += 50

     	@idx = 0
     	
     	#@selected = "Journal"
     	#choose(@selected)

	end

	def move(x,y)
		@cx = x
		@cy = y
	end

	def dispose

		$tweens.clear(@glow)
		@glow.dispose
		@contents.each{ |i| i.dispose }
		@boxes.each{ |i| i.dispose }

	end

	def add_button(name,text,icon)

		# Create new things
		btn = Box.new(@vp,170,45)
     	btn.skin = $cache.menu_common("skin-plain")
     	btn.wallpaper = $cache.menu_wallpaper(["blue",'green','orange','diamonds'].sample)
     	btn.name = name
     	@boxes.push(btn)

     	cont = Label.new(@vp)
     	cont.font = $fonts.list
     	cont.shadow = $fonts.list_shadow
     	cont.icon = $cache.icon(icon)
     	cont.gradient = true
     	cont.text = text
     	@contents.push(cont)

     	# Position
     	btn.move(@cx,@cy)
     	cont.move(@cx+10,@cy+10)

     	if @boxes.count == 1
     		choose(@boxes[0].name)
     	end

     	# Next
     	if @layout == :vertical
     		@cy += 50
     	end

	end

	def add_image(image)

	end

	def update
		return if @boxes.empty?

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

		@glow.show
		@contents.each{ |i| i.show }
		@boxes.each{ |i| i.show }

	end

	def close

		@glow.hide
		@contents.each{ |i| i.hide }
		@boxes.each{ |i| i.hide }

	end

	def choose(target)

		sys('select')

		@selected = target

		# Find the icon if this is journal
		@idx = nil
		if !@boxes.select{ |b| b.name == target }.empty?

			idx = 0
			@boxes.each{ |b|
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