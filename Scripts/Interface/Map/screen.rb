#==============================================================================
# Ui_Screen
#==============================================================================

class Ui_Screen

	attr_reader :message, :bar
  
	def initialize(vp)

		@vp = vp
		
		@message = Ui_Message.new(vp)

		@bar = Ui_Bar.new(vp)
		#@bar.hide
		
		@info = Ui_Info.new(vp,@message)

		@popper = nil
		@grid = nil
		@item = nil

		@book = nil

		@blackbars = Sprite.new(vp)
		@blackbars.bitmap = $cache.menu_common('black-bars')
		@blackbars.opacity = 0

	end

	def dispose
		@message.dispose
		@bar.dispose
		@info.dispose
	end

	def blackbars
		hide
		@blackbars.do(go('opacity',255,1000,:qio))
		@blackbars.zoom_x = 1.2
		@blackbars.zoom_y = 1.2
		@blackbars.do(go('zoom_x',-0.2,1000,:qio))
		@blackbars.do(go('zoom_y',-0.2,1000,:qio))		
	end

	def quickbars
		@blackbars.opacity = 255
		hide
	end

	def nobars
		@blackbars.do(go('opacity',-255,1000,:qio))
		show
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

		if !$settings.bottombar
			@info.move(0,447)
			@bar.move(0,480)
		else
			@info.move(0,415)
			@bar.move(0,480-32)
		end

		@message.update
		@bar.update
		@info.update
		if @popper
			@popper.update 
			if $input.action? || $input.click?
				$tweens.clear(@popper)
				@popper.dispose
				sys('next')
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

		if @book
			@book.update 
			if $input.action? || $input.cancel? || $input.rclick?
				$tweens.clear(@book)
				@book.dispose
				@book = nil
			end
		end

	  # Check inputs
	  return if busy? or $map.interpreter.running?
	  return if $party.leader == "minion-fang"
      if $input.cancel? || $input.rclick?
      	$menu.player_x = $player.screen_x
      	$menu.player_y = $player.screen_y
      	open_main_menu
      end

      # if $keyboard.press?(VK_J)
      # 	$menu.player_x = $player.screen_x
      # 	$menu.player_y = $player.screen_y
      # 	open_sub_menu("Journal")
      # end

      # if $keyboard.press?(VK_I)
      # 	$menu.player_x = $player.screen_x
      # 	$menu.player_y = $player.screen_y
      # 	open_sub_menu("Items")
      # end

      # if !$party.reserve.empty? && $keyboard.press?(VK_P)
      # 	$menu.player_x = $player.screen_x
      # 	$menu.player_y = $player.screen_y
      # 	open_sub_menu("Party")
      # end

	end

	def open_buy_item(i)

		@item = Item_Box.new(@vp)
		@item.show_price
		@item.item(i)
		@item.move($player.screen_x-@item.width/2,$player.screen_y-64-@item.height)

		# Also grid opens
		grid = open_grid
		grid.spacing = 0
		grid.x = @item.x#$player.screen_x
		grid.y = @item.y+@item.height + 64
		grid.add_button('Buy',"Buy",'misc/coins')
		grid.add_button('Info',"Info",'misc/dots')
		grid.add_button('Exit',"Exit",'misc/cross')

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

	def open_book()
		@book = Ui_Book.new(@vp)
	end

	def quest_sparkle(icon)
		@bar.add_quest(icon)
	end

    def busy?() 
    	return @message.busy? || @item || @popper || @grid || @book
    end

end