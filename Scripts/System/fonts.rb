
class FontManager

	attr_reader :debug, :debug_min, :debug_ttl
	attr_reader :message, :namebox

	attr_reader :list

	attr_reader :pop_ttl, :pop_text, :pop_type

	attr_reader :page_ttl, :page_text


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


		# Message box

		@message = Font.new
	    @message.name = "Georgia"
	    @message.size = 24
	    @message.color = Color.new(245,223,200)

	    @namebox = Font.new
	    @namebox.name = "Bitter"
	    @namebox.size = 28
	    @namebox.bold = true
	    @namebox.gradient = true
	    @namebox.gradient_color1 = Color.new(255,0,0)
	    @namebox.gradient_color2 = Color.new(245,223,200)


	    # Menus
	    
	    @pop_ttl = Font.new
	    @pop_ttl.name = "Verdana"
	    @pop_ttl.size = 22
	    @pop_ttl.color = Color.new(245,223,200)

	    @pop_text = Font.new
	    @pop_text.name = "Verdana"
	    @pop_text.size = 19
	    @pop_text.color = Color.new(245,223,200)

	   	@pop_type = Font.new
	    @pop_type.name = "Verdana"
	    @pop_type.size = 16
	    @pop_type.color = Color.new(245,223,200)


	    # Page 

	    @page_ttl = Font.new
		@page_ttl.name = "Georgia"
	    @page_ttl.size = 30
	    #@page_ttl.bold = true
	    @page_ttl.color = Color.new(44,44,44)

	   	@page_text = Font.new
		@page_text.name = "Georgia"
	    @page_text.size = 24
	    @page_text.color = Color.new(44,44,44)

	end

	def size(text,font)
		@scratch.font = font
		return @scratch.text_size(text)
	end

end