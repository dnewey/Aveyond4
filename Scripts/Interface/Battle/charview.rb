
# Actor view, show portrait, hp etc

class CharView

	def initialize(vp,char,id)

		@port = Sprite.new(vp)
		@port.bitmap = Cache.face(char.id)

		@port.x = id * 150
		@port.y = 380

	end

end