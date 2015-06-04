#==============================================================================
# ** Mnu_Shop
#==============================================================================

class Mnu_Shop < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('shop-buy')

		@tabs.push("all")
		#@tabs.push("potions")
		#@tabs.push("keys")

		@tabs.tab_proc = Proc.new{ |tab| self.change_tab(tab) }

		@menu.list.setup($menu.shop)

		@port = Port_Full.new(vp)
		self.right.push(@port)

		@item_box = Item_Box.new(vp)
		@item_box.center(462,130)
		self.right.push(@item_box)

		change_tab("Items")

	end

	def update
		super
		
	end

	def change(option)
		@info.title.text = option
		@item_box.item(option)
		@item_box.center(462,130+@menu.list.page_idx*@menu.list.item_height)
	end

	def select(option)	
		
	end

	def change_tab(tab)

		# Change list to certain items only
		list = []
		$menu.shop.each{ |item|
			list.push(item) if $data.items[item].category == tab
		}
		@menu.list.setup(list)

	end

end