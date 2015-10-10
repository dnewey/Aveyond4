#==============================================================================
# ** Mnu_Skills
#==============================================================================

class Mnu_Skills < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Skills')
		@title.icon($menu.char)

		@subtitle.text = "Master of deception"

		@menu.list.type = :skill
		@menu.list.user = $menu.char
		@menu.list.setup($party.get($menu.char).all_skill_list)

		@port = Port_Full.new(vp)
		@port.angry
		self.right.push(@port)

		@item_box = Item_Box.new(vp)
		@item_box.center(472,260)
		@item_box.type = :skill
		@item_box.hide
		self.right.push(@item_box)

		@last_option = nil

		open

	end

	def update
		
		if $input.right? || $input.mclick?
			$menu.char = $party.get_next($menu.char)
			$scene.queue_menu("Skills")
			close_soon(0)
		end

		if $input.left?
			$menu.char = $party.get_prev($menu.char)
			$scene.queue_menu("Skills")
			close_soon(0)
		end
		
		# Cancel out of grid
		if $input.cancel? || $input.rclick?
			@left.each{ |a| $tweens.clear(a) }
			@right.each{ |a| $tweens.clear(a) }
			@other.each{ |a| $tweens.clear(a) }
			$scene.queue_menu("Char")
			close_now
		end

		super

	end

	def change(option)

		@item_box.skill(option)
		@item_box.center(472,260)#+@menu.list.page_idx*@menu.list.row_height)
		
		if @last_option != option
			@last_option = option
			$tweens.clear(@item_box)
			@item_box.y -= 7
			@item_box.do(go("y",7,150,:qio))
		end

	end

	def select(option)	
		
	end

end