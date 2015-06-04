
# Misc

def text()

end

def w(f=5)
	$map.interpreter.wait_count = f
end

# Camera

def camera(e,spd='mid')
	$map.camera_to(gev(e),spd)
end

def camera_xy(x,y,spd='mid')
	$map.camera_xy(x,y,spd)
end

def cam_oy(amount)
	$map.do(go("cam_oy",amount,amount.abs*6,:qio))
end

def cam_ox(amount)
	$map.do(go("cam_ox",amount,amount.abs*6,:qio))
end

# Audio

def sfx(file,vol=1.0)
	$audio.sfx(file,vol)
end

def sys(file,vol=1.0)
	$audio.sys(file,vol)
end

def music(file,vol=1.0)
	$audio.music(file,vol)
end

# Menus Access

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

# Fades

def fadeout(f=30)
	$scene.overlay.do(to("opacity",255,255/f))
	w f
end

def fadein(f=30)
	$scene.overlay.do(to("opacity",0,-255/30))
	w f
end