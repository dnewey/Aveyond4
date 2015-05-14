
def spark(ev,fx)

	$scene.add_spark(fx,gev(ev).screen_x,gev(ev).screen_y)

end

def pop_huh(ev)

	gev(ev).do(seq(go("off_y",-8,90,:qio),go("off_y",8,90,:qio)))

	x = gev(ev).screen_x+2
	y = gev(ev).screen_y - 70
	$scene.add_icon("misc/exclaim",x,y,:blast,:fade)

	sfx('jump')

end

def pop_wha(ev)

	gev(ev).do(seq(go("off_y",-8,90,:qio),go("off_y",8,90,:qio)))

	x = gev(ev).screen_x+2
	y = gev(ev).screen_y - 70
	$scene.add_icon("misc/unknown",x,y,:blast,:fade)

	sfx('jump')

end

def pop_num(ev,number)

	gev(ev).do(seq(go("off_y",-8,90,:qio),go("off_y",8,90,:qio)))

	x = gev(ev).screen_x+2
	y = gev(ev).screen_y - 70
	$scene.add_num(number,x,y,:blast,:fade)

	sfx('jump')

end

def icon(ev,icon,ein=:blast,eout=:blast)

	x = gev(ev).screen_x
	y = gev(ev).screen_y - 32
	$scene.add_icon(icon,x,y,ein,eout)

end