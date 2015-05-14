


def transfer(map,room)

	id = find_map_id(map)
	$player.transfer_to(id,room)

end

def transfer_in

	# Get name of transfer
	room = $map.event_at($player.x,$player.y).name

	# Find child map
	map = find_child_id($map.id,"Indoors")

	# Do the transfer
	$player.transfer_to(map,room)

end

def transfer_up

	# Get name of transfer
	room = $map.event_at($player.x,$player.y).name

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
		next if map.name != name
		next if map.parent_id != parent_id
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