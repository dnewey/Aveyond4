#==============================================================================
# ** Mnu_Items
#==============================================================================

class Mnu_Items

	def initialize(vp)

		@title = Page_Title.new()

		@tabs = nil

		@menu = List_Common.new(vp)
		#@menu.list.select = Proc.new{}

		#@info = Info_Box.new()

		@port = Port_Full.new(vp)

	end

	def dispose
		@menu.dispose
	end

	def update
		@menu.update
	end

end