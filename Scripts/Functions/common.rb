#==============================================================================
# ** Common Functions
#==============================================================================

def plr
	return $player
end

def me
	return $scene.map.interpreter.event_id
end

def this
	return $map.events[me]
end

def dummy
	# return a dummy event that can be screwed around
end

def gid(str)

	# empty means eid
	return gev(str).id

end

def gev(str)


	#check for int that is in a string
	#treat as an int

	return $player if str == -1
	return $player if str == 'plr'

	if str.kind_of?(Integer)
		return $scene.map.events[str]
	end

	if str.include?(',')

			coords = str.split(",")
			# Get by coords
			return $scene.map.event_at(coords[0].to_i,coords[1].to_i)

	end

	case str

		when $player
			return $player

		when this
			return str

		when nil
			return this

		when 'up'
			return $scene.map.event_at(this.x,this.y-1) # || dummy
		when 'down'
			return $scene.map.event_at(this.x,this.y+1)
		when 'left'
			return $scene.map.event_at(this.x-1,this.y)
		when 'right'
			return $scene.map.event_at(this.x+1,this.y)
		when 'under'
			return $scene.map.lowest_event_at(this.x,this.y)
		when 'facing'
			return $scene.map.event_at(this.x,this.y-1) if $player.direction == 8
			return $scene.map.event_at(this.x,this.y+1) if $player.direction == 2
			return $scene.map.event_at(this.x-1,this.y) if $player.direction == 4
			return $scene.map.event_at(this.x+1,this.y) if $player.direction == 6

		
		else

			# Check if name of event
			ev = $scene.map.event_by_name(str)
			return ev if !ev.nil?

		end

	log_err("Can't find event: #{str}")
	return nil

end
