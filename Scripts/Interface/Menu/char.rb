#==============================================================================
# ** Mnu_Char
#==============================================================================

class Mnu_Char < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change($menu.char)
		@subtitle.text = "Master of deception"

		@menu.dispose
		self.left.delete(@menu)
		
		@grid = Ui_Grid.new(vp)
		@grid.move(15,113)

		char = $party.get($menu.char)
		
		@grid.add_wide("Equip","Change Equipment",char.weapon_icon)
		@grid.add_wide("Skills","Use Skills","skills/sparkle")
		@grid.add_wide("Status","View Status","misc/primary")
		@grid.add_wide("Profile","View Profile","misc/profile")
		@grid.add_wide("Leader","Set as Leader","faces/#{$menu.char}")
		
		@grid.add_wide("Boyle","Cheeki Chasing","items/creature") if $menu.char == 'boy' #&& !$progress.creatures.empty?
		@grid.add_wide("Ingrid","Potion Making","items/potion-red") if $menu.char == 'ing'
		@grid.add_wide("Nightwatch","Night Watch","items/potion-red") if $menu.char == 'mys' || $menu.char == 'rob'
		@grid.add_wide("Hiberu","Dream Books","items/potion-red") if $menu.char == 'hib'
		@grid.add_wide("Rowen","Gadget Building","items/potion-red") if $menu.char == 'row'
		@grid.add_wide("Phye","Demon Hunting","misc/phy-baal") if $menu.char == 'phy'

		@grid.choose($menu.char_cursor)

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

		if option == "Leader"
			$party.leader = $menu.char
		else
			$scene.queue_menu(option)
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