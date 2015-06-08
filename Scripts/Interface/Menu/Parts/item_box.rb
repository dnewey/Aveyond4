
class Item_Box < SpriteGroup

	attr_accessor :title
    attr_accessor :type

	def initialize(vp)
		super()		

        @vp = vp
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

        @stats = []
        @cy = 42

    	
    	
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

    def get_data(id)
        if @type == :item
          return $data.items[id]
        elsif @type == :skill
          return $data.skills[id]
        end
    end

    def base(data)

        # Set values
        @title.text = data.name
        @desc.text = data.description

        @stats.each{ |s| 
            s.dispose
            delete(s)
            s.dispose 
        }
        @stats = []
        @cy = 42 + @desc.height 

    end

    def newsize
        @window.resize(300,64 + @desc.height + @stats.count*20)
    end

    def stat(icon,text)

        stat = Label.new(@vp)
        stat.fixed_width = 250
        stat.icon = $cache.icon("stats/#{icon}")
        stat.font = $fonts.pop_text
        stat.text = text
        @stats.push(stat)
        add(stat,36,@cy)
        @cy += 20

    end

	def item(id)

        data = get_data(id)       
        base(data)

        #return if data == nil
        stat("targets","Hit ALL")
		
		#@type.text = item.type

        newsize
        remove

	end

	def skill(id)

        data = get_data(id)       
        base(data)

        #if data.scope == 'all'
            stat("targets","Hit ALL")
        #end

        newsize
        remove

	end

    def gear(id)

    end

end