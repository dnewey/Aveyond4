
def spark(ev,fx,ox=0,oy=0)

	$scene.add_spark(fx,gev(ev).real_x/4+16+ox,gev(ev).real_y/4+16-10+oy)

end

def spark_r(ev,fx,ox=0,oy=0)
	sprk = $scene.add_spark(fx,gev(ev).real_x/4+16+ox,gev(ev).real_y/4+16-10+oy)
	sprk.reverse
end

def flash(ev,dur=20)
	gev(ev).flash_dur = dur
end


def shake_1

	amount = 20
	dur = 70
	rep = 3
	e = :qio

	$scene.map.do(
		repeat(
			seq(
				go(
					"cam_ox",amount,dur,e
					),
				go(
					"cam_ox",-amount,dur,e
					)
			),rep
		)
	)

end


def pop_huh(ev)

	pop_icon(ev,"misc/exclaim")

end

def pop_wha(ev)

	pop_icon(ev,"misc/unknown")

end

def pop_sweat(ev)
	pop_icon(ev,"misc/sweat")
end

def pop_dots(ev)
	pop_icon(ev,"misc/dots")
end

def pop_bulb(ev)
	pop_icon(ev,"misc/bulb")
end

def pop_icon(ev,icon)

	gev(ev).do(seq(go("off_y",-8,90,:qio),go("off_y",8,90,:qio)))

	x = gev(ev).screen_x+2
	y = gev(ev).screen_y - 70
	$scene.add_icon(icon,x,y,:blast,:fade)

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