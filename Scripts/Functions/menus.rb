
def open_main_menu
	sys('action')
	$game.menu_page = "Main"
	$game.push_scene(Scene_Menu.new)
end

def open_shop_buy
	sys('action')
	$game.menu_page = "Shop"
	$game.push_scene(Scene_Menu.new)
end

def open_shop_sell
	sys('action')
	$game.menu_page = "Shop"
	$game.push_scene(Scene_Menu.new)
end
