
class Item_Box < SpriteGroup

	attr_accessor :title
    attr_accessor :type

	def initialize(vp)
		super()		

        @type = :item

		# Resize to whatever is needed
		@window = Box.new(vp,300,120)
    	@window.skin = $cache.menu_common("skin-plain")
    	@window.wallpaper = $cache.menu_wallpaper("diamonds")
    	add(@window)

    	@title = Label.new(vp)
    	@title.fixed_width = 250
    	@title.icon = $cache.icon("items/map")
    	@title.font = $fonts.pop_ttl
    	@title.text = "Active Quests:"
    	add(@title,16,10)

    	@cat = Label.new(vp)
    	@cat.fixed_width = 250
    	@cat.font = $fonts.pop_type
    	@cat.align = 0
    	@cat.text = "POTION"
    	add(@cat,226,13)

    	@desc = Area.new(vp)
    	@desc.font = $fonts.pop_text
    	@desc.text = "Missing Descriptor"
    	add(@desc,16,42)

    	@stat_a = Label.new(vp)
		@stat_a.fixed_width = 250
    	@stat_a.icon = $cache.icon("stats/restore")
    	@stat_a.font = $fonts.pop_text
    	@stat_a.text = "Restores 10HP"
    	add(@stat_a,36,70)

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

        if @type == :item
		  item = $data.items[id]
        elsif @type == :skill
          item = $data.skills[id]
        end
		#log_info(item)

        if item == nil
            log_sys(id)
            log_sys(@type)
            return
        end

		# Set values
		@title.text = item.name
		@desc.text = item.description
		#@type.text = item.type

	end

	def skill(id)

	end

end