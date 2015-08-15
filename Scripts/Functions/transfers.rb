WORLD_MAP_ID = 146

def transfer(map,room=nil,dir=nil)

	id = map
	id = find_map_id(map) if map.is_a?(String)
	room = map if room == nil
	$player.transfer_to(id,room,dir)

end

def transfer_cross(map,room=nil,dir=nil)
	$player.trans_type = :cross
	transfer(map,room,dir)
end

def transfer_fade(map,room=nil,dir=nil)
	$player.trans_type = :fade
	transfer(map,room,dir)
end

def transfer_cave(map,room=nil,dir=nil)
	$player.trans_type = :cave
	transfer(map,room,dir)
end

def transfer_same(dir=nil)
	id = $scene.map.id
	name = $map.events[me].name
	room = $map.find_other(name,me)
	$player.transfer_to(id,room,dir)
end

def transfer_world(dir=nil)

	# Get name of transfer
	room = $map.events[me].name

	# Do the transfer
	$player.transfer_to(WORLD_MAP_ID,room,dir)

end

def transfer_map(dir=nil)
	
	# Get name of transfer
	room = $map.events[me].name

	# Find child map
	map = find_map_id(room.split(" *")[0])

	# Do the transfer
	$player.transfer_to(map,room,dir)

end

def transfer_house_in(dir=nil)
	transfer_in(dir)
	$player.trans_type = :fade
end

def transfer_house_out(dir=nil)
	transfer_out(dir)
	$player.trans_type = :fade
end

def transfer_cave_in(dir=nil)
	transfer_in(dir)
	$player.trans_type = :cave
end

def transfer_cave_out(dir=nil)
	transfer_out(dir)
	$player.trans_type = :cave
end

def transfer_in(dir=nil)

	$player.trans_type = :cross

	# Get name of transfer
	room = $map.events[me].name

	# Find child map of name
	map = find_child_id($map.id,room)

	# If couldn't find, use default
	if map == 0
		map = find_child_id($map.id,".Indoor")
	end

	# Do the transfer
	$player.transfer_to(map,room,dir)

end

def transfer_out(dir=nil)

	$player.trans_type = :cross

	# Get name of transfer
	room = $map.events[me].name

	# Find child map
	map = find_parent_id($map.id)

	# Do the transfer
	$player.transfer_to(map,room,dir)

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