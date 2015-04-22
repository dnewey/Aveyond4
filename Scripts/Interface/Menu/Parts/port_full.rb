#==============================================================================
# ** Part_Char
#==============================================================================

class Port_Full

	def initialize(vp)

		@boyle = Sprite.new(vp)
		@boyle.bitmap = $cache.menu("tempboyle")
		@boyle.x = 350

	end

	def dispose

		@boyle.dispose

	end

	def update

	end

end