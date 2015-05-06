#==============================================================================
# Ui_Screen
#==============================================================================

class Ui_Screen

	attr_reader :message
  
	def initialize(vp)

		@vp = vp
		
		@message = Ui_Message.new(vp)

		@bar = Ui_Bar.new(vp)
		#@info = Ui_Info.new(vp)

		@item = nil

	end

	def update
		@message.update
		@bar.update
		#@info.update

		if @item
			@item.update 
			if $input.action?
				@item.dispose
				@item = nil
			end
		end
	end

	def open_item(i)
		@item = Item_Box.new(@vp)
		@item.item(i)
		@item.move(40,40)
	end

    def busy?() 
    	return @message.busy? || @item
    end

end