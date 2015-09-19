#==============================================================================
# ** Item Functions
#==============================================================================

def gold(amount,type='f')
	sys('coins')
	$party.add_gold(amount)
	pop_gold(amount,type)
end

def ungold(amount)
	sys('coins')
	$party.add_gold(-amount)
end

def gold?(amount)
	return $party.has_gold?(amount)
end

def magics(amount)
	sys('coins')
	$party.add_magics(amount)
end

def unmagics(amount)
	sys('coins')
	$party.add_magics(-amount)
end

def magics?(amount)
	return $party.has_magics?(amount)
end

def magics_exchange
	adding = $party.item_number('cheeki')
	mult = $data.numbers['cheeki-magic'].value
	amount = adding*mult
	amount = 7
	magics(amount)
	pop_magics(amount)
end

def item(id,number=1,type='f')
	if !number.is_a?(Integer)
		type = number
		number = 1
	end
	#sfx 'fireworks-explode'
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


#==============================================================================
# ** Members
#==============================================================================

# Only this one will do popper
def join(who)
	$party.set_active(who)
	pop_join(who)
	$scene.hud.bar.refresh if $scene.is_a?(Scene_Map)
end

def join_s(who)
	$party.set_active(who)
	$scene.hud.bar.refresh if $scene.is_a?(Scene_Map)
end

def unjoin(who)
	pop_leave(who)
	$party.back_to_pavillion(who)
	$scene.hud.bar.refresh if $scene.is_a?(Scene_Map)
end

def unjoin_s(who)
	$party.back_to_pavillion(who)
	$scene.hud.bar.refresh if $scene.is_a?(Scene_Map)
end

def party_of_boy
	$party.backup_party
	$party.leader = 'boy'
	join_s('boy')
end

def party_of_ing
	$party.backup_party
	$party.leader = 'ing'
	join_s('ing')
end

def party_of_all
	$party.restore_party
end

def make_reserve(who)
	$party.set_reserve(who)
end

def make_active(who)
	$party.set_active(who)
end


def grant_stat(who,stat,amount)
	log_err("MAKE THE STAT GRANTING TTHINGS WITH POPPER")
end

def grant_level(who)
	log_err("MAKING THE GRANT LEVEL")
end