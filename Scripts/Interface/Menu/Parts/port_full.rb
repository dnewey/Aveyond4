#==============================================================================
# ** Part_Char
#==============================================================================

# Could auto choose the right char, but maybe just put as sprite
class Port_Full

	def initialize(vp)

		@boyle = Sprite.new(vp)
		@boyle.bitmap = $cache.menu("tempboyle")
		@boyle.x = 350

	end

	def hide
		@boyle.hide
	end

	def show
		@boyle.show
	end

	def dispose

		@boyle.dispose

	end

	def update

	end

end