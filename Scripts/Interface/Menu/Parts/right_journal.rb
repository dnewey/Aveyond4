
class Right_Journal < SpriteGroup

	def initialize(vp)
		super()
	
        # Right side journal
        @window = Box.new(vp,300,357)
        @window.skin = $cache.menu_common("skin-dry")
        @window.wallpaper = $cache.menu_wallpaper("journal-full-page")
        #@window.color = Color.new(47,45,41)
        add(@window,320,138)

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
    	@sub_req.bitmap = $cache.menu_page("reqs")
        add(@sub_req,340)

    	@sub_zone = Sprite.new(vp)
    	@sub_zone.bitmap = $cache.menu_page("location")
        add(@sub_zone,340)

    	# Text sprites

        @txt_req1 = Label.new(vp)
        @txt_req1.font = $fonts.page_text
        add(@txt_req1,340)

        @txt_req2 = Label.new(vp)
        @txt_req2.font = $fonts.page_text
        add(@txt_req2,340)

        @txt_req3 = Label.new(vp)
        @txt_req3.font = $fonts.page_text
        add(@txt_req3,340)

        @txt_req4 = Label.new(vp)
        @txt_req4.font = $fonts.page_text
        add(@txt_req4,340)

        @txt_req5 = Label.new(vp)
        @txt_req5.font = $fonts.page_text
        add(@txt_req5,340)

    	@txt_zone = Label.new(vp)
    	@txt_zone.font = $fonts.page_text
        add(@txt_zone,340)

    	# cy += 30

    	move(0,-22)

        clear

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
        @txt_req4.dispose
        @txt_req5.dispose
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
        @txt_req4.hide
        @txt_req5.hide

    	@sub_zone.hide
    	@txt_zone.hide

    end

    def add_reqs(reqs)

        return if reqs == ''
        return if reqs == nil

        @sub_req.show
        @sub_req.move(340,@cy)
        @cy += 22

        #log_info(reqs)

        req_num = 1

        # Per req
        # Per req
        reqs.split("\n").each{ |req|

            txt_req = @txt_req1 if req_num == 1
            txt_req = @txt_req2 if req_num == 2
            txt_req = @txt_req3 if req_num == 3
            txt_req = @txt_req4 if req_num == 4
            txt_req = @txt_req5 if req_num == 5

            txt_req.show

            dta = req.split("=>")
            case dta[0] 
                when 'item'
                    item = $data.items[dta[1]]
                    icon = item.icon
                    name = item.name
                    num = $party.item_number(dta[1])

                    name += " #{num}/#{dta[2]}" if dta[2].to_i > 1    

                    if num >= dta[2].to_i
                        txt_req.font = $fonts.page_text_color
                    else
                        txt_req.font = $fonts.page_text
                    end

                when 'var'
                    icon = 'misc/profile'
                    num = $state.varval(dta[1])
                    name = "#{dta[3]} #{num}/#{dta[2]}"

                    if num >= dta[2].to_i
                        txt_req.font = $fonts.page_text_color
                    else
                        txt_req.font = $fonts.page_text
                    end

                when 'flag'
                    icon = 'misc/profile'
                    name = "#{dta[2]}"
                    
                when 'gold'
                    icon = 'misc/coins'
                    name = "#{dta[1]} gold"
            end


            txt_req.text = name
            txt_req.icon = $cache.icon(icon)
            txt_req.show
            #txt_req.move(340,@cy)
            txt_req.y = @cy
            @cy += txt_req.height

            req_num += 1
        }

    end

    def add_zone(zone)
        return if zone == ''
    	@sub_zone.show
    	@sub_zone.move(340,@cy)
    	@cy += 22
    	@txt_zone.icon = $cache.icon("items/map")
    	@txt_zone.text = zone
    	@txt_zone.show
    	@txt_zone.move(340,@cy)
    	@cy += @txt_zone.height
    end

end