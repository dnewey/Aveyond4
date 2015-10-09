
class ItemCmd

	def initialize(vp)

		# Left side window
		@window = Box.new(vp,300,221)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.color = Color.new(47,45,41)
    	@window.move(14,66)

		# Left side list
		@list = List.new()
		@list.move(20,72)

		@list.per_page = 6
		@list.item_width = 288
		@list.item_height = 34

		@list.item_space = 1

		@list.change = Proc.new{ |option| self.change(option) }

		@list.setup([])
		@list.refresh

		@box = Item_Box.new(vp)
		@box.item('covey')
		@box.move(326,100)
		@box.opacity = 0

		@list.opacity = 0
		@window.opacity = 0

	end

	def setup

		item_list = $party.battle_item_list
		@list.setup(item_list)
		change(item_list[0])

		open
	end

	def open
		$tweens.clear(@list)
		$tweens.clear(@window)
		$tweens.clear(@box)

		@list.opacity = 0
		@window.opacity = 0
		@box.opacity = 0

		@list.x = -132
		@list.do(go("x",150,250,:qio))
		@list.do(go("opacity",255,250,:qio))

		@window.x = -138
		@window.do(go("x",150,250,:qio))
		@window.do(go("opacity",255,250,:qio))

		@box.x = 326+150
		@box.do(go("x",-150,250,:qio))
		@box.do(go("opacity",255,250,:qio))
	end

	def close
		$tweens.clear(@list)
		$tweens.clear(@window)
		$tweens.clear(@box)

		@list.do(go("x",-150,250,:qio))
		@list.do(go("opacity",-255,250,:qio))

		@window.do(go("x",-150,250,:qio))
		@window.do(go("opacity",-255,250,:qio))

		@box.do(go("x",150,250,:qio))
		@box.do(go("opacity",-255,250,:qio))
	end

	def update
		@list.update
	end

	def change(option)
		@item = option
		@box.item(option)
		@box.move(326,100) if @box

		if @box && @last_option != option
			@last_option = option
			$tweens.clear(@box)
			@box.y -= 7
			@box.do(go("y",7,150,:qio))
		end

	end

	def get_item
		return @item
	end

end