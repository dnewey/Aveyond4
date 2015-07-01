#==============================================================================
# ** Mnu_Skills
#==============================================================================

class Mnu_Skills < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Skills')

		@subtitle.text = "Master of deception"

		@menu.list.type = :skill
		@menu.list.setup($party.get('boy').skill_list)

		@port = Port_Full.new(vp)
		self.right.push(@port)

	end

	def update
		super
		
	end

	def change(option)
		
	end

	def select(option)	
		
	end

end