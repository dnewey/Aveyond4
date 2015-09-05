#==============================================================================
# ** Mnu_Items
#==============================================================================

class Mnu_Items < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('items')
		#@subtitle.text = "Various items of collection"

		@tabs.push("all")
		@tabs.push("usable")
		@tabs.push("keys")
		@tabs.push("shop")

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

		tab('all')

		open

	end

	def update

		return if !$tweens.done?(@port)
		super		
	end

	def tab(option)

		# Reload the quest list limited to this tab
		data = $party.items.keys

		if option == 'all'
			data = data.select{ |q| $data.items[q].tab != 'gear' }
		end

		if option == "usable"
			data = data.select{ |q| $data.items[q].tab == 'usable' }
		end

		if option == "keys"
			data = data.select{ |q| $data.items[q].tab == 'keys' }
		end

		if option == "shop"
			data = data.select{ |q| $data.items[q].tab == 'shop' }
		end

		@menu.list.setup(data)
		@menu.list.slide

		change(data[0])

	end

	def change(option)

		#@item_box.show
		
		@item_box.item(option)
		@item_box.center(472,260)#+@menu.list.page_idx*@menu.list.row_height)

		item = $data.items[option]

		@grid.all.each{ |i| $tweens.clear(i) }
		@grid.clear

		@grid.move(@item_box.x,@item_box.y + @item_box.height)

		# If gear, show the +-
		if item.is_a?(GearData)
			@grid.add_users(option)
		end

		if item.is_a?(UsableData)

			# If healing, show results
			if item.action.include?('mana')
				@grid.add_mana(option)
			end

		end

		@grid.disable

		if @last_option != option
			@last_option = option

			$tweens.clear(@item_box)

			@item_box.y -= 7
			@item_box.do(go("y",7,150,:qio))

			@grid.all.each{ |i|
				next if i.disposed?
				i.y -= 7
				i.do(go("y",7,150,:qio))
			}
		end
		
	end

	def select(option)	

		return if !$data.items[option].is_a?(UsableData)

		scope = $data.items[option].scope
		
		# If item needs a target, do it
		case scope

			when 'ally'
				$menu.use_item = option
				$scene.queue_menu("Healing")
				close_soon

			when 'common'
				$menu.common_event = $data.items[option].action.split("=>")[1].to_i
				close_soon

		end

	end

	def close

		super

		# Fade and hide grid
		dist = 30
		@grid.all.each{ |b|
			next if b.disposed?
     		b.do(go("x",dist,200,:qio))
     		b.do(go("opacity",-255,200,:qio))
		}
		
	end

end