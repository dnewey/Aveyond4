#==============================================================================
# ** Mnu_MiscTitle
#==============================================================================

class Mnu_MiscTitle

	def initialize(vp)

		@vp = vp
		@closing = false
		@close_soon = false
		@close_delay = 0

		@data = ['New']

		cx = 100
		cy = 15

		@buttons = []
		@texts = []
		@icons = []

		@data.each{ |item|

			btn = Box.new(vp,270,145)
	     	btn.skin = $cache.menu_common("skin-plain")
	     	btn.wallpaper = $cache.menu_wallpaper("diamonds")
	     	btn.move(cx+15,cy)
	     	btn.name = item
	     	@buttons.push(btn)

	     	text = Label.new(vp)
	     	text.font = $fonts.list
	     	text.shadow = $fonts.list_shadow
	     	text.gradient = true
	     	text.text = item
	     	text.move(cx+194,cy+7)
	     	@texts.push(text)

	     	icon = Sprite.new(vp)
	     	icon.bitmap = $cache.menu("Icons/"+item)
	     	icon.move(cx-4+28,cy+10)
	     	#icon.src_rect = Rect.new(68,0,120,50)
	     	icon.z += 50
	     	@icons.push(icon)

	     	cy += 51

     	}

     	@glow = Sprite.new(vp)
     	@glow.bitmap = Bitmap.new(@buttons[0].width-12,@buttons[0].height-12)
     	@glow.bitmap.borderskin($cache.menu_common("skin-glow"))
     	@glow.do(pingpong("opacity",-100,300,:quad_in_out))

     	@idx = 0
     	@sr = 0

     	@boxes = @buttons

     	# Everything fade in
     	(@buttons+@texts+@icons).each{ |c|
     		c.opacity = 0
     		c.do(go("opacity",255,200,:linear))
     	}

     	dist = 30

     	(@buttons+@texts+@icons).each{ |c|
			c.x -= dist
     		c.do(go("x",dist,200,:qio))
     	}

     	self.do(delay(200))
     	
     	@selected = @data[0]#$menu.menu_cursor #{}"Journal"
     	@selected_box = nil
     	choose(@selected,false)

	end

	def dispose

		@glow.dispose
		@icons.each{ |i| i.dispose }
		@texts.each{ |i| i.dispose }
		@buttons.each{ |i| i.dispose }

	end

	def update

		@glow.move(@selected_box.x+6,@selected_box.y+6)
		return if !$tweens.done?(@boxes[0])

		#@menu.update
		@boxes.each{ |b| b.update }

		@glow.move(@selected_box.x+6,@selected_box.y+6)

		if $input.action? || $input.click?
			select(@selected)
		end

		if $input.cancel? || $input.rclick?
			close_soon
		end

		if @close_soon && !@closing
			@close_delay -= 1
			if @close_delay <= 0
				close
			end
		end

		# Just remember selected I would suppose
		box = @selected_box
			
		if $input.right?		
			sx = box.x + box.width
			sy = box.y + box.height/2	
			search(sx,sy,3,1)
		end

		if $input.left?
			sx = box.x
			sy = box.y + box.height/2
			search(sx,sy,-3,1)
		end

		if $input.down?
			sx = box.x + box.width/2		
			sy = box.y + box.height
			search(sx,sy,1,3)
		end

		if $input.up?
			sx = box.x + box.width/2		
			sy = box.y
			search(sx,sy,1,-3)
		end

		pos = $mouse.position
     

		# Mousing
		@boxes.each{ |b| 

			next if b == @selected_box
			next if pos[0] < b.x
		    next if pos[1] < b.y
		    next if pos[0] > b.x + b.width
		    next if pos[1] > b.y + b.height
			choose(b.name)
			break

		}

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

	def choose(target,dosound=true)

		sys('select') if dosound

		@selected = target

		@sr = 0


		idx2 = 0
		@icons.each{ |i|
			#i.src_rect = Rect.new(36,0,120,50)
			i.y = 25+(idx2*51)-23
			#i.x = @buttons[idx2].x
			#i.do(go("y"))
			$tweens.clear(i) if dosound
			idx2 += 1
		}


		# Find the icon if this is journal
		@idx = nil
		if !@buttons.select{ |b| b.name == target }.empty?

			idx = 0
			@buttons.each{ |b|
				break if b.name == target
				idx += 1
			}

			@idx = idx

			#@icons[idx].do(go("y",-12,250,:quad_in_out))
			#self.do(go("srcrecter",12,250,:quad_in_out))

		end

		@selected_box = @boxes.find{ |b| b.name == target }

		glowon = @selected_box

		@selected_box.flash_light

		@glow.bitmap = Bitmap.new(glowon.width-12,glowon.height-12)
     	@glow.bitmap.borderskin($cache.menu_common("skin-glow"))
		@glow.move(glowon.x+6,glowon.y+6)

	end

	def srcrecter
		return @sr
	end

	def srcrecter=(y)
		if @idx == nil
			$tweens.clear(self)
			return
		end
		@sr = y
		#@icons[@idx].src_rect = Rect.new(36,0,120,50+y)
	end

	def select(option)

		$scene.queue_menu(option)		

		@selected_box.flash_heavy
		
		close_soon

	end

	def close_soon(delay=10)
		@close_soon = true
		@close_delay = delay
	end

	def close

		@closing = true

		# Everything fade in
     	(@buttons+@texts+@icons).each{ |c|
     		c.do(go("opacity",-255,200,:linear))
     	}

		dist = 30
     	(@buttons+@texts+@icons).each{ |c|
     		c.do(go("x",-dist,200,:qio))
     	}

     	@glow.hide
     	self.do(delay(200))

	end


	def closing?
		return @closing
	end

	def done?
		return @closing && $tweens.done?(self)
	end

end