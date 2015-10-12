
class Right_Page < SpriteGroup

	def initialize(vp)
		super()
	
        @vp = vp

		# Right side journal
		@window = Box.new(vp,300,357)
    	@window.skin = $cache.menu_common("skin-dry")
    	@window.wallpaper = $cache.menu_wallpaper("journal-full-page")
    	#@window.color = Color.new(47,45,41)
    	add(@window,320,138)

    	# Quest Name
    	@page_title = Label.new(vp)
    	@page_title.fixed_width = 250
        @page_title.icon = $cache.icon("potions/hypercurium")
        @page_title.icon_oy = -3
    	@page_title.font = $fonts.page_ttl
    	@page_title.text = "Title Text"
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
    end

    def descript(txt)

        # Perhaps show a description here
        @txt_desc.text = txt
        @cy = @txt_desc.y + @txt_desc.height

        #move(0,0)

    end

    def title(text,icon)
        @page_title.icon = $cache.icon(icon)
        @page_title.text = text
    end

end