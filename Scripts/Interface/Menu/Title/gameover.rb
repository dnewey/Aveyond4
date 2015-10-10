#==============================================================================
# ** Mnu_GameOver
#==============================================================================

class Mnu_GameOver < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change($menu.char)
		@subtitle.text = "Master of deception"

		@title.y = -500
		@subtitle.y = -500

		remove_info

		@menu.dispose
		self.left.delete(@menu)
		
		@grid = Ui_Grid.new(vp)
		@grid.move(45,143)

		char = $party.get($menu.char)
		
		@grid.add_midwidth("Continue","Continue Autosave",char.weapon_icon)
		@grid.add_midwidth("Load","Load Game","skills/sparkle")
		@grid.add_midwidth("Quit","Quit Game","misc/primary")

		#@grid.choose($menu.char_cursor)

		self.left.push(@grid)

		# Fade and slide in
		dist = 30
		@grid.all.each{ |b|
			b.x -= dist
			b.opacity = 0
     		b.do(go("x",dist,200,:qio))
     		b.do(go("opacity",255,200,:qio))
		}

		open

	end

	def dispose
		super
		@grid.dispose
	end

	def update
		

		if $input.right? || $input.mclick?
			$menu.char = $party.get_next($menu.char)
			$scene.queue_menu("Char")
			close_soon(0)
		end

		if $input.left?
			$menu.char = $party.get_prev($menu.char)
			$scene.queue_menu("Char")
			close_soon(0)
		end

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

		$scene.hide_char if option == "Load"
		$scene.queue_menu(option)

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