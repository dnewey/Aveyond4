#==============================================================================
# Ui_Screen
#==============================================================================

class Ui_Screen

	attr_reader :message
  
	def initialize(vp)

		@vp = vp
		
		@message = Ui_Message.new(vp)

		@bar = Ui_Bar.new(vp)
		#@bar.hide
		
		@info = Ui_Info.new(vp)


		@shop = nil
		@popper = nil
		@grid = nil
		@item = nil

	end

	def update
		@message.update
		@bar.update
		#@info.update
		if @popper
			@popper.update 
			if $input.action?
				$tweens.clear(@popper)
				@popper.dispose
				@popper = nil
			end
		end

		if @grid
			@grid.update 
			if $input.action?
				$tweens.clear(@grid)
				@grid.dispose
				@grid = nil
			end
		end

		if @item
			@item.update 
			if $input.action?
				$tweens.clear(@item)
				@item.dispose
				@item = nil
			end
		end

		if @shop
			@shop.update 
			if $input.action?
				$tweens.clear(@shop)
				@shop.dispose
				@shop = nil
			end
		end

	  # Check inputs
	  return if busy? or $map.interpreter.running?
      if $input.cancel? || $input.rclick?
      	open_main_menu
      end

	end

	def open_item(i)
		@item = Item_Box.new(@vp)
		@item.item(i)
		@item.move(40,40)
	end

	def open_popper()
		@popper = Ui_Popper.new(@vp)
		return @popper
	end

	def open_grid()
		@grid = Ui_Grid.new(@vp)
		return @grid
	end

	def open_shop()
		@shop = Ui_Shop.new(@vp)
		return @shop
	end

    def busy?() 
    	return @message.busy? || @item || @popper || @grid || @shop
    end

end