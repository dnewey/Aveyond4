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
	return $map.events[me]
end

def dummy
	# return a dummy event that can be screwed around
end

def gid(str)

	# empty means eid

	# If already a number send it
	if str.kind_of?(Integer)
		return str
	end

end

def gev(str)

	return $player if str == -1
	return $player if str == 'plr'

	if str.kind_of?(Integer)
		return $map.events[str]
	end

	if str.include?(',')

			coords = str.split(",")
			# Get by coords
			return $map.event_at(coords[0].to_i,coords[1].to_i)

	end

	case str

		when $player
			return $player

		when this
			return str

		when nil
			return this

		when 'up'
			return $map.event_at(this.x,this.y-1) # || dummy
		when 'down'
			return $map.event_at(this.x,this.y+1)
		when 'left'
			return $map.event_at(this.x-1,this.y)
		when 'right'
			return $map.event_at(this.x+1,this.y)
		when 'under'
			return $map.lowest_event_at(this.x,this.y)
		when 'facing'
			return $map.event_at(this.x,this.y-1) if $player.direction == 8
			return $map.event_at(this.x,this.y+1) if $player.direction == 2
			return $map.event_at(this.x-1,this.y) if $player.direction == 4
			return $map.event_at(this.x+1,this.y) if $player.direction == 6

		
		else

			# Check if name of event
			ev = $map.event_by_name(str)
			return ev if !ev.nil?

		end

	# Return some sort of dummy event
	log_info(str)
	log_err("BIGPROBLEMS")

end
