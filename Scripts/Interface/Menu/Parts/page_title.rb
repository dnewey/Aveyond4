


class Page_Title

	def initialize(vp)

		@logo = Sprite.new(vp)
		@logo.bitmap = $cache.menu_common("title-circle")
		@logo.x = 25
		@logo.y = 15

	end

end