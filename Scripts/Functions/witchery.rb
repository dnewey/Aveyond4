
# Potion making

def potion_learn(potion)
	return if potion_known?(potion)
	$party.potions.push(potion)
end

def potion_known?(potion)
	return $party.potions.include?(potion)
end

def potion_equip(item)
	$party.potion_item = item
end

def potion_dequip
	$party.potion_item = nil
end

def potion_state(s)
	$party.potion_state = s
end

def potion_current
	return $data.potions[$party.potion_id]
end

def potion_chose_secret?		
	return potion_current.ingredient == $menu.chosen
end

def potion_next_problem

	$party.potion_level += 1

	problems = potion_current.problems.split("\n")
	if $party.potion_level > problems.count
		$party.potion_state = 'done'
	else
		problem = problems[$party.potion_level-1]
		$party.potion_state = problem
	end

end

def cauldron_graphic(ev)

	case $party.potion_state

		when 'empty'
			ev.character_name = 'Objects/cauldron-base'
			ev.direction = 2

		when 'choose-recipe'
			ev.character_name = 'Objects/cauldron-base'
			ev.direction = 2

		when 'start'
			ev.character_name = 'Objects/cauldron-base'
			ev.direction = 2

		when 'start-ing'
			ev.character_name = 'Objects/cauldron-base'
			ev.direction = 4

		when 'choose-item'
			ev.character_name = 'Objects/cauldron-base'
			ev.direction = 2

		when 'kaboom'
			ev.character_name = 'Objects/cauldron-base'
			ev.direction = 2

		when 'hot' # Glacial Essence
			ev.character_name = 'Objects/cauldron-problem-a'
			ev.direction = 2		

		when 'rotten' # Mineral man
			ev.character_name = 'Objects/cauldron-problem-a'
			ev.direction = 4

		when 'acidic' # Soda ash
			ev.character_name = 'Objects/cauldron-problem-a'
			ev.direction = 6

		when 'claggy' # dream leaf
			ev.character_name = 'Objects/cauldron-problem-a'
			ev.direction = 8

		when 'slimy' # Rock Powder
			ev.character_name = 'Objects/cauldron-problem-b'
			ev.direction = 2

		when 'cold' # Baby Dragon
			ev.character_name = 'Objects/cauldron-problem-b'
			ev.direction = 4

		when 'sour' # moon tear
			ev.character_name = 'Objects/cauldron-problem-b'
			ev.direction = 6

		when 'volatile' # MUSIC
			ev.character_name = 'Objects/cauldron-problem-b'
			ev.direction = 8

		when 'done'

			# Potion graphic
			case $party.potion_id

				when 'neon' # a - green
					ev.character_name = 'Objects/cauldron-potions-a'
					ev.direction = 8

				when 'blabber' # a - blue
					ev.character_name = 'Objects/cauldron-potions-a'
					ev.direction = 6

				when 'unslave' # a - brown
					ev.character_name = 'Objects/cauldron-potions-a'
					ev.direction = 2

				when 'shrink' # b - red
					ev.character_name = 'Objects/cauldron-potions-b'
					ev.direction = 2

				when 'mindbend' # b - yellow
					ev.character_name = 'Objects/cauldron-potions-b'
					ev.direction = 4

				when 'calming' # b - aqua
					ev.character_name = 'Objects/cauldron-potions-b'
					ev.direction = 8

				when 'guild' # b - gray
					ev.character_name = 'Objects/cauldron-potions-b'
					ev.direction = 6

				when 'love' # a - purple
					ev.character_name = 'Objects/cauldron-potions-a'
					ev.direction = 4

			end

	end

end