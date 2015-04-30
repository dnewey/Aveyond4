


class Page_Title < SpriteGroup

	def initialize(vp)
		super()

		@logo = Sprite.new(vp)
		@logo.bitmap = $cache.menu_common("title-circle")
		add(@logo)

		move(15,25)

	end

end