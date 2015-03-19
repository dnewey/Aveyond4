#==============================================================================
# Ui_Screen
#==============================================================================

class Ui_Screen < Ui_Base
  
	def initialize
		@message = Ui_Message.new        
	end

	def update
		@message.update
	end


    def busy?() 
    	return @message.busy?
    end

end