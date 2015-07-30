
# Potion making

def potion_learn(potion)
	return if potion_known?(potion)
	$party.potions.push(potion)
end

def potion_known?(potion)
	return $party.potions.include?(potion)
end

def potion_prep
	$party.potion_state = :prepped
end

def potion_equip(item)
	$party.potion_item = item
end

def potion_dequip
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

		when :prepped
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