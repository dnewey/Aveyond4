#==============================================================================
# ** Item Functions
#==============================================================================

def gold(amount,type='f')
	sys('coins')
	$party.add_gold(amount)
	pop_gold(amount,type)
end

def ungold(amount)
	$party.lose_gold(amount)
end

def gold?(amount)
	return $party.has_gold?(amount)
end


def item(id,number=1,type='f')
	if !number.is_a?(Integer)
		type = number
		number = 1
	end
	$party.add_item(id,number)
	return if !$scene.is_a?(Scene_Map)
	pop_item(id,number,type) if type != 's'
end

def unitem(id,number=1)
	$party.lose_item(id,number)
end

def item?(id,number=1)
	$party.has_item?(id,number)
end

def grant_items
	$data.items.each{ |k,v|
		#log_scr(v.id)
		item(v.id,99,'s')
	}
end