#==============================================================================
# ** Mnu_Chooser
#==============================================================================

class Mnu_Chooser < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('items')
		#@subtitle.text = "Various items of collection"

		@port = Port_Full.new(vp)
		self.right.push(@port)

		@item_box = Item_Box.new(vp)
		@item_box.center(472,260)
		@item_box.hide
		self.right.push(@item_box)

		grant_items

		@menu.setup_items('all')

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
		self.close_soon
	end

end