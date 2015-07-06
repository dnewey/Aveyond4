#==============================================================================
# ** Mnu_Equip
#==============================================================================

class Mnu_Equip < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Equip')
		@title.icon($menu.char)

		@char = $party.get($menu.char)

		@subtitle.text = "Master of deception"

		#@tabs.push("all")
		#@tabs.push("potions")
		#@tabs.push("keys")

		@menu.opacity = 0
		@menu.move(15,192)
		#@menu.opacity = 0
		
		@menu.list.per_page = 7
		@menu.window.height -= 34
		@menu.list.active = false

		#@info.hide
		self.left.delete(@menu)
		
		@grid = Ui_Grid.new(vp)
		@grid.move(15,115)
		 @char.slots.each{ |slot| 
		 	@grid.add_slot(slot,@char.equips[slot])
		 }
		self.left.push(@grid)


		@port = Port_Full.new(vp)
		self.right.push(@port)

		@item_box = Item_Box.new(vp)
		@item_box.center(472,290)
		@item_box.hide
		#self.right.push(@item_box)

		# Party grid hahahha
		@users = Ui_Grid.new(vp)
		@users.move(@item_box.x,@item_box.y + @item_box.height + 3)
		#@grid.add_compare('mid-arm-windshire')
		@users.disable
		#@grid.hide
		self.right.push(@users)

		@info.dispose
		self.left.delete(@info)

		# Selected slot
		@slot = nil

		dist = 30
		@grid.all.each{ |b|
			b.x -= dist
			b.opacity = 0
     		b.do(go("x",dist,200,:qio))
     		b.do(go("opacity",255,200,:qio))
		}

		open

	end

	def dispose
		@grid.dispose
		super
	end

	def update		

		return if @closing

		@menu.update if @menu.list.active
		@grid.update if !@menu.list.active

		# Get chosen grid option
		if $input.action? || $input.click?
			choose(@grid.get_chosen)
		end

		# Cancel out of grid
		if $input.cancel? || $input.rclick?
			cancel
		end
		
		super

	end

	# Grid
	def choose(option)


		@slot = option

		# Rebuild the grid
		@grid.clear
		@grid.move(15,115)
		@grid.add_slot(@slot,@char.equips[@slot])

		@grid.disable

		# Populate the list

		# Find gear for this slot
		items = $party.items.keys.select{ |i|
			$data.items[i].is_a?(GearData) && $data.items[i].slot == @slot
		}
		items.push(nil) if @char.equips[@slot] != nil
		@menu.list.setup(items)

		# Bring in the list
		@menu.opacity = 0
		@menu.move(15,192)

		dur = 200
		dist = 30

		@menu.do(go("opacity",255,dur,:qio))
		@menu.x -= dist
		@menu.do(go("x",dist,dur,:qio))

		@menu.list.active = true

		@item_box.show
		#change(items[0])

	end

	# Equip List
	def change(option)

		# Change the item box to show this
		if option != nil
			@item_box.item(option)
			@item_box.show
			@users.clear
			@users.move(@item_box.x,@item_box.y + @item_box.height)
			@users.add_compare(option,@char)			
		else
			@item_box.hide
			@users.clear
		end
		
	end

	def select(option)	

		# Replace the gear in the slot hahahhahah
		log_scr(@slot)
		log_scr(option)
		@char.equip(@slot,option)
		back_to_slots
		
	end

	 def cancel
	 	if @grid.active
	 		$scene.queue_menu("Char")
	 		$tweens.clear(@menu)
	 		close_now
	 	else
	 		back_to_slots
	 	end
	end

	def back_to_slots

		@menu.list.active = false

		dur = 200
		dist = 30

		@menu.do(go("opacity",-255,dur,:qio))
		@menu.do(go("x",-dist,dur,:qio))

		@grid.enable
		@grid.clear
		@grid.move(15,115)
		 @char.slots.each{ |slot| 
		 	@grid.add_slot(slot,@char.equips[slot])
		 }

		 @grid.choose(@slot)

		 @item_box.hide

	end

	def close
		super

		dist = 30
		@grid.hide_glow
		@grid.all.each{ |b|
     		b.do(go("x",-dist,200,:qio))
     		b.do(go("opacity",-255,200,:qio))
		}
		self.do(delay(201))

	end

end