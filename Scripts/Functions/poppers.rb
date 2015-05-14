

def pop_item(item,number)

	a = "You found: "
	ia = nil

	data = $data.items[item]
	
	b = data.name
	ib = $cache.icon(data.icon)
	if number > 1 
		b = data.name + " x #{number}"
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