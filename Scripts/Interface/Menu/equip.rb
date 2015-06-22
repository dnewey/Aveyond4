#==============================================================================
# ** Mnu_Equip
#==============================================================================

class Mnu_Equip < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Equip')

		@char = $party.get('boy')

		@subtitle.text = "Master of deception"

		#@tabs.push("all")
		#@tabs.push("potions")
		#@tabs.push("keys")

		#@menu.hide
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

		# Selected slot
		@slot = nil

	end

	def update
		super

		@menu.update if @menu.list.active
		@grid.update if !@menu.list.active

		# Get chosen grid option
		if $input.action?
			log_scr("GO")
			choose(@grid.get_chosen)
		end

		# Cancel out of grid
		if $input.cancel?
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
		items = $data.items.values.select{ |i|
			i.is_a?(GearData) && i.slot == @slot
		}
		@menu.list.setup(items.map{|i| i.id})

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
		@item_box.item(option)
		#@item_box.comparison(option,@char.equips[@slot])
		
	end

	def select(option)	

		# Replace the gear in the slot hahahhahah

		@char.equip(@slot,option)
		back_to_slots
		
	end

	def cancel(option)

		back_to_slots
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

		 @item_box.hide

	end

end