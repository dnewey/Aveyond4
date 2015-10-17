



def potion_equip(item)
	$party.potion_item = item
end

def potion_dequip
	$party.potion_item = nil
end

def potion_state(s)
	$party.potion_state = s
	$map.need_refresh = true
end

def potion_current
	return $data.potions[$party.potion_id]
end

def potion_chose_recipe

	# Check if this is even a recipe
	if $menu.chosen.include?('recipe')

		recipe = $menu.chosen.sub('recipe-','')
		log_scr(recipe)
		$party.potion_id = recipe
		$menu.chosen = nil
		potion_state('start')

	else

		text("x-ing: This isn't a potion recipe!")
		$menu.chosen = nil
		potion_state('empty')

	end

	# Clear
	

end

def potion_chose_secret?		
	#log_sys($menu.chosen)
	#log_ev(potion_current.ingredient)
	return potion_current.ingredient == $menu.chosen
end

def potion_use_item

	case $party.potion_item

		when 'vials'

			a = "Ingrid uses"
			ia = $cache.icon("faces/ing")

			b = "Undo Vials" 
			ib = $cache.icon("witchery/vials")


		when 'glacial-essence'

			a = "Ingrid adds a few drops of"
			ia = $cache.icon("faces/ing")

			b = "Glacial Essence" 
			ib = $cache.icon("witchery/glacial-essence")

		when 'dream-shroom'

			a = "Ingrid shakes the "
			ia = $cache.icon("faces/ing")

			b = "Dream Shroom" 
			ib = $cache.icon("witchery/dream-shroom")

		when 'rock-powder'

			a = "Ingrid shaves off some"
			ia = $cache.icon("faces/ing")

			b = "Rock Powder" 
			ib = $cache.icon("witchery/rock-powder")

		when 'moon-tear'

			a = "Ingrid squeezes the"
			ia = $cache.icon("faces/ing")

			b = "Moon Tear" 
			ib = $cache.icon("witchery/moon-tear")

		when 'violin'

			a = "Ingrid plays the"
			ia = $cache.icon("faces/ing")

			b = "Violin" 
			ib = $cache.icon("witchery/violin")

		when 'soda-ash'

			a = "Ingrid adds a handful of"
			ia = $cache.icon("faces/ing")

			b = "Soda Ash" 
			ib = $cache.icon("witchery/soda-ash")

		when 'baby-dragon'

			a = "The"
			ia = nil

			b = "Baby Dragon breathes fire"
			ib = $cache.icon("witchery/baby-dragon")

		when 'mineral-man'
		
			a = "Ingrid breaks off a piece of the"
			ia = $cache.icon("faces/ing")
				
			b = "Mineral Man"
			ib = $cache.icon("witchery/mineral-man")

		else

			text("x-ing: I need to add something.")
			return

	end

	popper = $scene.hud.open_popper
	popper.setup(a,ia,b,ib)

	if $party.potion_item == 'vials'
		potion_state('empty')
		item(potion_current.ingredient,'s')
		item(potion_current.ingredient)
	end

end

def potion_problem

	i = $party.potion_item	

	solved = false
	case $party.potion_state

		when 'hot' # Glacial Essence
			if i == 'glacial-essence'	

				solved = true

			end

		when 'rotten' # Mineral man
			solved = true if i == 'mineral-man'	


		when 'acidic' # Soda ash
			solved = true if i == 'soda-ash'	

		when 'claggy' # dream leaf
			solved = true if i == 'dream-shroom'	

		when 'slimy' # Rock Powder
			solved = true if i == 'rock-powder'	

		when 'cold' # Baby Dragon
			solved = true if i == 'baby-dragon'	

		when 'sour' # moon tear
			solved = true if i == 'moon-tear'	

		when 'volatile' # MUSIC
			solved = true if i == 'violin'	

	end

	if solved
		potion_next_problem
	else
		text("x-ing: That didn't work.")
	end

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

	$map.need_refresh = true

	case $party.potion_state

		when 'hot'
			
			text("x-ing: Something isn't right, it's very red.")

		when 'rotten'
			
			text("x-ing: This is wrong, it shouldn't be orange.")

		when 'acidic'
			
			text("x-ing: Hmm, it shouldn't be so yellow.")

		when 'claggy'
			
			text("x-ing: All the color has come out of it.")

		when 'slimy'
			
			text("x-ing: It's gone green, what will I do?")

		when 'cold'
			
			text("x-ing: I wonder what made it so blue.")

		when 'sour'
			
			text("x-ing: Something is wrong, it's pink!")

		when 'volatile'
			
			text("x-ing: This purple color doesn't seem right.")

		else
			text("x-ing: That's it! Perfect!")

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

		when 'started'
			ev.character_name = 'Objects/cauldron-base'
			ev.direction = 4

		when 'kaboom'
			ev.character_name = 'Objects/cauldron-base'
			ev.direction = 4

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
			ev.direction = 8

		when 'volatile' # MUSIC
			ev.character_name = 'Objects/cauldron-problem-b'
			ev.direction = 6

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