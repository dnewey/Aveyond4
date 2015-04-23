#==============================================================================
# ** General Functions
#==============================================================================

def text()

end

def w(f=5)
	$map.interpreter.wait_count = f
end

def fadeout
	$scene.overlay.do(to("opacity",255,7))
end

def fadein
	$scene.overlay.do(to("opacity",0,7))
end

def fade(ev)
	log_info(ev)
	gev(ev).do(to("opacity",0,2))
end