WORLD_MAP_ID = 146

def start_transfer(map,room=nil,dir=nil)

	id = map
	id = find_map_id(map) if map.is_a?(String)
	room = map if room == nil
	$player.transfer_to(id,room,dir)

end

# instant jump to another map
def transfer_scene(map,room=nil,dir=nil)

	id = map
	id = find_map_id(map) if map.is_a?(String)
	room = map if room == nil
	$map.setup id


      ev = gev(room)
      
	    case dir
	      when 'd'
	        $player.direction = 2
	      when 'l'
	        $player.direction = 4
	      when 'r'
	        $player.direction = 6
	      when 'u'
	        $player.direction = 8
	    end

      dx = 0
      dy = 0
      dx = 1 if $player.direction == 6
      dx = -1 if $player.direction == 4
      dy = 1 if $player.direction == 2
      dy = -1 if $player.direction == 8

      tx = ev.x + dx
      ty = ev.y + dy

      if ev.width > 1
        tx += ev.width/2
      end

      if ev.height > 1
        ty += ev.height/2
      end

      $player.moveto(tx,ty)

end

def transfer(map,room=nil,dir=nil)
	$player.trans_type = :cross
	start_transfer(map,room,dir)
end

def transfer_cross(map,room=nil,dir=nil)
	$player.trans_type = :cross
	start_transfer(map,room,dir)
end

def transfer_instant(map,room=nil,dir=nil)
	$player.trans_type = :instant
	start_transfer(map,room,dir)
end

def transfer_fade(map,room=nil,dir=nil)
	$player.trans_type = :fade
	start_transfer(map,room,dir)
end

def transfer_cave(map,room=nil,dir=nil)
	$player.trans_type = :cave
	start_transfer(map,room,dir)
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

def transfer_chester_in(dir=nil)
	transfer(48,1,dir)
	$player.trans_type = :cave
end

def transfer_house_in(dir=nil)
	transfer_in("Indoor",dir)
	$player.trans_type = :fade
end

def transfer_house_in2(dir=nil)
	transfer_in("Indoor2",dir)
	$player.trans_type = :fade
end

def transfer_house_out(dir=nil)
	sfx 'door-open'
	transfer_out(dir)
	$player.trans_type = :fade
end

def transfer_house_out_s(dir=nil)
	transfer_out(dir)
	$player.trans_type = :fade
end

def transfer_cave_in(dir=nil)
	transfer_in("Cave",dir)
	$player.trans_type = :cave
end

def transfer_cave_in2(dir=nil)
	transfer_in("Cave2",dir)
	$player.trans_type = :cave
end

def transfer_cave_out(dir=nil)
	transfer_out(dir)
	$player.trans_type = :cave
end

def transfer_in(name,dir=nil)

	$player.trans_type = :cross

	# Get name of transfer
	room = $map.events[me].name

	# Find child map of name
	map = find_child_id($map.id,room)

	# If couldn't find, use the given name of the type of transfer understand?
	# Name will be Indoor or cave etc
	if map == 0
		map = find_child_id($map.id,name)
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

def find_parent_name(map_id)
	parent = $data.mapinfos[map_id].parent_id
	return $data.mapinfos[parent].name
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

 	# Remove zone
 	name = name.split("@")[0].rstrip

	$data.mapinfos.each{ |k,map|
		return k if map.name == name
	}

	return 0

 end