
class Right_Save < SpriteGroup

	def initialize(vp)
		super()
	
        @vp = vp

		# Right side journal
		@window = Box.new(vp,300,292)
    	@window.skin = $cache.menu_common("skin-dry")
    	@window.wallpaper = $cache.menu_wallpaper("journal_page_line")
    	#@window.color = Color.new(47,45,41)
    	add(@window,320,140)

    	# Quest Name
    	@page_title = Label.new(vp)
    	@page_title.fixed_width = 250
        @page_title.icon = $cache.icon("potions/hypercurium")
        @page_title.icon_oy = -3
    	@page_title.font = $fonts.page_ttl
    	@page_title.text = "Choco Dream"
    	add(@page_title,340,154)

    	# # SUBTEXTS!!!!!!!!!!

    	# cy = 180

    	# # ALWAYS DESCRIPTION

    	@txt_desc = Area.new(vp)
    	@txt_desc.fixed_width =  260
    	@txt_desc.font = $fonts.page_text
    	@txt_desc.text = "Rescue them guys in the briar woods"
    	add(@txt_desc,340,198)


    	# cy += 30

    	move(0,-22)

        #clear

    end

    def dispose
        # Clear the extras!
        @window.dispose
        @page_title.dispose
        @txt_desc.dispose
        @ingredients.each{ |i| i.dispose }
    end

    def setup(potion)

        # Get the data
        data = $data.potions[potion]
        ings = data.ingredients.split("\n")

        # Clear out the previous

        # Show the title of the potion
        @page_title.icon = $cache.icon("potions/hypercurium")
        @page_title.text = data.name

        # Perhaps show a description here
        @txt_desc.text = data.description
        @cy = @txt_desc.y + @txt_desc.height


        # Add ingredients display
        ings.each{ |ing|

            item = $data.items[ing]

            new_ing = Label.new(@vp)
            new_ing.font = $fonts.page_text
            new_ing.icon = $cache.icon(item.icon)
            new_ing.text = item.name
            add(new_ing,340,@cy)

            # Now add the tick icon
            @cy += 26

            @ingredients.push(new_ing)

        }

        move(0,0)

    end

end