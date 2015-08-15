
# Menu state
# Hold cursor positions, current character etc etc etc

class MenuState

	attr_accessor :char
	attr_accessor :shop
	attr_accessor :grid_action # <- menu selection

	attr_accessor :menu_page
	attr_accessor :sub_only

	attr_accessor :menu_cursor
	attr_accessor :char_cursor

	# Item chosen from item list
	attr_accessor :use_item

	# Page of the potions book to keep open
	attr_accessor :potion_page

	attr_accessor :chosen

	#attr_accessor :category
	#attr_accessor :tab

	def initialize

		@char = 'boy'
		@shop = []

		@menu_page = nil
		@sub_only = false		

		@menu_cursor = "Journal"
		@char_cursor = 'Equip'

		@use_item = nil

		@potion_page = 0

		@chosen = nil
		
	end

	def shop_init
		@shop = []
	end

	def shop_add(item)
		@shop.push(item)
	end

end