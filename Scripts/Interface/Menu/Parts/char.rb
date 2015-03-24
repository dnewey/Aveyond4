#==============================================================================
# ** Part_Char
#==============================================================================

class Part_Char

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