#==============================================================================
# ** Item Functions
#==============================================================================

def item(id,number=1)
	$party.add_item(id,number)
	# Show the text
	pop_item(id,number)


end

def item_s(id,number=1)

end

def unitem(id,number=1)
	$party.lose_item(id,number)
end

def item?(id,number=1)
	return $party.item_number(id) >= number
end

