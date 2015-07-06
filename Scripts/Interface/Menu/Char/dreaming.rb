#==============================================================================
# ** Mnu_Dreaming
#==============================================================================

class Mnu_Dreaming < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Dreaming')
		@title.icon($menu.char)

		@char = $party.get('boy')

		@subtitle.text = "Master of deception"

		#@tabs.push("all")
		#@tabs.push("potions")
		#@tabs.push("keys")

		@menu.opacity = 0
		@menu.move(15,180)
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
		#@grid.add_slot('staff',char.equips['staff'])
		self.left.push(@grid)


		@port = Port_Full.new(vp)
		self.right.push(@port)

		@item_box = Item_Box.new(vp)
		@item_box.center(472,290)
		@item_box.hide
		#self.right.push(@item_box)

		@info.dispose
		self.left.delete(@info)

		# Selected slot
		@slot = nil

	end

	def update
		super

		@menu.update if @menu.list.active
		@grid.update if !@menu.list.active

		# Get chosen grid option
		if $input.action? || $input.click?
			log_scr("GO")
			choose(@grid.get_chosen)
		end

		# Cancel out of grid
		if $input.cancel? || $input.rclick?
			@left.each{ |a| $tweens.clear(a) }
			@right.each{ |a| $tweens.clear(a) }
			@other.each{ |a| $tweens.clear(a) }
			close
		end
		
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
		@menu.opacity = 255
		@menu.move(15,180)

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
		else
			@item_box.hide
		end
		#@item_box.comparison(option,@char.equips[@slot])
		
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
	 		$scene.change_sub("Char")
	 		super
	 	else
	 		back_to_slots
	 	end
	end

	def back_to_slots
		@menu.opacity = 0
		@menu.move(15,180)

		@menu.list.active = false

		@grid.enable
		@grid.clear
		@grid.move(15,115)
		 @char.slots.each{ |slot| 
		 	@grid.add_slot(slot,@char.equips[slot])
		 }

		 @grid.choose(@slot)

		 @item_box.hide

	end

end