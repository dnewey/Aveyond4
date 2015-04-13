#==============================================================================
# ** Part_Char
#==============================================================================

class Port_Full

	def initialize(vp)

		@boyle = Sprite.new(vp)
		@boyle.bitmap = Cache.menu("tempboyle")
		@boyle.x = 500

	end

	def dispose

		@boyle.dispose

	end

	def update

	end

end