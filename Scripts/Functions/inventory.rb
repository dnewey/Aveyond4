#==============================================================================
# ** Item Functions
#==============================================================================

def gold(amount)
	$party.add_gold(amount)
	# SHOW TEXT
end

def gold_s(amount)
	$party.add_gold(amount)
end

def ungold(amount)
	$party.lose_gold(amount)
end

def gold?(amount)
	return $party.has_gold?(amount)
end


def item(id,number=1)
	$party.add_item(id,number)
	# Show the text
end

def item_s(id,number=1)
	$party.add_item(id,number)
end

def unitem(id,number=1)
	$party.lose_item(id,number)
end

def item?(id,number=1)
	$party.has_item?(id,number)
end

