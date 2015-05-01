#==============================================================================
# ** Mnu_Main
#==============================================================================

class Mnu_Main # MAYBE SPRITEGROUP FOR EASY MOVING OF ALL

	def initialize(vp)

		@vp = vp

		@menu = List_Main.new(vp)
		@menu.list.select = Proc.new{ |option| self.select(option) }
		@menu.list.cancel = Proc.new{ |option| self.cancel(option) }

		# Character Boxes
		# @char_boxes = []
		#@char_boxes.push(CHARBOX.new)

		@charbox = Char_Box_Large.new(vp)
		@charbox.move(196,25)

		@charbox2 = Char_Box_Large.new(vp)
		@charbox2.move(416,25)

		@charbox3 = Char_Box_Large.new(vp)
		@charbox3.move(196,202)

		@charbox4 = Char_Box_Large.new(vp)
		@charbox4.move(416,202)

		@window = Box.new(vp,168,48)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.wallpaper = $cache.menu_wallpaper("diamonds")
    	@window.move(10,426)

	end

	def dispose
		@menu.dispose
		@window.dispose
		@charbox.dispose
		@charbox2.dispose
		@charbox3.dispose
		@charbox4.dispose
	end

	def update
		@menu.update
	end

	def open
		@menu.show
		@charbox.show
		@charbox2.show
		@charbox3.show
		@charbox4.show
		@menu.list.refresh
	end

	def close
		@menu.hide
		@charbox.hide
		@charbox2.hide
		@charbox3.hide
		@charbox4.hide
	end

	def select(option)
		if option == "Items"
			$scene.open_sub(Mnu_Items.new(@vp))
		end
	end

	def cancel(option)
		# save cursor pos for later
		$game.pop_scene
	end

end