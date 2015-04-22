

def mr(ev,path,wfc=true) #waitforcompletion

	char = $map.events[ev]

	data = path.split(',')

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

			when 'fix'
				route.list.push(RPG::MoveCommand.new(35))
			when '!fix'
				route.list.push(RPG::MoveCommand.new(36))

			when 'w'
				route.list.push(RPG::MoveCommand.new(15,[params[0]]))

			when '180'
				route.list.push(RPG::MoveCommand.new(21))
				route.list.push(RPG::MoveCommand.new(15,[5]))
				route.list.push(RPG::MoveCommand.new(21))

			when 'j'
				route.list.push(RPG::MoveCommand.new(14,[0,0]))

			when 'pf' # srs

				# Only keeps pos for pathfinds, would need to keep x and y in move route or something
				# Or just don't allow path find then move then path find

				x = 0
				y = 0
				sx = sy = 0

				if $mx == nil
					sx = char.x
					sy = char.y
					x = char.x
					y = char.y
				else
					sx = $mx
					sy = $my
					x = $mx
					y = $my
				end


				log_info ['start',sx,sy]

				tx = params[0]
				ty = params[1]

				result = char.setup_map(sx,sy,tx,ty)

				next if !result[0]
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

				$mx = x
				$my = y		

		end

	}

	$mx = $my = nil

	route.list.push(RPG::MoveCommand.new())

	char.force_move_route(route)
	$map.interpreter.command_210 if wfc

end
