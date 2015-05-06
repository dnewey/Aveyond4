#==============================================================================
# ** Mnu_Main
#==============================================================================

class Mnu_Main # MAYBE SPRITEGROUP FOR EASY MOVING OF ALL

	def initialize(vp)

		@vp = vp

		# Character Boxes
		# @char_boxes = []
		#@char_boxes.push(CHARBOX.new)

		@charbox = Char_Box_Large.new(vp)
		@charbox.move(196,25)

		@charbox2 = Char_Box_Large.new(vp)
		@charbox2.move(416,25)

		@charbox3 = Char_Box_Large.new(vp)
		@charbox3.move(196,201)

		@charbox4 = Char_Box_Large.new(vp)
		@charbox4.move(416,201)

		@charbox5 = Char_Box_Small.new(vp)
		@charbox5.move(196,376)

		@charbox6 = Char_Box_Small.new(vp)
		@charbox6.move(343,376)

		@charbox7 = Char_Box_Small.new(vp)
		@charbox7.move(490,376)


		data = []
		data.push('Items')
		data.push('Journal')
		data.push('Party')
		data.push('Equip')
		data.push('Skills')
		data.push('Profiles')
		data.push('Options')
		data.push('Quit')
		#data.push(['Load','items/map'])
		#data.push(['Save','items/map'])

		@data = data

		cy = 25

		@buttons = []
		@texts = []
		@icons = []

		data.each{ |item|

			btn = Box.new(vp,168,50)
	     	btn.skin = $cache.menu_common("skin-plain")
	     	btn.wallpaper = $cache.menu_wallpaper("diamonds")
	     	btn.move(10,cy)
	     	@buttons.push(btn)

	     	text = Label.new(vp)
	     	text.font = $fonts.list
	     	text.text = item
	     	text.move(90,cy+10)
	     	@texts.push(text)

	     	icon = Sprite.new(vp)
	     	icon.bitmap = $cache.menu("Icons/#{['journal','inventory'].sample}")
	     	icon.move(-10+28,cy-8)
	     	icon.src_rect = Rect.new(32,0,120,50)
	     	icon.z += 50
	     	@icons.push(icon)

	     	cy += 55

     	}

     	@glow = Sprite.new(vp)
     	@glow.bitmap = $cache.menu_common("box-glow")
     	@glow.do(pingpong("opacity",-100,300,:quad_in_out))

     	@idx = 0
     	@sr = 0

     	setidx(0)

     	

	end

	def dispose

		@charbox.dispose
		@charbox2.dispose
		@charbox3.dispose
		@charbox4.dispose

		@glow.dispose
		@icons.each{ |i| i.dispose }
		@texts.each{ |i| i.dispose }
		@buttons.each{ |i| i.dispose }
	end

	def update
		#@menu.update

		if $input.action?
			select(@data[@idx])
		end

		if $input.down?
			@idx += 1
			setidx(@idx)
		end
		if $input.up?
			@idx -= 1
			setidx(@idx)
		end
	end

	def open

		@charbox.show
		@charbox2.show
		@charbox3.show
		@charbox4.show


		@glow.show
		@icons.each{ |i| i.show }
		@texts.each{ |i| i.show }
		@buttons.each{ |i| i.show }
	end

	def close

		@charbox.hide
		@charbox2.hide
		@charbox3.hide
		@charbox4.hide

		@glow.hide
		@icons.each{ |i| i.hide }
		@texts.each{ |i| i.hide }
		@buttons.each{ |i| i.hide }
	end

	def setidx(idx)
		@sr = 0
		idx2 = 0
		@icons.each{ |i|
			i.src_rect = Rect.new(32,0,120,50)
			i.y = 25+(idx2*55)-8
			$tweens.clear(i)
			idx2 += 1
		}
		@icons[idx].do(go("y",-12,250,:quad_in_out))
		self.do(go("srcrecter",12,250,:quad_in_out))

		@glow.move(16,25+(idx*55)+6)

	end

	def srcrecter
		return @sr
	end

	def srcrecter=(y)
		@sr = y
		@icons[@idx].src_rect = Rect.new(32,0,120,50+y)
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