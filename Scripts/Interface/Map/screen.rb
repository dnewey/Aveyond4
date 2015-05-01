#==============================================================================
# Ui_Screen
#==============================================================================

class Ui_Screen

	attr_reader :message
  
	def initialize(vp)
		
		@message = Ui_Message.new(vp)

		@bar = Ui_Bar.new(vp)
		@info = Ui_Info.new(vp)

	end

	def update
		@message.update
		@bar.update
	end

    def busy?() 
    	return @message.busy?
    end

end