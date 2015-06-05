#==============================================================================
# ** Mnu_Items
#==============================================================================

class Mnu_Items < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('items')
		@subtitle.text = "Various items of collection"

		@tabs.push("all")
		@tabs.push("main")
		@tabs.push("side")

		data = $party.item_list

		@menu.list.setup(data)

		@port = Port_Full.new(vp)
		self.right.push(@port)

		@item_box = Item_Box.new(vp)
		@item_box.center(462,180)
		@item_box.hide
		self.right.push(@item_box)

		grant_items

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