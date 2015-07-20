
class Right_Journal < SpriteGroup

	def initialize(vp)
		super()
	
		# Right side journal
		@window = Box.new(vp,300,292)
    	@window.skin = $cache.menu_common("skin-dry")
    	@window.wallpaper = $cache.menu_wallpaper("journal_page_line")
    	#@window.color = Color.new(47,45,41)
    	add(@window,320,140)

    	# Quest Name
    	@page_title = Label.new(vp)
    	@page_title.fixed_width = 250
    	@page_title.font = $fonts.page_ttl
    	@page_title.text = "Board the Ferry"
    	add(@page_title,340,154)

    	# # SUBTEXTS!!!!!!!!!!

    	# cy = 180

    	# # ALWAYS DESCRIPTION

    	@txt_desc = Area.new(vp)
    	@txt_desc.fixed_width =  260
    	@txt_desc.font = $fonts.page_text
    	@txt_desc.text = "Rescue them guys in the briar woods"
    	add(@txt_desc,340,198)

    	# Subtitles ready for later
    	@sub_req = Sprite.new(vp)
    	@sub_req.bitmap = $cache.menu_page("tasks")
    	@sub_zone = Sprite.new(vp)
    	@sub_zone.bitmap = $cache.menu_page("location")

    	# Text sprites

        @txt_req1 = Label.new(vp)
        @txt_req1.font = $fonts.page_text

        @txt_req2 = Label.new(vp)
        @txt_req2.font = $fonts.page_text

        @txt_req3 = Label.new(vp)
        @txt_req3.font = $fonts.page_text

    	@txt_zone = Label.new(vp)
    	@txt_zone.font = $fonts.page_text

    	# cy += 30

    	move(0,0)

        #clear

    end

    def dispose
        # Clear the extras!
        @window.dispose
        @page_title.dispose
        @txt_desc.dispose
        @sub_req.dispose
        @txt_req1.dispose
        @txt_req2.dispose
        @txt_req3.dispose
        @sub_zone.dispose
        @txt_zone.dispose
    end

    def title=(text)
        @page_title.text = text
    end

    def description=(text)
        @txt_desc.text = text
        @cy = @txt_desc.y + @txt_desc.height
    end

    def clear

    	# Clear the extras!
    	@sub_req.hide
    	@txt_req1.hide
        @txt_req2.hide
        @txt_req3.hide
    	@sub_zone.hide
    	@txt_zone.hide

    end

    def add_reqs(reqs)
        @sub_req.show
        @sub_req.move(340,@cy)
        @cy += 22

        log_info(reqs)

        num = 1

        # Per req
        reqs.split(" | ").each{ |req|

            txt_req = @txt_req1 if num == 1
            txt_req = @txt_req2 if num == 2
            txt_req = @txt_req3 if num == 3

            dta = req.split("=>")
            if dta[0] == 'item'
                item = $data.items[dta[1]]
                txt_req.icon = $cache.icon(item.icon)
                name = item.name
                name += " x #{dta[2]}" if dta[2].to_i > 1
                txt_req.text = name
                txt_req.show
                txt_req.move(340,@cy)
                @cy += txt_req.height
            end

            num += 1
        }
    end

    def add_zone(zone)
    	@sub_zone.show
    	@sub_zone.move(340,@cy)
    	@cy += 22
    	@txt_zone.icon = $cache.icon("items/map")
    	@txt_zone.text = "Whisper Woods"
    	@txt_zone.show
    	@txt_zone.move(340,@cy)
    	@cy += @txt_zone.height
    end

end