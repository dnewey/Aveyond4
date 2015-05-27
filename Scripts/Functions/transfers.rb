WORLD_MAP_ID = 25

def transfer(map,room)

	id = find_map_id(map)
	$player.transfer_to(id,room)

end

def transfer_world

	# Get name of transfer
	room = $map.events[me].name

	# Do the transfer
	$player.transfer_to(25,room)

end

def transfer_map
	
	# Get name of transfer
	room = $map.events[me].name

	# Find child map
	map = find_map_id(room.split(" *")[0])

	# Do the transfer
	$player.transfer_to(map,room)

end

def transfer_in

	# Get name of transfer
	room = $map.events[me].name

	# Find child map of name
	map = find_child_id($map.id,room)

	# If couldn't find, use default
	if map == 0
		map = find_child_id($map.id,".Indoor")
	end

	# Do the transfer
	$player.transfer_to(map,room)

end

def transfer_out

	# Get name of transfer
	room = $map.events[me].name

	# Find child map
	map = find_parent_id($map.id)

	# Do the transfer
	$player.transfer_to(map,room)

end


def find_parent_id(map_id)
	return $data.mapinfos[map_id].parent_id
end

def find_child_id(parent_id,name)

	$data.mapinfos.each{ |k,map|
		next if map.parent_id != parent_id
		next if map.name.split(" @")[0] != name
		return k
	}

	return 0

 end

 def find_map_id(name)

	$data.mapinfos.each{ |k,map|
		return k if map.name == name
	}

	return 0

 end