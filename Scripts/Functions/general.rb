#==============================================================================
# ** General Functions
#==============================================================================

def text()

end

def w(f=5)
	$map.interpreter.wait_count = f
end

def fadeout(f=30)
	$scene.overlay.do(to("opacity",255,255/f))
	w f
end

def fadein(f=30)
	$scene.overlay.do(to("opacity",0,-255/30))
	w f
end

def fade(ev)
	gev(ev).do(go("opacity",-255,300))
end

def gfx(ev,name)
	gev(ev).character_name = name	
end

def cam_oy(amount)
	$map.do(go("cam_oy",amount,amount.abs*6,:qio))
end

def cam_ox(amount)
	$map.do(go("cam_ox",amount,amount.abs*6,:qio))
end
