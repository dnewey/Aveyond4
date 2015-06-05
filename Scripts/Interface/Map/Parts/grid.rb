#==============================================================================
# ** Ui_Grid
#==============================================================================

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
		@types = []
		@stats = []

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

	def opacity=(o)

	end
	def opacity
		return 255
	end

	def x=(v)
		@cx = v
	end
	def x
		return @cx
	end

	def y=(v)
		@cy = v
	end
	def y
		return @cy
	end

	def dispose

		$tweens.clear(@glow)
		@glow.dispose
		@contents.each{ |i| i.dispose }
		@boxes.each{ |i| i.dispose }

	end

	def add_button(name,text,icon)

		# Create new things
		btn = Box.new(@vp,300,60)
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

     	type = Label.new(@vp)
    	type.fixed_width = 250
    	type.font = $fonts.pop_type
    	type.align = 0
    	type.text = "WEAPON"
    	@types.push(type)

		stat = Label.new(@vp)
    	stat.fixed_width = 250
    	stat.font = $fonts.pop_type
    	stat.align = 0
    	stat.text = "15 Strength"
    	@stats.push(stat)

     	# Position
     	btn.move(@cx,@cy)
     	cont.move(@cx+10,@cy+7)
     	type.move(@cx+220,@cy+7)
     	stat.move(@cx+32, @cy+32)

     	if @boxes.count == 1
     		choose(@boxes[0].name)
     	end

     	# Next
     	if @layout == :vertical
     		@cy += 65
     	end

	end

	def update
		return if @boxes.empty?

		if $input.down?
			sx = @selected_box.x + @selected_box.width/2		
			sy = @selected_box.y + @selected_box.height
			search(sx,sy,1,3)
		end

		if $input.up?
			sx = @selected_box.x + @selected_box.width/2		
			sy = @selected_box.y
			search(sx,sy,1,-3)
		end

	end

	def search(sx,sy,x,y)

		cx = sx
		cy = sy

		# Start moving until find something
		while true

			cx += x
			cy += y

			@boxes.each{ |box|
				next if box == @selected_box
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
		@selected_box = @boxes.find{ |b| b.name == target }

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

		glowon = @selected_box

		@glow.bitmap = Bitmap.new(glowon.width-12,glowon.height-12)
     	@glow.bitmap.borderskin($cache.menu_common("skin-glow"))
		@glow.move(glowon.x+6,glowon.y+6)

	end

	def select(option)

		

	end

end