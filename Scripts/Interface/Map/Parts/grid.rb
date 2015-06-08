#==============================================================================
# ** Ui_Grid
#==============================================================================

class Ui_Grid

	attr_reader :idx

	attr_accessor :spacing

	def initialize(vp)

		@vp = vp

		@layout = :vertical

		@cx = 0
		@cy = 0

		@spacing = 5

		@fix_width = 0

		@boxes = []
		@contents = []
		@extra = []

     	@glow = Sprite.new(vp)
     	@glow.bitmap = Bitmap.new(100,100)
     	@glow.bitmap.borderskin($cache.menu_common("skin-glow"))
     	@glow.do(pingpong("opacity",-100,300,:quad_in_out))
     	@glow.z += 50

     	@idx = 0

     	@type = :slot
     	@char = 'boy'
     	
     	#@selected = "Journal"
     	#choose(@selected)

	end

	def update
		@boxes.each{ |box| box.update }
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
		btn = Box.new(@vp,120,46)
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
     	cont.move(@cx+10,@cy+7)

     	choose(@boxes[0].name) if @boxes.count == 1

     	# Next
     	if @layout == :vertical
     		@cy += btn.height + @spacing
     	end

	end

	def add_slot(slot)

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

     	# Position
     	btn.move(@cx,@cy)
     	cont.move(@cx+10,@cy+7)

     	choose(@boxes[0].name) if @boxes.count == 1

     	# Next
     	if @layout == :vertical
     		@cy += btn.height + 5
     	end

	end

	def add_difficulty(diff)

		# Create new things
		btn = Box.new(@vp,500,116)
     	btn.skin = $cache.menu_common("skin-plain")
     	btn.wallpaper = $cache.menu_wallpaper(["blue",'green','orange','diamonds'].sample)
     	btn.name = diff
     	@boxes.push(btn)
     	btn.move(@cx,@cy)

     	cont = Label.new(@vp)
     	cont.font = $fonts.list
     	cont.shadow = $fonts.list_shadow
     	cont.icon = $cache.icon("misc/diff-#{diff}")
     	cont.gradient = true
     	cont.text = diff_name(diff)
     	@contents.push(cont)
     	cont.move(@cx+10,@cy+7)

     	stat = Label.new(@vp)
        #stat.fixed_width = 250
        stat.icon = $cache.icon("stats/attack")
        stat.font = $fonts.pop_text
        stat.text = "Enemies do 25% less damage"
        @extra.push(stat)
        stat.move(@cx+22,@cy+34)

        stat = Label.new(@vp)
        #stat.fixed_width = 250
        stat.icon = $cache.icon("stats/targets")
        stat.font = $fonts.pop_text
        stat.text = "Enemies respawn"
        @extra.push(stat)
        stat.move(@cx+22,@cy+57)

        stat = Label.new(@vp)
        #stat.fixed_width = 250
        stat.icon = $cache.icon("stats/restore")
        stat.font = $fonts.pop_text
        stat.text = "Health is not restored when gaining levels"
        @extra.push(stat)
        stat.move(@cx+22,@cy+80)

     	# Position
     	
     	

     	choose(@boxes[0].name) if @boxes.count == 1

     	# Next
     	if @layout == :vertical
     		@cy += btn.height + 5
     	end

	end

	def diff_name(diff)
		case diff
			when 'easy'
				return "Bunny Protector - Easy Mode"
			when 'mid'
				return "Villain - Normal Mode"
			when 'hard'
				return "Super Villain - Expert Mode"
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

	def get_chosen
		return @selected
	end

end