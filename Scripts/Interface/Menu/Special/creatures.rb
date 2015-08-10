#==============================================================================
# ** Mnu_Creatures
#==============================================================================

class Mnu_Creatures < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Smith')
		@subtitle.text = "Creatures"

		@tabs.tab_proc = Proc.new{ |tab| self.change_tab(tab) }

		# Auto items by boyle's level, maybe show future ones not for sale yet by 1 or 2 levels
		skills = []
		skills.push('fireburn')

		@menu.list.type = :shop
		@menu.list.setup(skills)

		@port = Port_Full.new(vp)
		self.right.push(@port)

		@item_box = Item_Box.new(vp)
		@item_box.center(472,250)
		self.right.push(@item_box)

		change_tab("Items")

	end

	def update
		super
		
	end

	def change(option)
		#@info.title.text = option
		@item_box.item(option)
		#@item_box.center(462,130+@menu.list.page_idx*@menu.list.item_height)
		@users.clear
		@users.move(@item_box.x,@item_box.y + @item_box.height)
		@users.add_users(option)
		data = $data.items[option]
		# if data.is_a?(GearData)
		# 	$party.all_battlers.select{ |b| b.slots.include?(data.slot) }.each{ |u|
		# 		@users.add_compare(option,u)
		# 	}
		# end
	end

	def select(option)	
		item = $data.items[option]
		if $party.gold >= item.price
			$party.add_item(option)
			$party.add_gold(-item.price)
			sys("coins")
		end
	end

	def change_tab(tab)
		return

		# Change list to certain items only
		list = []
		$menu.shop.each{ |item|
			list.push(item) if $data.items[item].category == tab
		}
		@menu.list.setup(list)

	end

end