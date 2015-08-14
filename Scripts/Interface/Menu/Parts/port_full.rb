#==============================================================================
# ** Part_Full
#==============================================================================

class Port_Full < Sprite

	def initialize(vp)
		super(vp)

		self.bitmap = $cache.face_menu("#{$menu.char}")
		self.x = 330

	end

	def normal() self.bitmap = $cache.face_menu("#{$menu.char}") end
	def shock() self.bitmap = $cache.face_menu("#{$menu.char}-w") end
	def sad() self.bitmap = $cache.face_menu("#{$menu.char}-s") end
	def happy() self.bitmap = $cache.face_menu("#{$menu.char}-h") end
	def angry() self.bitmap = $cache.face_menu("#{$menu.char}-a") end
	def confused() self.bitmap = $cache.face_menu("#{$menu.char}-c") end
	def xtra() self.bitmap = $cache.face_menu("#{$menu.char}-x") end

end