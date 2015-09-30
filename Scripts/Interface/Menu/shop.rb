#==============================================================================
# ** Mnu_Shop
#==============================================================================

class Mnu_Shop < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Smith')
		@subtitle.text = "Armors and Weapons"

		#@tabs.change = Proc.new{ |tab| self.change_tab(tab) }

		@magic = false

		@menu.list.type = :shop
		@menu.list.setup($menu.shop)

		@port = Port_Full.new(vp)
		self.right.push(@port)

		@item_box = Item_Box.new(vp)
		@item_box.center(472,250)
		self.right.push(@item_box)

		# Extra info grid
		@users = Ui_Grid.new(vp)
		@users.move(@item_box.x,@item_box.y + @item_box.height + 3)
		@users.disable
		# #@grid.hide
		self.right.push(@users)

		change_tab("Items")
		change($menu.shop[0])

	end

	def setup(type)
		@title.change(type)
		case type
			when "Shop"
				@subtitle.text = "General Goods"
			when "Smith"
				@subtitle.text = "Armors and Weapons"
			when "Magic"
				@subtitle.text = "Enchantments"
			when "Chester"
				@magic = true
				@subtitle.text = "Learn Skills and Abilities"
				@menu.list.type = :chester
				@menu.list.refresh
		end
	end

	def sellmode
		@sellmode = true

		# Show tabs
		@subtitle.hide

		# Put all sellable items?
		#@menu.list.setup($menu.shop)
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
		
		# Only if gear
		#

		data = $data.items[option]
		if data.is_a?(GearData)
			@users.add_users(option)
			#$party.all_battlers.select{ |b| b.slots.include?(data.slot) }.each{ |u|
			#	@users.add_compare(option,u)
			#}
		end

	end

	def select(option)			

		if @magic

			item = $data.skills[option]

			if $party.magics >= item.price
				buy_chester_skill(option)
				$party.add_magics(-item.price)
				sys("magics")
				@info.refresh
				@menu.list.refresh
			end

		else

			item = $data.items[option]

			if $party.gold >= item.price
				$party.add_item(option)
				$party.add_gold(-item.price)
				sys("coins")
				@info.refresh
				@menu.list.refresh
			end

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