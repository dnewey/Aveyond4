
class List_Common < SpriteGroup

	attr_reader :list

	def initialize(vp)
		super()

		# Left side window
		@window = Box.new(vp,300,258)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.color = Color.new(47,45,41)
    	add(@window)
    	
		# Left side list
		@list = List.new()

		@list.item_width = 288
		@list.item_height = 34

		@list.item_space = 35
		add(@list,6,6)

		data = []
		data.push(_db('menu','Necromancer Staff'))
		data.push(_db('menu','Boyle goes to college'))
		data.push(_db('menu','Bottle of Glowmoths'))
		data.push(_db('menu','Transformation Potion'))
		data.push(_db('menu','Chicken Curse Scroll'))
		data.push(_db('menu','Tick tock clock'))
		data.push(_db('menu','Tinctura Hypercurium'))

		@list.setup(data)

		move(10,110)
		@list.refresh

	end

	def dispose

	end

	def update
		@list.update
	end




	# All the various data that can be shown
	def items(category)

	end

	

end