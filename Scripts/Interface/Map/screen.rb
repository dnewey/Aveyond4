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

		@popper = nil
		@grid = nil
		@item = nil

	end

	def dispose
		@message.dispose
		@bar.dispose
		@info.dispose
	end

	def hide
		@bar.hide
		@info.hide
	end
	def show
		@bar.show
		@info.show
	end

	def update

		@message.update
		@bar.update
		#@info.update
		if @popper
			@popper.update 
			if $input.action? || $input.click?
				$tweens.clear(@popper)
				@popper.dispose
				@popper = nil
			end
		end

		if @grid
			@grid.update 
			if $input.action? || $input.click?
				# Record action and close
				$menu.grid_action = @grid.get_chosen

				$tweens.clear(@grid)
				@grid.dispose
				@grid = nil
				if @item
					$tweens.clear(@item)
					@item.dispose
					@item = nil
				end
			end
		end

		if @item
			@item.update 
			if $input.action? || $input.click?
				$tweens.clear(@item)
				@item.dispose
				@item = nil
			end
		end

	  # Check inputs
	  return if busy? or $map.interpreter.running?
      if $input.cancel? || $input.rclick?
      	$game.snapshot = Graphics.snap_to_bitmap
      	open_main_menu
      end

	end

	def open_buy_item(i)
		@item = Item_Box.new(@vp)
		@item.item(i)
		@item.move($player.screen_x-@item.width,$player.screen_y-64-@item.height-40)

		# Also grid opens
		grid = open_grid
		grid.spacing = 0
		grid.x = @item.x#$player.screen_x
		grid.y = @item.y+@item.height
		grid.add_button('Buy',"Buy",'misc/unknown')
		grid.add_button('Info',"Info",'misc/unknown')
		grid.add_button('Cancel',"Cancel",'misc/unknown')
	end

	def open_sell_item(i)
		@item = Item_Box.new(@vp)
		@item.item(i)
		@item.move($player.screen_x-@item.width,$player.screen_y-64-@item.height-40)

		# Also grid opens
		grid = open_grid
		grid.spacing = 0
		grid.x = @item.x#$player.screen_x
		grid.y = @item.y+@item.height
		grid.add_button('Buy',"Buy",'misc/unknown')
		grid.add_button('Info',"Info",'misc/unknown')
		grid.add_button('Cancel',"Cancel",'misc/unknown')
	end

	def open_empty_item
		@item = Item_Box.new(@vp)
		@item.item(i)
		@item.move($player.screen_x-@item.width,$player.screen_y-64-@item.height-40)

		# Also grid opens
		grid = open_grid
		grid.spacing = 0
		grid.x = @item.x#$player.screen_x
		grid.y = @item.y+@item.height
		grid.add_button('Buy',"Buy",'misc/unknown')
		grid.add_button('Info',"Info",'misc/unknown')
		grid.add_button('Cancel',"Cancel",'misc/unknown')
	end

	def open_popper()
		@popper = Ui_Popper.new(@vp)
		return @popper
	end

	def open_grid()
		@grid = Ui_Grid.new(@vp)
		return @grid
	end

    def busy?() 
    	return @message.busy? || @item || @popper || @grid
    end

end