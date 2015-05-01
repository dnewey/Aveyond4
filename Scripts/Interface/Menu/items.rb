#==============================================================================
# ** Mnu_Items
#==============================================================================

class Mnu_Items

	attr_accessor :closed

	def initialize(vp)

		@closed = false

		@title = Page_Title.new(vp)

		@tabs = nil

		@menu = List_Common.new(vp)
		@menu.list.select = Proc.new{ |option| self.select(option) }
		@menu.list.cancel = Proc.new{ |option| self.cancel(option) }
		@menu.list.change = Proc.new{ |option| self.change(option) }

		#@menu.list.select = Proc.new{}

		@info = Info_Box.new(vp)

		@port = Port_Full.new(vp)

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
	end

	def select(option)	
		
	end

	def cancel(option)
		$scene.close_sub
	end

end