


class Page_Title < SpriteGroup

	def initialize(vp)
		super()

		@web = Sprite.new(vp)
		@web.bitmap = $cache.menu_common("webber")
		#@web.opacity = 20
		add(@web,-40,-50)

		@icon = Sprite.new(vp)
		@icon.bitmap = $cache.menu("Icons/journal")
		add(@icon,0,-5)

		@title = Sprite.new(vp)
		@title.bitmap = $cache.menu("Titles/journal")
		add(@title,100,20)

		move(0,0)

	end

	def change(page)
		@icon.bitmap = $cache.menu("Icons/"+page)
		@title.bitmap = $cache.menu("Titles/"+page)
	end

end