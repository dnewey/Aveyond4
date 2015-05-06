
class Item_Box < SpriteGroup

	attr_accessor :title

	def initialize(vp)
		super()		

		# Resize to whatever is needed
		@window = Box.new(vp,300,120)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.wallpaper = $cache.menu_wallpaper("diamonds")
    	add(@window)

    	@title = Label.new(vp)
    	@title.fixed_width = 250
    	@title.font = $fonts.pop_ttl
    	@title.text = "Active Quests:"
    	add(@title,16,10)

    	@type = Label.new(vp)
    	@type.fixed_width = 250
    	@type.font = $fonts.pop_type
    	@type.align = 0
    	@type.text = "POTION"
    	add(@type,226,13)

    	@desc = Area.new(vp)
    	@desc.font = $fonts.pop_text
    	@desc.text = "Missing Descriptor"
    	add(@desc,16,40)

    	@stat_a = Label.new(vp)
    	@stat_b = Label.new(vp)
    	@stat_c = Label.new(vp)
    	
    	move(0,0)

    	item('unknown')

	end

	def center(x,y)
		move(x-150,y-60)
	end

	def dispose

		self.sprites.each{ |s|
			s[0].dispose
		}

	end

	def update
		@window.update
	end

	def item(id)

		item = $data.items[id]
		log_info(item)

		# Set values
		@title.text = item.name
		@desc.text = item.description
		#@type.text = item.type

	end

	def skill(id)

	end

end