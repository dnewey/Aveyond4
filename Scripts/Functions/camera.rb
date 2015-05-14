#==============================================================================
# ** Camera Functions
#==============================================================================

def camera(e,spd='mid')
	$map.camera_to(gev(e),spd)
end

def camera_xy(x,y,spd='mid')
	$map.camera_xy(x,y,spd)
end

def scenecam()

end