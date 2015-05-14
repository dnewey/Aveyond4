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
				@popper.dispose
				@popper = nil
			end
		end

		if @grid
			@grid.update 
			if $input.action?
				@grid.dispose
				@grid = nil
			end
		end

		if @item
			@item.update 
			if $input.action?
				@item.dispose
				@item = nil
			end
		end

	  # Check inputs
	  return if busy? or $map.interpreter.running?
      if $input.cancel? || Input.trigger?(Input::F7)
        $game.push_scene(Scene_Menu.new)
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
		@grid.add_button('first','MEMO','faces/hib')
		@grid.add_button('sfirst','MEMO','faces/hib')
		return @grid
	end

    def busy?() 
    	return @message.busy? || @item || @popper || @grid
    end

end