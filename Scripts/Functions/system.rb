
# Misc

def text(t)
	$scene.hud.message.start(t)
end

def text_wall(w='diamonds')
	$scene.hud.message.wallpaper = w
end

def w(f=5)
	$map.interpreter.wait_count = f
end

# Camera

def camera(e,dur=nil)
	$map.camera_to(gev(e),dur)
	w 1
end

def camera_xy(x,y,dur=nil)
	$map.camera_xy(x,y,dur)
	w 1
end

def cam_oy(amount)
	$map.do(go("cam_oy",amount,amount.abs*6,:qio))
end

def cam_ox(amount)
	$map.do(go("cam_ox",amount,amount.abs*6,:qio))
end


# Menus Access

def open_main_menu
	$menu.sub_only = false
	$menu.menu_page = "Main"
end

def open_sub_menu(which)
	$menu.sub_only = true
	$menu.menu_page = which
end

def open_char_menu(who)
	$menu.sub_only = true
	$menu.char = who
	$menu.menu_page = "Char"
end

def open_potions_menu
	$menu.sub_only = true
	$menu.menu_page = "Potions"
end

def open_chooser_menu
	$menu.sub_only = true
	$menu.menu_page = "Chooser"
end

def open_potions_book
	$menu.sub_only = true
	$scene.hud.open_book
end

def open_shop_buy
	$menu.sub_only = true
	$menu.menu_page = "Shop"
end

def open_shop_sell
	$menu.sub_only = true
	$menu.menu_page = "Shop"
end

def open_shop_creatures
	$menu.sub_only = true
	$menu.menu_page = "Creatures"
end


def open_difficulty_options
	grid = $scene.hud.open_grid
	grid.x = 70
	grid.y = 60
	grid.add_difficulty('easy')
	grid.add_difficulty('mid')
	grid.add_difficulty('hard')
	return grid
end

# Fades

def fadeout(f=30)
	$scene.black.do(to("opacity",255,255/f))
	w f
end

def fadein(f=30)
	$scene.black.do(to("opacity",0,-255/f))
	w f
end

def overlay(bmp,f=30)
	$scene.overlay.bitmap = $cache.overlay(bmp)
	$scene.overlay.do(to("opacity",255,255/f))
	w f
end

def noverlay(f=30)
	$scene.overlay.do(to("opacity",0,-255/f))
	w f
end