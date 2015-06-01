
class ItemCmd

	def initialize(vp)

		# Left side window
		@window = Box.new(vp,300,242)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.color = Color.new(47,45,41)
    	@window.move(10,64)

		# Left side list
		@list = List.new()
		@list.move(16,70)

		@list.per_page = 9
		@list.item_width = 288
		@list.item_height = 34

		@list.item_space = 35	

		@list.change = Proc.new{ |option| self.change(option) }
		
		data = []
		data.push('covey')
		data.push('covey')
		data.push('covey')

		@list.setup(data)
		@list.refresh

		#@box = Item_Box.new(vp)
		#@box.item('covey')
		#@box.move(320,140)

		@list.opacity = 0
		@window.opacity = 0

	end

	def setup
		@list.opacity = 255
		@window.opacity = 255
	end

	def close
		@list.opacity = 0
		@window.opacity = 0
	end

	def update
		@list.update
	end

	def change(option)
		@item = option
	end

	def get_item
		return @item
	end

end