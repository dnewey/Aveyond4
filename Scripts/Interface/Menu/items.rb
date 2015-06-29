#==============================================================================
# ** Mnu_Items
#==============================================================================

class Mnu_Items < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('items')
		#@subtitle.text = "Various items of collection"

		@tabs.push("all")
		@tabs.push("main")
		@tabs.push("side")

		@port = Port_Full.new(vp)
		self.right.push(@port)

		@item_box = Item_Box.new(vp)
		@item_box.center(472,260)
		@item_box.hide
		self.right.push(@item_box)

		# Party grid hahahha
		@grid = Ui_Grid.new(vp)
		@grid.move(@item_box.x,@item_box.y + @item_box.height + 3)
		$party.active.each{ |m|
			@grid.add_active(m)
		}
		@grid.cx = @item_box.x
		$party.reserve.each{ |m|
			@grid.add_reserve(m)
		}
		@grid.disable
		#@grid.hide
		self.right.push(@grid)

		@menu.setup_items('all')

	end

	def update
		super
		# Keep checking if item box changed
		
	end

	def change(option)
		#@item_box.show
		@item_box.item(option)
		@item_box.center(472,260)#+@menu.list.page_idx*@menu.list.row_height)
	end

	def select(option)	
		
	end

end