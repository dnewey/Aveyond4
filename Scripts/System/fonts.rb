
class FontManager

	attr_reader :debug, :debug_min, :debug_ttl
	attr_reader :message, :message_shadow, :namebox

	attr_reader :list, :list_shadow

	attr_reader :pop_ttl, :pop_text, :pop_type

	attr_reader :page_ttl, :page_sub, :page_text

	attr_reader :hud_hp, :hud_hp_b

	attr_reader :mini, :mini_b


	def initialize

		@scratch = Bitmap.new(600,50)


		# Debug Fonts

		@debug = Font.new
	    @debug.name = "Consolas"
	    @debug.size = 22

	    @debug_min = Font.new
	    @debug_min.name = "Consolas"
	    @debug_min.size = 20

	    @debug_ttl = Font.new
	    @debug_ttl.name = "Consolas"
	    @debug_ttl.size = 28


	    # List

	    @list = Font.new
    	@list.name = "Verdana"
    	@list.size = 20 #was 26
    	@list.color = Color.new(245,223,200)

    	@list_shadow = Font.new
    	@list_shadow.name = "Verdana"
    	@list_shadow.size = 20 #was 26
    	@list_shadow.color = Color.new(0,0,0,90)


		# Message box

		@message = Font.new
	    @message.name = "Georgia"
	    @message.size = 24 #30 good for big text
	    #@message.gradient = true
	    @message.color = Color.new(245,223,200)

	    @message_shadow = Font.new
	    @message_shadow.name = "Georgia"
	    @message_shadow.size = 24
	    @message_shadow.color = Color.new(0,0,0,90)

	    @namebox = Font.new
	    @namebox.name = "Bitter"
	    @namebox.size = 30
	    @namebox.italic = true
	    @namebox.gradient = true


	    # Menus
	    
	    @pop_ttl = Font.new
	    @pop_ttl.name = "Verdana"
	    @pop_ttl.size = 22
	    @pop_ttl.color = Color.new(245,223,200)

	    @pop_text = Font.new
	    @pop_text.name = "Verdana"
	    @pop_text.size = 18
	    #@pop_text.italic = true
	    @pop_text.color = Color.new(245,223,200)

	   	@pop_type = Font.new
	    @pop_type.name = "Verdana"
	    @pop_type.size = 16
	    @pop_type.color = Color.new(245,223,200)


	    # Page 

	    @page_ttl = Font.new
		@page_ttl.name = "Georgia"
	    @page_ttl.size = 28
	    #@page_ttl.bold = true
	    @page_ttl.color = Color.new(44,44,44)

	   	@page_sub = Font.new
		@page_sub.name = "Bitter"
	    @page_sub.size = 20
	    #@page_ttl.bold = true
	    @page_sub.color = Color.new(99,99,99)

	   	@page_text = Font.new
		@page_text.name = "Georgia"
	    @page_text.size = 20
	    @page_text.color = Color.new(44,44,44)


		# Misc

		@hud_hp = Font.new
		@hud_hp.name = "Georgia"
	    @hud_hp.size = 16
	    @hud_hp.color = Color.new(255,255,255)

	    @hud_hp_b = Font.new
		@hud_hp_b.name = "Bitter"
		@hud_hp_b.bold = true
	    @hud_hp_b.size = 16
	    @hud_hp_b.color = Color.new(99,99,99)

	    @mini = Font.new
	    @mini.name = "Verdana"
	    @mini.size = 12
	    @mini.bold = true
	    @mini.color = Color.new(255,255,255)

	    @mini_b = Font.new
	    @mini_b.name = "Verdana"
	    @mini_b.size = 12
	    @mini_b.bold = true
	    @mini_b.color = Color.new(0,0,0)


	end

	def size(text,font)
		@scratch.font = font
		return @scratch.text_size(text)
	end

end