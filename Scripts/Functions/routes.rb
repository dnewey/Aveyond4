#==============================================================================
# ** Route Functions
#==============================================================================

def wfc
	$map.interpreter.command_210
end

def path(ev,tx,ty)

	char = gev(ev)

	route = RPG::MoveRoute.new()
	route.list.clear
	route.repeat = false
	route.skippable = false

	x = 0
	y = 0
	sx = sy = 0

	sx = char.x
	sy = char.y
	x = char.x
	y = char.y

	result = char.setup_map(sx,sy,tx,ty)

	if !result[0]
		log_err("CANNOT FIND PATH")
		return
	end
	map = result[1]
	map[sx,sy] = result[2] if result[2] != nil

	# Now step through the path building cmds
	step = map[x,y] 
	while step != 1

	     if map[x+1,y] == step - 1 and step != 0
	     	route.list.push(RPG::MoveCommand.new(3))
	     	x+=1
	     end
	     if map[x,y+1] == step - 1 and step != 0
	     	route.list.push(RPG::MoveCommand.new(1))
	     	y+=1
	     end
	     if map[x-1,y] == step - 1 and step != 0
	     	route.list.push(RPG::MoveCommand.new(2))
	     	x-=1
	     end
	     if map[x,y-1] == step - 1 and step != 0
			route.list.push(RPG::MoveCommand.new(4))
			y -= 1
	     end

	     step = map[x,y] 

	end		

	route.list.push(RPG::MoveCommand.new())

	char.force_move_route(route)

end

def route(ev,move)

	char = gev(ev)

	data = move.split(',')

	route = RPG::MoveRoute.new()
	route.list.clear
	route.repeat = false
	route.skippable = false

	data.each{ |step|

		params = []

		# build params split off step
		if step.include?("-")
			dta = step.split("-")
			step = dta[0]
			params.push(dta[1].to_i) if dta.count > 1
			params.push(dta[2].to_i) if dta.count > 2
			params.push(dta[3].to_i) if dta.count > 3
		end

		case step

			when 'd'
				route.list.push(RPG::MoveCommand.new(1))
			when 'l'
				route.list.push(RPG::MoveCommand.new(2))
			when 'r'
				route.list.push(RPG::MoveCommand.new(3))
			when 'u'
				route.list.push(RPG::MoveCommand.new(4))

			when 'td'
				route.list.push(RPG::MoveCommand.new(16))
			when 'tl'
				route.list.push(RPG::MoveCommand.new(17))
			when 'tr'
				route.list.push(RPG::MoveCommand.new(18))
			when 'tu'
				route.list.push(RPG::MoveCommand.new(19))


			when 'walk'
				route.list.push(RPG::MoveCommand.new(31))
			when 'unwalk'
				route.list.push(RPG::MoveCommand.new(32))

			when 'step'
				route.list.push(RPG::MoveCommand.new(33))
			when 'unstep'
				route.list.push(RPG::MoveCommand.new(34))

			when 'fix'
				route.list.push(RPG::MoveCommand.new(35))
			when 'unfix'
				route.list.push(RPG::MoveCommand.new(36))

			when 'thr', 'through'
				route.list.push(RPG::MoveCommand.new(37))
			when 'unthr', 'unthrough'
				route.list.push(RPG::MoveCommand.new(38))	


			when 'w'
				route.list.push(RPG::MoveCommand.new(15,[params[0]]))

			when '180'
				route.list.push(RPG::MoveCommand.new(21))
				route.list.push(RPG::MoveCommand.new(15,[5]))
				route.list.push(RPG::MoveCommand.new(21))

			when 'j'
				route.list.push(RPG::MoveCommand.new(14,[0,0]))


		end

	}

	route.list.push(RPG::MoveCommand.new())

	char.force_move_route(route)
	#$map.interpreter.command_210

end
