#==============================================================================
# ** Camera Functions
#==============================================================================

def camera(e,spd=0.15)
	$map.camera_to(gev(e),spd)
end

def camera_xy(x,y,spd=0.15)
	$map.camera_xy(x,y,spd)
end

def scenecam()

end