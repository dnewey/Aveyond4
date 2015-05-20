
def pop_item(item,number,type)

	data = $data.items[item]
	
	b = data.name
	ib = $cache.icon(data.icon)
	if number > 1 
		b = data.name + " x #{number}"
	end		

	pop_get(type,b,ib)

end

def pop_gold(number,type)

	ib = $cache.icon('misc/coins')
	b = "#{number} Gold"	

	pop_get(type,b,ib)

end

def pop_get(type,b,ib)

	case type

		when 'f'
			a = "You found: "
			ia = nil

		when 'r'
			a = "You receive: "
			ia = nil

		when 'fang'
			a = "Fang receives: "
			ia = nil

		when 'rat'
			a = "Trevor found: "
			ia = nil

		when 'boy','ing','hib','mys','phy','rob','row'
			a = $data.actors[type].name+" receives: "
			ia = $cache.icon("faces/#{type}")

		when 's'
			return

	end

	popper = $scene.hud.open_popper
	popper.color = 'blue'
	popper.setup(a,ia,b,ib)

end

def pop_friends

	a = "Hi'beru and "
	ia = $cache.icon("faces/hib")
	
	b = "Rowen are good now friends"
	ib = $cache.icon("faces/row")

	popper = $scene.hud.open_popper
	popper.setup(a,ia,b,ib)

end

def pop_quest(q)

	popper = $scene.hud.open_popper
	popper.setup("New quest: ",nil,$data.quests[q].name,nil)

end

def pop_unquest(q)

	popper = $scene.hud.open_popper
	popper.setup("Quest complete: ",nil,$data.quests[q].name,nil)

end