#==============================================================================
# ** Mnu_Potions
#==============================================================================

class Mnu_Potions < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('potions')
		@subtitle.text = "Select a recipe"		

		@menu.list.type = :potion
		@menu.list.setup($party.potions)

		@item_box = Item_Box.new(vp)
		@item_box.center(472,260)
		@item_box.hide
		self.right.push(@item_box)

		open

	end

	def update
		super

	end

	def change(option)

		#@item_box.show
		
		@item_box.item(option)
		@item_box.center(472,260)#+@menu.list.page_idx*@menu.list.row_height)

		if @last_option != option
			@last_option = option
			$tweens.clear(@item_box)
			@item_box.y -= 7
			@item_box.do(go("y",7,150,:qio))
		end
		
	end

	def select(option)	
		$menu.chosen = option
		$party.potion_state = 'choose-recipe'
		self.close_soon
	end

end