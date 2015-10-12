
# Update self perhamps? Disregard else
# Uses $battle and that's it

# Handle all inputs?

class BattleHud

	attr_reader :chars

	def initialize(vp)

		@vp = vp

		@chars = []

		build_views

		# Help box
		@help_box = Box.new(vp)
		@help_box.skin = $cache.menu_common("skin-plain")
    	@help_box.wallpaper = $cache.menu_wallpaper("diamonds")
		@help_box.resize(300,50)
		@help_box.move(166,8-15)

	    @help_text = Sprite.new(vp)
	    @help_text.bitmap = Bitmap.new(300,50)
	    @help_text.bitmap.font = $fonts.message
	    @help_text.bitmap.draw_text(0,0,300,50,"Shadow - Gain Darkness",1)
		@help_text.move(166,9-15)

		# Try hiding the info box
		@help_box.opacity = 0
		@help_text.opacity = 0

		@help_timer = -1

	end

	def dispose
		@chars.each{ |c| c.dispose }
		@help_box.dispose
		@help_text.dispose
	end

	def build_views
		# Bottom bar
		@chars.each{ |c| c.dispose }
		@chars = []
		idx = 0
		cx = 5
		cx = 240 if $party.active.count == 1
		cx = 170 if $party.active.count == 2
		cx = 85 if $party.active.count == 3
		$party.active.each{ |char|
			view = CharView.new(@vp,$party.actor_by_id(char),idx)
			view.x = cx + (idx * 158)
			view.y = 340
			@chars.push(view)
			$party.get(char).view = view
			idx += 1
		}
	end

	def all_win
		@chars.each{ |c| c.win }
	end

	def deselect_all
		@chars.each{ |c| c.deselect }
	end

	def set_help(text)

		# Show it for a bit when called

		@help_timer = 120

		# Fadein the help now
		@help_text.bitmap.clear
		@help_text.bitmap.draw_text(0,0,300,50,text,1)

		@help_text.do(go('opacity',255,160,:qio))
		@help_box.do(go('opacity',255,160,:qio))

		@help_box.move(166,8-15)
		@help_text.move(166,9-15)

		@help_text.do(go('y',15,160,:qio))
		@help_box.do(go('y',15,160,:qio))

	end
	
	def update

		@help_timer -= 1
		if @help_timer == 0
			# Fadeout the help now thx
			@help_text.do(go('opacity',-255,160,:qio))
			@help_box.do(go('opacity',-255,160,:qio))

			@help_text.do(go('y',-15,160,:qio))
			@help_box.do(go('y',-15,160,:qio))
		end

		@chars.each{ |c|
			c.update
		}

		@help_box.update

		if @popper
			@popper.update 
			if $input.action? || $input.click?
				$tweens.clear(@popper)
				@popper.dispose
				@popper = nil
			end
		end

	end

	def open_popper()
		@popper = Ui_Popper.new(@vp)
		@popper.middle = true
		return @popper
	end

	def busy?
		return @popper != nil
	end

end