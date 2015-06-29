#==============================================================================
# ** Mnu_Char
#==============================================================================

class Mnu_Char < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change($menu.char)

		@subtitle.text = "Master of deception"

		#@tabs.push("all")
		#@tabs.push("potions")
		#@tabs.push("keys")

		@menu.dispose
		self.left.delete(@menu)
		
		@grid = Ui_Grid.new(vp)
		@grid.move(15,113)
		@grid.add_wide("equip","Change Equipment","misc/unknown")
		@grid.add_wide("skills","Use Skills","skills/spells")
		@grid.add_wide("status","View Status","misc/unknown")
		@grid.add_wide("profile","View Profile","faces/boy")
		@grid.add_wide("leader","Set as Leader","misc/unknown")
		@grid.add_wide("creatures","Creature Hunting","misc/unknown")
		self.left.push(@grid)


		@port = Port_Full.new(vp)
		self.right.push(@port)

	end

	def update
		super

		@grid.update

		# Cancel out of grid
		if $input.cancel? || $input.rclick?
			@left.each{ |a| $tweens.clear(a) }
			@right.each{ |a| $tweens.clear(a) }
			@other.each{ |a| $tweens.clear(a) }
			close
		end

		# Get chosen grid option
		if $input.action? || $input.click?
			choose(@grid.get_chosen)
		end
		
	end

	def choose(option)
		case option
			when 'leader'
				$party.leader = $menu.char
				$scene.close_all
		end
	end

end