#==============================================================================
# ** Mnu_Main
#==============================================================================

class Mnu_Main

	def initialize(vp)

		@menu = List_Main.new(vp)
		#@menu.list.select = Proc.new{}

		# Character Boxes
		# @char_boxes = []
		#@char_boxes.push(CHARBOX.new)

		@charbox = Char_Box_Large.new(vp)
		@charbox.move(196,25)

		@charbox2 = Char_Box_Large.new(vp)
		@charbox2.move(416,25)


		@charbox3 = Char_Box_Large.new(vp)
		@charbox3.move(196,202)

		@charbox4 = Char_Box_Large.new(vp)
		@charbox4.move(416,202)

	end

	def dispose
		@menu.dispose
	end

	def update
		@menu.update
	end

end