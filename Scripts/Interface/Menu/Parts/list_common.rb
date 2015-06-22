
class List_Common < SpriteGroup

	attr_accessor :list, :window

	def initialize(vp)
		super()

		# Left side window
		@window = Box.new(vp,300,292)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.color = Color.new(47,45,41)
    	add(@window)
    	
		# Left side list
		@list = List.new()

		@list.per_page = 8
		@list.item_width = 288
		@list.item_height = 34

		@list.item_space = 1
		add(@list,6,6)


		move(15,140)
		@list.refresh

	end

	def dispose
		@window.dispose
		@list.dispose
	end

	def update
		@list.update
	end

	def hide
		move(-1000,-1000)
	end

	# All the various data that can be shown
	def setup_items(category)
		items = $data.items.values.select{ |i|
			i.is_a?(UsableData) # &&
		}
		@list.setup(items.map{|i| i.id})
	end

	def setup_gear(slot)

	end

end