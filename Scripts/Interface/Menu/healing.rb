#==============================================================================
# ** Mnu_Healing
#==============================================================================

class Mnu_Healing < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('items')
		@subtitle.text = "Choose target of item"

		remove_menu
		remove_info

		@port = Port_Full.new(vp)
		self.right.push(@port)

		@grid = Ui_Grid.new(vp)
		self.left.push(@grid)
		setup_grid

		@item_box = Item_Box.new(vp)
		@item_box.center(472,260)
		@item_box.item($menu.use_item)
		self.right.push(@item_box)

		@item_grid = Ui_Grid.new(vp)
		@item_grid.move(@item_box.x,@item_box.y + @item_box.height)
		@item_grid.add_stock($menu.use_item)
		@item_grid.disable
		self.right.push(@item_grid)

		open

	end

	def setup_grid

		@grid.clear

		cx = 12
		cy = 120

		sx = 151
		sy = 90

		@grid.move(cx,cy)

		@grid.add_item_eater($party.active[0])

		cx += sx
		@grid.move(cx,cy)

		if $party.active.count > 1
			@grid.add_item_eater($party.active[1])
		end

		cx = 12
		cy += sy
		@grid.move(cx,cy)

		if $party.active.count > 2
			@grid.add_item_eater($party.active[2])
		end

		cx += sx
		@grid.move(cx,cy)

		if $party.active.count > 3
			@grid.add_item_eater($party.active[3])
		end

		cx = 12
		cy += sy
		@grid.move(cx,cy)

		if $party.reserve.count > 0
			@grid.add_item_eater($party.reserve[0])
		end

		cx += sx
		@grid.move(cx,cy)

		if $party.reserve.count > 1
			@grid.add_item_eater($party.reserve[1])
		end

		cx = 89
		cy += sy
		@grid.move(cx,cy)

		if $party.reserve.count > 2
			@grid.add_item_eater($party.reserve[2])
		end

	end

	def update

		# If anim in done, change state
		if $input.cancel? || $input.rclick?
			close_now
			$scene.queue_menu("Items")
		end

		super		
	end

	def change(option)

		
	end

	def select(option)	
		
	end

end