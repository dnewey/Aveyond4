#==============================================================================
# ** Mnu_Skills
#==============================================================================

class Mnu_Skills < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Skills')
		@title.icon($menu.char)

		@subtitle.text = "Master of deception"

		@menu.list.type = :skill
		@menu.list.setup($party.get('boy').all_skill_list)

		@port = Port_Full.new(vp)
		self.right.push(@port)

		open

	end

	def update
		
		
		# Cancel out of grid
		if $input.cancel? || $input.rclick?
			@left.each{ |a| $tweens.clear(a) }
			@right.each{ |a| $tweens.clear(a) }
			@other.each{ |a| $tweens.clear(a) }
			$scene.queue_menu("Char")
			close_now
		end

		super

	end

	def change(option)
		
	end

	def select(option)	
		
	end

end