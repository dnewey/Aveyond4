#==============================================================================
# ** General Functions
#==============================================================================

def text()

end

def w(f=5)

end

def fadeout
	$scene.overlay.do(to("opacity",255,2))
end

def fadein
	$scene.overlay.do(to("opacity",0,2))
end

def fade(ev)
	log_info(ev)
	gev(ev).do(to("opacity",0,2))
end