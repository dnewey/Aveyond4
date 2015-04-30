
class FontManager

	attr_reader :debug, :debug_min, :debug_ttl
	attr_reader :message, :namebox


	def initialize

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

	end

end