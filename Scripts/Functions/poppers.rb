
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


	pop_get(type,b,ib,'green')

end

def pop_magics(number)

	ib = $cache.icon('misc/magics')
	b = "#{number} Magic"	

	pop_get('r',b,ib,'wizard')

end

def pop_ing_pickup(i)
	sfx 'item'
	ib = $cache.icon($data.items[i].icon)
	pop_get('p',$data.items[i].name,ib)
end

def pop_learn(s,w)

	b = $data.skills[s].name.sub("=>",":")
	ib = $cache.icon($data.skills[s].icon)

	a = $data.actors[w].name+" has learned: "
	ia = $cache.icon("faces/#{w}")	

	popper = $scene.hud.open_popper
	popper.color = 'blue'
	popper.setup(a,ia,b,ib)

end

def pop_use_skill(s,w)

	b = $data.skills[s].name
	ib = $cache.icon($data.skills[s].icon)

	a = $data.actors[w].name+" uses:"
	ia = $cache.icon("faces/#{w}")	

	popper = $scene.hud.open_popper
	popper.color = 'blue'
	popper.setup(a,ia,b,ib)

end

def pop_get(type,b,ib,color=nil)

	case type

		when 'f'
			a = "You found: "
			ia = nil

		when 'mf'
			a = "Myst found: "
			ia = ia = $cache.icon("faces/mys")

		when 'b'
			a = "You bought: "
			ia = nil

		when 'm'
			a = "You made: "
			ia = nil

		when 'r'
			a = "You receive: "
			ia = nil

		when 'fang'
			a = "Fang receives: "
			ia = nil

		when 'sister'
			a = "Lorelai receives: "
			ia = nil

		when 'rat'
			a = "Colby found: "
			ia = nil

		when 'p'
			a = "Ingrid picks up: "
			ia = $cache.icon("faces/ing")	

		when 'boy','ing','hib','mys','phy','rob','row'
			a = $data.actors[type].name+" receives: "
			ia = $cache.icon("faces/#{type}")

		when 's'
			return

	end

	popper = $scene.hud.open_popper
	color = 'diamonds' if color == nil
	popper.color = color
	popper.setup(a,ia,b,ib)

end

def pop_nothing
	popper = $scene.hud.open_popper
	popper.setup("You found: Nothing",nil,nil,nil)
end

def pop_friends

	a = "Hi'beru and "
	ia = $cache.icon("faces/hib")
	
	b = "Rowen are good now friends"
	ib = $cache.icon("faces/row")

	popper = $scene.hud.open_popper
	popper.setup(a,ia,b,ib)

end

def pop_join(who)

	char = $party.get(who)
	a = "#{char.name} joins the party"
	ia = $cache.icon("faces/#{who}")
	
	b = ""
	ib = nil

	popper = $scene.hud.open_popper
	popper.setup(a,ia,b,ib)

end

def pop_leave(who)

	char = $party.get(who)
	a = "#{char.name} leaves the party"
	ia = $cache.icon("faces/#{who}")
	
	b = ""
	ib = nil

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

def pop_level(who)
	
	a = "#{$party.get(who).name} gains a level"
	ia = $cache.icon("faces/#{who}")

	b = nil
	ib = nil

	popper = $scene.hud.open_popper
	popper.setup(a,ia,b,ib)

end

def pop_level_all

	a = "Everybody gains a level!"
	ia = $cache.icon("misc/exclaim")

	b = nil
	ib = nil

	popper = $scene.hud.open_popper
	popper.setup(a,ia,b,ib)

end

def pop_stat_all(stat,amount)

	stat_text = case stat
		when 'hp'; "Max Hp"
		when 'mp'; "Max Mp"
		when 'str'; "Strength"
		when 'def'; "Defense"
		when 'eva'; "Evasion"
		when 'luk'; "Luck"
		when 'res'; "Resist"
	end

	a = "Everybody gains #{amount} #{stat_text}"
	ia = $cache.icon("misc/exclaim")

	b = nil
	ib = nil

	popper = $scene.hud.open_popper
	popper.setup(a,ia,b,ib)

end

def pop_xp_all(amount)

	a = "Everybody gains #{amount} xp"
	ia = $cache.icon("misc/exclaim")

	b = nil
	ib = nil

	popper = $scene.hud.open_popper
	popper.setup(a,ia,b,ib)

end

def pop_stat_bonus(who,stat,amount)

	stat_text = case stat
		when 'hp'; "Max Hp"
		when 'mp'; "Max Mp"
		when 'str'; "Strength"
		when 'def'; "Defense"
		when 'eva'; "Evasion"
		when 'luk'; "Luck"
		when 'res'; "Resist"
	end

	a = "#{$party.get(who).name} gains #{amount} #{stat_text}"
	ia = $cache.icon("faces/#{who}")

	b = nil
	ib = nil

	popper = $scene.hud.open_popper
	popper.setup(a,ia,b,ib)

end

def pop_stat_unbonus(who,stat,amount)

	stat_text = case stat
		when 'hp'; "Max Hp"
		when 'mp'; "Max Mp"
		when 'str'; "Strength"
		when 'def'; "Defense"
		when 'eva'; "Evasion"
		when 'luk'; "Luck"
		when 'res'; "Resist"
	end

	a = "#{$party.get(who).name} loses #{amount} #{stat_text}"
	ia = $cache.icon("faces/#{who}")

	b = nil
	ib = nil

	popper = $scene.hud.open_popper
	popper.setup(a,ia,b,ib)

end

def pop_attract(who)
	
	a = "Ingrid gains an"
	ia = $cache.icon("faces/ing")
	
	b = "Attraction Point with #{$party.get(who).name}"
	ib = $cache.icon("misc/attract-get")

	popper = $scene.hud.open_popper
	popper.setup(a,ia,b,ib)

end

def pop_night(amount)
	
	a = " |"
	ia = $cache.icon("faces/rob")

	b = " Nightwatch progress increased by " + amount.to_s + "%"
	ib = $cache.icon("faces/mys")

	popper = $scene.hud.open_popper
	popper.setup(a,ia,b,ib)

end