#==============================================================================
# ** Mnu_Items
#==============================================================================

class Mnu_Items < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('items')

		@tabs.push("all")
		#@tabs.push("potions")
		#@tabs.push("keys")

		data = $party.item_list

		@menu.list.setup(data)

		@port = Port_Full.new(vp)
		self.right.push(@port)

		@item_box = Item_Box.new(vp)
		@item_box.center(462,130)
		@item_box.hide
		self.right.push(@item_box)

	end

	def update
		super
		
	end

	def change(option)
		@info.title.text = option
		#@item_box.show
		@item_box.item(option)
		@item_box.center(462,130+@menu.list.page_idx*@menu.list.item_height)
	end

	def select(option)	
		
	end

end