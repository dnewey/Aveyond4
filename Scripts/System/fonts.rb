
class FontManager

	attr_reader :message, :namebox

	def initialize

		@message = Font.new
	    @message.name = "Georgia"
	    @message.size = 26
	    @message.color = Color.new(245,223,200)

	    @namebox = Font.new
	    @namebox.name = "Georgia"
	    @namebox.size = 28
	    @namebox.bold = true
	    @namebox.gradient = true
	    @namebox.gradient_color1 = Color.new(255,0,0)
	    @namebox.gradient_color2 = Color.new(245,223,200)

	end

end