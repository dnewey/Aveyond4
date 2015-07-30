
# Menu state
# Hold cursor positions, current character etc etc etc

class MenuState

	attr_accessor :char
	attr_accessor :shop
	attr_accessor :grid_action # <- menu selection

	attr_accessor :menu_page

	attr_accessor :menu_cursor
	attr_accessor :char_cursor

	attr_accessor :chosen

	#attr_accessor :category
	#attr_accessor :tab

	def initialize
		@char = 'boy'
		@menu_page = nil
		@shop = []

		@menu_cursor = "Journal"
		@char_cursor = 'Equip'

		@chosen = nil
	end

	def shop_init
		@shop = []
	end

	def shop_add(item)
		@shop.push(item)
	end

end