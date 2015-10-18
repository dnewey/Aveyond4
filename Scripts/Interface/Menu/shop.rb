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
		@tab = ''

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

		#change_tab("Items")
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
				@item_box.type = :skill
				change($menu.shop[0])
		end
	end

	def sellmode
		@sellmode = true

		@menu.list.type = :sell

		# Show tabs
		@subtitle.hide
		@tabs.change = Proc.new{ |tab| self.change_tab(tab) }

		#@tabs.push("all")
		@tabs.push("usable")
		@tabs.push("gear")

		# Put all sellable items?
		change_tab("usable")



	end

	def update
		super
		
	end

	def change(option)

		#@info.title.text = option
		@item_box.item(option)
		@item_box.center(472,260)

		#@item_box.center(462,130+@menu.list.page_idx*@menu.list.item_height)
		@users.all.each{ |i| $tweens.clear(i) }
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

		if @sellmode
			@users.clear
			@users.move(@item_box.x,@item_box.y + @item_box.height)
			@users.add_stock(option)
		end	

		if @last_option != option
			@last_option = option

			$tweens.clear(@item_box)

			@item_box.y -= 7
			@item_box.do(go("y",7,150,:qio))

			@users.all.each{ |i|
				next if i.disposed?
				$tweens.clear(i)
				i.y -= 7
				i.do(go("y",7,150,:qio))
			}

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
				close_soon
			else
				sys("deny")
			end

		else

			item = $data.items[option]

			if @sellmode

				# Buy
				$party.add_item(option,-1)
				$party.add_gold(item.price/2)
				sys('coins')
				@info.refresh
				@menu.list.refresh
				change_tab(@tab)

			else

				# Buy

				if $party.gold >= item.price
					$party.add_item(option)
					$party.add_gold(-item.price)
					sys("coins")
					@info.refresh
					@menu.list.refresh
				else
					sys("deny")
				end

			end

		end
	end

	def change_tab(tab)

		page_idx = @menu.list.page_idx

		# Change list to certain items only
		# This is for selling
		list = []
		$party.items.keys.each{ |item|
			next if $data.items[item].price == ''
			next if $data.items[item].tab != tab
			list.push(item) 
		}
		@menu.list.setup(list)

		if tab == @tab
			@menu.list.set_idx(page_idx,0)
		end
		@tab = tab

		change(list[@menu.list.idx])

	end

end