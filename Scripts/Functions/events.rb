#==============================================================================
# ** Event Functions
#==============================================================================

# Event lookups

def gid(str)

	# empty means eid

end

def gev(str)

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