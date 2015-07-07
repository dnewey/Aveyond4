
# Update self perhamps? Disregard else
# Uses $battle and that's it

# Handle all inputs?

class BattleHud

	attr_reader :chars

	def initialize(vp)

		# Bottom bar
		@chars = []
		idx = 0
		cx = 5
		cx = 240 if $party.active.count == 1
		cx = 170 if $party.active.count == 2
		cx = 60 if $party.active.count == 3
		$party.active.each{ |char|
			view = CharView.new(vp,$party.actor_by_id(char),idx)
			view.x = cx + (idx * 158)
			view.y = 340
			@chars.push(view)
			$party.get(char).view = view
			idx += 1
		}

		# Help box
		@help_box = Box.new(vp)
		@help_box.skin = $cache.menu_common("skin-plain")
    	@help_box.wallpaper = $cache.menu_wallpaper("diamonds")
		@help_box.resize(300,50)
		@help_box.move(166,8)

	    @help_text = Sprite.new(vp)
	    @help_text.bitmap = Bitmap.new(300,50)
	    @help_text.bitmap.font = $fonts.message
	    @help_text.bitmap.draw_text(0,0,300,50,"Shadow - Gain Darkness",1)
		@help_text.move(166,9)

		# Try hiding the info box
		@help_box.hide
		@help_text.hide

	end

	def dispose

	end

	def all_win
		@chars.each{ |c| c.win }
	end

	def deselect_all
		@chars.each{ |c| c.deselect }
	end

	def set_help(text)

		@help_text.bitmap.clear
		@help_text.bitmap.draw_text(0,0,300,50,text,1)

	end
	
	def update

		@chars.each{ |c|
			c.update
		}

		@help_box.update

	end

end