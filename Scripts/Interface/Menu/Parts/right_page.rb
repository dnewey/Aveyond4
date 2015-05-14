
class Right_Page < SpriteGroup

	def initialize(vp)
		super()
	
		# Right side journal
		@window = Box.new(vp,300,360)
    	@window.skin = $cache.menu_common("skin-dry")
    	@window.wallpaper = $cache.menu_wallpaper("journal_page_line")
    	#@window.color = Color.new(47,45,41)
    	add(@window,320,110)

    	# Quest Name
    	@page_title = Label.new(vp)
    	@page_title.fixed_width = 250
    	@page_title.font = $fonts.page_ttl
    	@page_title.text = "Board the Ferry"
    	add(@page_title,340,127)



    	# # SUBTEXTS!!!!!!!!!!

    	# cy = 180

    	# # ALWAYS DESCRIPTION

    	@txt_desc = Area.new(vp)
    	@txt_desc.fixed_width =  260
    	@txt_desc.font = $fonts.page_text
    	@txt_desc.text = "Rescue them guys in the briar woods"
    	add(@txt_desc,340,180)

    	# Subtitles ready for later
    	@sub_req = Sprite.new(vp)
    	@sub_req.bitmap = $cache.menu_page("tasks")
    	@sub_zone = Sprite.new(vp)
    	@sub_zone.bitmap = $cache.menu_page("location")
    	@sub_reward = Sprite.new(vp)
    	@sub_reward.bitmap = $cache.menu_page("reward")

    	# Text sprites

        @txt_req = Label.new(vp)
        @txt_req.font = $fonts.page_text

    	@txt_zone = Label.new(vp)
    	@txt_zone.font = $fonts.page_text
	
    	@txt_reward = Label.new(vp)
    	@txt_reward.font = $fonts.page_text

    	# cy += 30

    	move(0,0)

    	@cy = 180 + @txt_desc.height

    end

    def dispose
        # Clear the extras!
        @window.dispose
        @page_title.dispose
        @txt_desc.dispose
        @sub_req.dispose
        @txt_req.dispose
        @sub_zone.dispose
        @txt_zone.dispose
        @sub_reward.dispose
        @txt_reward.dispose
    end

    def title=(text)
        @page_title.text = text
    end

    def description=(text)
        @txt_desc.text = text
    end

    def clear

    	# Clear the extras!
    	@sub_req.hide
    	@txt_req.hide
    	@sub_zone.hide
    	@txt_zone.hide
    	@sub_reward.hide
    	@txt_reward.hide

    	@cy = 180 + @txt_desc.height

    end

    def add_reqs(reqs)

    end

    def add_zone(zone)
    	@sub_zone.show
    	@sub_zone.move(340,@cy)
    	@cy += 26
    	@txt_zone.icon = $cache.icon("items/map")
    	@txt_zone.text = "Whisper Woods"
    	@txt_zone.show
    	@txt_zone.move(340,@cy)
    	@cy += @txt_zone.height
    end

    def add_reward(reward)

    end

end