#==============================================================================
# ** Part_Char
#==============================================================================

# Could auto choose the right char, but maybe just put as sprite
class Port_Full < Sprite

	def initialize(vp)
		super(vp)

		self.bitmap = $cache.face_menu("boy-w")
		self.x = 330
		#self.x -= 20

	end

end