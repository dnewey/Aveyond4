#==============================================================================
# ** Mnu_Main
#==============================================================================

class Mnu_Main # MAYBE SPRITEGROUP FOR EASY MOVING OF ALL

	def initialize(vp)

		@vp = vp

		@chars = []

		# Active Characters
		charbox = Char_Box_Large.new(vp)
		charbox.box.name = "C.1"
		charbox.move(200,15)
		@chars.push(charbox)

		charbox = Char_Box_Large.new(vp)
		charbox.box.name = "C.2"
		charbox.move(420,15)
		@chars.push(charbox)

		charbox = Char_Box_Large.new(vp)
		charbox.box.name = "C.3"
		charbox.move(200,198)
		@chars.push(charbox)

		charbox = Char_Box_Large.new(vp)
		charbox.box.name = "C.4"
		charbox.move(420,198)
		@chars.push(charbox)

		# Reserve Characters
		charbox = Char_Box_Small.new(vp)
		charbox.box.name = "C.5"
		charbox.move(200,381)
		@chars.push(charbox)

		charbox = Char_Box_Small.new(vp)
		charbox.box.name = "C.6"
		charbox.move(347,381)
		@chars.push(charbox)

		charbox = Char_Box_Small.new(vp)
		charbox.box.name = "C.7"
		charbox.move(492,381)
		@chars.push(charbox)


		@data = ['Journal','Items','Equip','Skills',
  	 		     'Party','Options','Quit','Load','Save']

		cy = 15

		@buttons = []
		@texts = []
		@icons = []

		@data.each{ |item|

			btn = Box.new(vp,170,45)
	     	btn.skin = $cache.menu_common("skin-plain")
	     	btn.wallpaper = $cache.menu_wallpaper("diamonds")
	     	btn.move(15,cy)
	     	btn.name = item
	     	@buttons.push(btn)

	     	text = Label.new(vp)
	     	text.font = $fonts.list
	     	text.shadow = $fonts.list_shadow
	     	text.text = item
	     	text.move(94,cy+7)
	     	@texts.push(text)

	     	icon = Sprite.new(vp)
	     	icon.bitmap = $cache.menu("Icons/"+item)
	     	icon.move(-4+28,cy-12)
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

     	@boxes = @buttons + @chars.map{ |c| c.box }
     	
     	@selected = "Journal"
     	choose(@selected)

	end

	def dispose

		@charbox.dispose
		@charbox2.dispose
		@charbox3.dispose
		@charbox4.dispose
		@charbox5.disposed
		@charbox6.disposed
		@charbox7.dispose

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
		@icons.each{ |i| i.show }
		@texts.each{ |i| i.show }
		@buttons.each{ |i| i.show }
	end

	def close

		@chars.each{ |c| c.hide } 

		@glow.hide
		@icons.each{ |i| i.hide }
		@texts.each{ |i| i.hide }
		@buttons.each{ |i| i.hide }
	end

	def choose(target)

		@selected = target

		@sr = 0


		idx2 = 0
		@icons.each{ |i|
			i.src_rect = Rect.new(36,0,120,50)
			i.y = 25+(idx2*51)-23
			$tweens.clear(i)
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

			@icons[idx].do(go("y",-12,250,:quad_in_out))
			self.do(go("srcrecter",12,250,:quad_in_out))

		end

		glowon = @boxes.find{ |b| b.name == target }

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
		@icons[@idx].src_rect = Rect.new(36,0,120,50+y)
	end

	def select(option)

		if option == "Items"
			$scene.open_sub(Mnu_Items.new(@vp))
		end
		if option == "Journal"
			$scene.open_sub(Mnu_Journal.new(@vp))
		end
	end

	def cancel(option)
		# save cursor pos for later
		$game.pop_scene
	end

end