
# Potion making

def potion_learn(potion)
	return if potion_known?(potion)
	$party.potions.push(potion)
end

def potion_known?(potion)
	return $party.potions.include?(potion)
end

def potion_can_add?
	return false if $party.potion.count >= 5
	return [:empty,:adding].include?($party.potion_state)
end

def potion_full?
	return $party.potion_ings.count >= 5
end

def potion_equip(item)
	$party.potion_item = item
end

def potion_dequip
	$party.potion_item = nil
end

def potion_add

	# Add your potion equip, dequip it, and use one up

	# Maybe max 5
	$party.potion_ings.push(item)
	@potion.state = :adding

	# Remove the item from hand and party
	$party.lose_item($party.potion_item)
	$party.potion_item = nil

end

def potion_can_hack?
	return !potion_can_add?
end

def potion_done?
	problems = $data.potions[$party.potion_id].problems.split("\n")
	return $party.potion_level >= problems.count
end

def potion_hack(type)

	case $party.potion_state

		when :hot

			if type == 'cooler'
				# Go to next
				party_next_problem
			end

		when :claggy

		when :rotten

		when :acidic # Soda ash

		when :slimy

		when :cold # Heat - dragon

		when :sour

		when :volatile # Calm it somehow

	end

end

def potion_mix

	# Check if this is a valid mix
	# If so, go to fixing mode
	# If no, ingrid say this isn't right

	$data.potions.each{ |p|

		if p.ingredients.split("/n").sort == $party.potion_ings.sort
			
			# This is it!
			$party.potion_id = p.id

			# Now step through the problems
			$party.potion_level = -1
			potion_next_problem
			return

		end

	}

	# Dud potion, uh-oh

end

def potion_next_problem

	$party.potion_level += 1

	problems = $data.potions[$party.potion_id].problems.split("\n")
	if $party.potion.level >= problems.count

	else
		problem = problems[$party.potion_level]
		$party.potion_state = problem
	end

end

def cauldron_graphic(ev)

	case $party.potion_state

		when :empty
			ev.character_name = 'Objects/cauldron-base'
			ev.direction = 2

		when :adding
			ev.character_name = 'Objects/cauldron-base'
			ev.direction = 4

		when :hot # Glacial Essence
			ev.character_name = 'Objects/cauldron-problem-a'
			ev.direction = 2

		when :claggy # MIXXER OF SOME SORT
			ev.character_name = 'Objects/cauldron-problem-a'
			ev.direction = 4

		# when :rotten
		# 	ev.character_name = 'Objects/cauldron-problem-a'
		# 	ev.direction = 6

		when :acidic # Soda ash
			ev.character_name = 'Objects/cauldron-problem-a'
			ev.direction = 8

		when :slimy # Rock Powder
			ev.character_name = 'Objects/cauldron-problem-b'
			ev.direction = 2

		when :cold # Baby Dragon
			ev.character_name = 'Objects/cauldron-problem-b'
			ev.direction = 4

		# when :sour
		# 	ev.character_name = 'Objects/cauldron-problem-b'
		# 	ev.direction = 6

		when :volatile # MUSIC
			ev.character_name = 'Objects/cauldron-problem-b'
			ev.direction = 8

		when :done

			# Depends on the potion you were trying to make

	end

end

# Guilds