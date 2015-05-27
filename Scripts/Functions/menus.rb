
def open_main_menu
	$game.menu_page = "Main"
	$game.push_scene(Scene_Menu.new)
end

def open_shop_buy
	$game.menu_page = "Shop"
	$game.push_scene(Scene_Menu.new)
end

def open_shop_sell
	$game.menu_page = "Shop"
	$game.push_scene(Scene_Menu.new)
end
