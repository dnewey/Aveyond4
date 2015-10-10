#==============================================================================
# ** Mnu_Quit
#==============================================================================

class Mnu_Quit < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Quit')
		@subtitle.text = "Dare thee skulk?"

		@menu.dispose
		self.left.delete(@menu)
		
		@grid = Ui_Grid.new(vp)
		@grid.move(15,113)

		char = $party.get($menu.char)
		
		@grid.add_wide("Continue","Continue",char.weapon_icon)
		@grid.add_wide("Save","Save and Quit","skills/sparkle")
		@grid.add_wide("Quit","Quit Without Saving","misc/primary")		

		self.left.push(@grid)

		# Fade and slide in
		dist = 30
		@grid.all.each{ |b|
			b.x -= dist
			b.opacity = 0
     		b.do(go("x",dist,200,:qio))
     		b.do(go("opacity",255,200,:qio))
		}

		@port = Port_Full.new(vp)
		@port.shock
		self.right.push(@port)

		open

	end

	def dispose
		super
		@grid.dispose
	end

	def update

		super

		@grid.update	

		# Cancel out of grid
		if $input.cancel? || $input.rclick?
			@left.each{ |a| $tweens.clear(a) }
			@right.each{ |a| $tweens.clear(a) }
			@other.each{ |a| $tweens.clear(a) }
			close_now
		end

		# Get chosen grid option
		if $input.action? || $input.click?
			choose(@grid.get_chosen)
		end
		
	end

	def choose(option)

		if option == "Continue"
			@left.each{ |a| $tweens.clear(a) }
			@right.each{ |a| $tweens.clear(a) }
			@other.each{ |a| $tweens.clear(a) }
			close_now
		elsif option == "Save"
			$scene.savequit = true
			$scene.queue_menu("Save")
		elsif option == "Quit"
			$game.quit
		end

		$menu.char_cursor = option
		@grid.selected_box.flash_heavy
		self.close_soon

	end

	def close
		super

		@grid.hide_glow

		# Fade and hide grid
		dist = 30
		@grid.all.each{ |b|
     		b.do(go("x",-dist,200,:qio))
     		b.do(go("opacity",-255,200,:qio))
		}
		
	end

end