#==============================================================================
# ** Mnu_Chooser
#==============================================================================

class Mnu_Chooser < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('choose')
		#@title.change_icon("items")
		@subtitle.text = "Pick & Choose"

		@port = Port_Full.new(vp)
		self.right.push(@port)

		@item_box = Item_Box.new(vp)
		@item_box.center(472,260)
		@item_box.hide
		self.right.push(@item_box)

		#grant_items

		@menu.setup_items($menu.choose_cat)

		open

	end

	def update
		super
		# Keep checking if item box changed
		
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
		$map.need_refresh = true
		#flag('have-chosen')
		#potion_state 'choose-item'
		self.close_soon
	end

end