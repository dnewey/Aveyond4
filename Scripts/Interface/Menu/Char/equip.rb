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
		super
		@menu.dispose
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
			$data.items[i].is_a?(GearData) && $data.items[i].slot == @slot.delete("12")
		}
		items.push('remove') if @char.equips[@slot] != nil
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
		change(items[0])

	end

	# Equip List
	def change(option)

		gear = option
		gear = nil if option == 'remove'

		# Change the item box to show this
		if option != 'remove'
			@item_box.item(option)
			@item_box.show
		else
			@item_box.hide			
		end

		# Get comparison
		result = @char.equip_result_mega(gear,@slot)
		stats = ['hp','mp','str','def','luk','eva','res']

		@users.clear
		@users.move(@item_box.x,@item_box.y + @item_box.height)
		(0..6).each{ |i|
			if result[2][i] != 0
				@users.add_compare(stats[i],result[0][i],result[1][i],result[2][i])			
			end
		}

		if result[2] == [0,0,0,0,0,0,0]
			@users.add_nochange
		end
		
		
	end

	def select(option)	

		gear = option
		gear = nil if option == 'remove'

		# Replace the gear in the slot hahahhahah
		@char.equip(@slot,gear)
		back_to_slots
		
	end

	 def cancel
	 	if @grid.active
	 		$scene.queue_menu("Char")
	 		$tweens.clear(@menu)
	 		#close_now
	 		start_close
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

		 @grid.choose(@slot,true)

		 @item_box.hide
		 @users.clear

	end

	def start_close
		

		dist = 30
		@grid.hide_glow
		@grid.all.each{ |b|
			next if b.disposed?
     		b.do(go("x",-dist,200,:qio))
     		b.do(go("opacity",-255,200,:qio))
		}
		
		close_soon(0)

		#super

	end

end