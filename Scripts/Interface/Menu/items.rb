#==============================================================================
# ** Mnu_Items
#==============================================================================

class Mnu_Items

	attr_accessor :closed

	def initialize(vp)

		@closed = false

		@title = Page_Title.new(vp)
		@title.change('inventory')

		@tabs = nil

		@menu = List_Common.new(vp)
		@menu.list.select = Proc.new{ |option| self.select(option) }
		@menu.list.cancel = Proc.new{ |option| self.cancel(option) }
		@menu.list.change = Proc.new{ |option| self.change(option) }

		data = []
		data.push('covey')
		data.push('covey')
		data.push('covey')

		@menu.list.setup(data)


		@info = Info_Box.new(vp)

		@port = Port_Full.new(vp)

		@item_box = Item_Box.new(vp)
		@item_box.center(462,130)

	end

	def dispose
		@menu.dispose
	end

	def update
		@menu.update
		@info.update
	end

	def close
		@closed = true
		@menu.hide
		@title.hide
		@info.hide
		@port.hide
	end

	def open
		@menu.show
		@title.show
		@info.show
		@port.show
		@menu.list.refresh
	end

	def change(option)
		@info.title.text = option
		@item_box.item(option)
		@item_box.center(462,130+@menu.list.page_idx*@menu.list.item_height)
	end

	def select(option)	
		
	end

	def cancel(option)
		$scene.close_sub
	end

end