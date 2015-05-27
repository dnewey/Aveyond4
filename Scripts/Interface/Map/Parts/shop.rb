

class Ui_Shop < SpriteGroup

	attr_accessor :title

	def initialize(vp)
		super()		

		@vp = vp

		# Left side window
		@window = Box.new(vp,300,242)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.color = Color.new(47,45,41)
    	add(@window,0,0)

		# Left side list
		@list = List.new()
		add(@list,6,6)

		@list.per_page = 9
		@list.item_width = 288
		@list.item_height = 34

		@list.item_space = 35	

		@list.change = Proc.new{ |option| self.select(option) }
		
		data = []
		data.push('covey')
		data.push('covey')
		data.push('covey')

		@list.setup(data)

		@box = Item_Box.new(vp)
		@box.item('covey')
		add(@box,300,20)
		

		#@list.opacity = 0
		#@window.opacity = 0

		move(10,64)

@list.refresh
	end

	def dispose

		

	end

	def update
		@list.update
	end

	def setup()

		

	end

	def start_selling

	end

	def select(op)

	end


end