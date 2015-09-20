#==============================================================================
# ** Event Functions
#==============================================================================

# Jumpings
def jump(e,x,y)
	gev(e).jump(x,y)
end

def jump_xy(e,x,y)
	ev = gev(e)
	ev.jump(x-ev.x,y-ev.y)
end

def jump_to(e,t)
	ev = gev(e)
	target = gev(t)
	ev.jump(target.x-ev.x,target.y-ev.y)
end

# Opacity
def hide(e)
	gev(e).opacity = 0
end
def unhide(e)
	gev(e).opacity = 255
end

def unhide3(*args)
	args.each{ |a|
		unhide(a+'3')
	}
end

def unhide6(e,o = 255)
	gev('plr').opacity = 255 - o
	gev('boy'+e).opacity = o
	gev('mys'+e).opacity = o
	gev('rob'+e).opacity = o
	gev('hib'+e).opacity = o
	gev('row'+e).opacity = o
	gev('ing'+e).opacity = o
end

def unhide7(e,o = 255)
	gev('plr').opacity = 255 - o
	gev('boy'+e).opacity = o
	gev('mys'+e).opacity = o
	gev('rob'+e).opacity = o
	gev('hib'+e).opacity = o
	gev('row'+e).opacity = o
	gev('ing'+e).opacity = o
	gev('phy'+e).opacity = o
end

def uhx(n,e,o = 255)
	party = ['boy','ing','mys','rob','hib','row','phy']
	gev('plr').opacity = 255 - o
	n.times do
    	x = party.shift
    	gev(x+e.to_s).opacity = o
	end
end

def delete7(e)
	unhide 'plr'
	delete ('boy'+e)
	delete ('mys'+e)
	delete ('rob'+e)
	delete ('hib'+e)
	delete ('row'+e)
	delete ('ing'+e)
	delete ('phy'+e)
end

def occupied?(e)
	ev = gev(e)
	return $map.events_at(ev.x,ev.y).count > 1
end

def other_here(e)
	ev = gev(e)
	list = $map.events_at(ev.x,ev.y)
	list.delete(e)
	return list[0].id
end

def roll(range)
	gev(me).random = rand(range) + 1
end

def voll(v)
	gev(me).voll = $state.varval(v)
end

def fade(ev)
	gev(ev).opacity = 255
	gev(ev).do(go("opacity",-255,300))
end

def unfade(ev)
	gev(ev).opacity = 0
	gev(ev).do(go("opacity",+255,300))
end

def gfx(ev,name)
	gev(ev).character_name = name	
end

def blast(ev)
	gev(ev).zoom = 1.0
	a = go("zoom",0.2,100)
	b = go("zoom",-0.2,120)
	gev(ev).do(seq(a,b))
end

# Routes

def face2face
	td me
	x = gev(me).x
	y = gev(me).y
	path 'plr',x,y+1,'u'
	wfc
end

def wfc
	$scene.map.interpreter.command_210
end

def td(e) gev(e).turn_down end
def tl(e) gev(e).turn_left end
def tr(e) gev(e).turn_right end
def tu(e) gev(e).turn_up end


def approach(ev,target)

	# Walk over to and face an event, position will be the closest side
	char = gev(ev)
	other = gev(target)

	dx = other.x - char.x
	dy = other.y - char.y

	if dx.abs >= dy.abs
		if dx < 0
			path(ev,other.x+1,other.y,'l')
		else
			path(ev,other.x-1,other.y,'r')
		end
	else
		if dy < 0
			path(ev,other.x,other.y+1,'u')
		else
			path(ev,other.x,other.y-1,'d')
		end
	end

end

def stop

	$player.clear_path

end

def path(ev,tx,ty,after=nil)

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

	if after != nil
		case after
			when 2, 'd'
				route.list.push(RPG::MoveCommand.new(16))
			when 4, 'l'
				route.list.push(RPG::MoveCommand.new(17))
			when 6, 'r'
				route.list.push(RPG::MoveCommand.new(18))
			when 8, 'u'
				route.list.push(RPG::MoveCommand.new(19))
		end
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

	live_dir = char.direction

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
				live_dir = 2
				route.list.push(RPG::MoveCommand.new(1))
			when 'l'
				live_dir = 4
				route.list.push(RPG::MoveCommand.new(2))
			when 'r'
				live_dir = 6
				route.list.push(RPG::MoveCommand.new(3))
			when 'u'
				live_dir = 8
				route.list.push(RPG::MoveCommand.new(4))

			when 'td'
				live_dir = 2
				route.list.push(RPG::MoveCommand.new(16))
			when 'tl'
				live_dir = 4
				route.list.push(RPG::MoveCommand.new(17))
			when 'tr'
				live_dir = 6
				route.list.push(RPG::MoveCommand.new(18))
			when 'tu'
				live_dir = 8
				route.list.push(RPG::MoveCommand.new(19))

			when 'f'
				route.list.push(RPG::MoveCommand.new(12))

			when 'b'
				route.list.push(RPG::MoveCommand.new(13))


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

			when 'sp'
				route.list.push(RPG::MoveCommand.new(29,[params[0]]))


			when 'w'
				route.list.push(RPG::MoveCommand.new(15,[params[0]]))

			when 'j'
				route.list.push(RPG::MoveCommand.new(14,[0,0]))
			when 'jf'
				jc = [0,1] if live_dir == 2
				jc = [-1,0] if live_dir == 4
				jc = [1,0] if live_dir == 6
				jc = [0,-1] if live_dir == 8
				route.list.push(RPG::MoveCommand.new(14,jc))
			when 'jb'
				jc = [0,1] if live_dir == 8
				jc = [-1,0] if live_dir == 6
				jc = [1,0] if live_dir == 4
				jc = [0,-1] if live_dir == 2
				live_dir = 10 - live_dir
				route.list.push(RPG::MoveCommand.new(14,jc))


		end

	}

	route.list.push(RPG::MoveCommand.new())

	char.force_move_route(route)
	#$map.interpreter.command_210

end
