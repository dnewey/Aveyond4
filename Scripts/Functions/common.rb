#==============================================================================
# ** Common Functions
#==============================================================================

def plr
	return $player
end

def me
	return $map.interpreter.event_id
end

def this
	return gev(me)
end

def gid(str)

	# empty means eid

	# If already a number send it
	if str.kind_of?(Integer)
		return str
	end

end

def gev(str)

	if str == $player
		log_info("PLAYER")
		return $player 
	end

	return str if str == this

	# Empty means this
	return this if str.nil?

	# If a number, use as id
	if str.kind_of?(Integer)
		return $map.events[str.to_i]
	end

	# Check if name of event

	# Event position

end