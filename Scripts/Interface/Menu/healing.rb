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

		@grid.move(cx,cy)

		@grid.add_item_eater($party.active[0],$menu.use_item)

		cx += sx
		@grid.move(cx,cy)

		if $party.active.count > 1
			@grid.add_item_eater($party.active[1],$menu.use_item)
		end

		cx = 12
		cy += sy
		@grid.move(cx,cy)

		if $party.active.count > 2
			@grid.add_item_eater($party.active[2],$menu.use_item)
		end

		cx += sx
		@grid.move(cx,cy)

		if $party.active.count > 3
			@grid.add_item_eater($party.active[3],$menu.use_item)
		end

		cx = 12
		cy += sy
		@grid.move(cx,cy)

		if $party.reserve.count > 0
			@grid.add_item_eater($party.reserve[0],$menu.use_item)
		end

		cx += sx
		@grid.move(cx,cy)

		if $party.reserve.count > 1
			@grid.add_item_eater($party.reserve[1],$menu.use_item)
		end

		cx = 89
		cy += sy
		@grid.move(cx,cy)

		if $party.reserve.count > 2
			@grid.add_item_eater($party.reserve[2],$menu.use_item)
		end

	end

	def update

		ex = true
		@grid.bars.each{ |b|
			ex = false if !$tweens.done?(b)
		}

		if ex && $party.item_number($menu.use_item) == 0
			$scene.queue_menu("Items")
			close_now
		end

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

		# Is it even going to do anything?
		if $party.get(option).mp_from_item($menu.use_item) == 0
			if $party.get(option).hp_from_item($menu.use_item) == 0
				sys('deny')
				return
			end
		end

		#sys('quest')
		first = $data.items[$menu.use_item].action.split("/n")[0]
		#log_info(first)
		if first.include?('heal')
			sys('eat')
		elsif first.include?('mana')
			sys('drink')
		end

		# If cassia, do special sound

		$party.lose_item($menu.use_item)
		@item_grid.clear
		@item_grid.move(@item_box.x,@item_box.y + @item_box.height)
		@item_grid.add_stock($menu.use_item)

		# Heal mana
		if $party.get(option).mp_from_item($menu.use_item) > 0
			idx = $party.all.index(option)*2
			change = $party.get(option).mp_from_item($menu.use_item)
			@grid.bars[idx].do(go("value",change,250,:qio))	
			@grid.bars[idx].do(go("target",change,250,:qio))		
		end

		# Heal hp
		if $party.get(option).hp_from_item($menu.use_item) > 0
			idx = $party.all.index(option)*2+1
			change = $party.get(option).hp_from_item($menu.use_item)
			@grid.bars[idx].do(go("value",change,250,:qio))		
			@grid.bars[idx].do(go("target",change,250,:qio))		
		end		
		
		$party.get(option).use_item($menu.use_item)	

		setup_grid if $menu.use_item == 'cassia'
		
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