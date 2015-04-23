#==============================================================================
# ** Camera Functions
#==============================================================================

def camera(e)

	# Empty means player
	if e.nil?
		$map.target = $player
	else
		$map.target = gev(e)
	end

end

def camspeed

end