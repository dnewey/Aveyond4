#==============================================================================
# ** Mnu_Equipping
#==============================================================================

class Mnu_Equipping < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('equip')
		@subtitle.text = "Who will wear it?"

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

		# Fade and slide in
		dist = 30
		@grid.all.each{ |b|
			b.x -= dist
			b.opacity = 0
     		b.do(go("x",dist,200,:qio))
     		b.do(go("opacity",255,200,:qio))
		}
		@item_grid.all.each{ |b|
			b.x += dist
			b.opacity = 0
     		b.do(go("x",-dist,200,:qio))
     		b.do(go("opacity",255,200,:qio))
		}

	end

	def setup_grid

		@grid.clear

		cx = 12
		cy = 120

		sx = 151
		sy = 90

		slot = $data.items[$menu.use_item].slot

		users = $party.all_battlers.select{ |b| 
			b.slots.include?(slot) ||
			b.slots.include?(slot+'1') ||
			b.slots.include?(slot+'2') 
		}

		@grid.move(cx,cy)

		@grid.add_item_eq(users[0].id)

		cx += sx
		@grid.move(cx,cy)

		if users.count > 1
			@grid.add_item_eq(users[1].id)
		end

		cx = 12
		cy += sy
		@grid.move(cx,cy)

		if users.count > 2
			@grid.add_item_eq(users[2].id)
		end

		cx += sx
		@grid.move(cx,cy)

		if users.count > 3
			@grid.add_item_eq(users[3].id)
		end

		cx = 12
		cy += sy
		@grid.move(cx,cy)

		if users.count > 4
			@grid.add_item_eq(users[4].id)
		end

		cx += sx
		@grid.move(cx,cy)

		if users.count > 5
			@grid.add_item_eq(users[5].id)
		end

		cx = 89
		cy += sy
		@grid.move(cx,cy)

		if users.count > 6
			@grid.add_item_eq(users[6].id)
		end

	end

	def update

		ex = true
		@grid.bars.each{ |b|
			ex = false if !$tweens.done?(b)
		}

		# Cancel out of grid
		if $input.cancel? || $input.rclick?
			@left.each{ |a| $tweens.clear(a) }
			@right.each{ |a| $tweens.clear(a) }
			@other.each{ |a| $tweens.clear(a) }
			$scene.queue_menu("Items")
			close_now
		end

		# Get chosen grid option
		if ex && $input.action? || $input.click?
			choose(@grid.get_chosen)
		end

		super		

	end

	def choose(option)	

		@grid.bars.each{ |b|
			return if !$tweens.done?(b)
		}

		$menu.auto_slot = $data.items[$menu.use_item].slot
		if option == 'mys'
			$menu.auto_slot += '1'
		end
		$menu.use_item = nil

		# Jump to equip menu?
		$menu.char = option
		$scene.queue_menu("Equip")
		close_soon
		
	end


	def close
		super

		@grid.hide_glow

		# Fade and hide grid
		dist = 30
		@grid.all.each{ |b|
			next if b.disposed?
     		b.do(go("x",-dist,200,:qio))
     		b.do(go("opacity",-255,200,:qio))
		}
		@item_grid.all.each{ |b|
			next if b.disposed?
     		b.do(go("x",dist,200,:qio))
     		b.do(go("opacity",-255,200,:qio))
		}
		
	end

end