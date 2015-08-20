
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

def shake_ev(ev)

	amount = 20
	dur = 70
	rep = 50
	e = :qio

	ev.do(
		repeat(
			seq(
				go(
					"x",amount,dur,e
					),
				go(
					"x",-amount,dur,e
					)
			),rep
		)
	)

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

def shake_tiny

	amount = 5
	dur = 150
	rep = 2
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

def shake_mid

	amount = 10
	dur = 140
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

	pop_icon(ev,"misc/exclaim","jump")

end

def pop_huh_r(ev)

	pop_icon_r(ev,"misc/exclaim-r","jump")

end

def pop_wha(ev)

	pop_icon(ev,"misc/unknown","jump")

end

def pop_sweat(ev)
	pop_icon_sweat(ev,"misc/sweat","creak")
end

def pop_dots(ev)
	pop_icon(ev,"misc/dots","jump")
end

def pop_bulb(ev)
	pop_icon(ev,"misc/bulb","bulb")
end

def pop_icon_sweat(ev,icon,sfx)

	gev(ev).do(seq(go("off_y",-8,90,:qio),go("off_y",8,90,:qio)))

	x = gev(ev).screen_x + 10
	y = gev(ev).screen_y - 45

	$scene.add_icon(icon,x,y,:lower,:fade,1)

	sfx(sfx)

end

def pop_icon(ev,icon,sfx)

	gev(ev).do(seq(go("off_y",-8,90,:qio),go("off_y",8,90,:qio)))

	x = gev(ev).screen_x+2
	y = gev(ev).screen_y - 70
	$scene.add_icon(icon,x,y,:blast,:fade)

	sfx(sfx)

end

def pop_icon_r(ev,icon,sfx)

	gev(ev).do(seq(go("off_y",8,90,:qio),go("off_y",-8,90,:qio)))

	x = gev(ev).screen_x+2
	y = gev(ev).screen_y + 10
	$scene.add_icon(icon,x,y,:blast,:fade)

	sfx(sfx)

end

def pop_icon_get(ev,item)

	icon = $data.items[item].icon	
	x = gev(ev).screen_x+2
	y = gev(ev).screen_y - 24
	$scene.add_icon(icon,x,y,:fade,:fade)

end

def icon(ev,icon,ein=:blast,eout=:blast)

	x = gev(ev).screen_x
	y = gev(ev).screen_y - 32
	$scene.add_icon(icon,x,y,ein,eout)

end






# -------------------------------------------------------------------------
# Battle System Pops
# -------------------------------------------------------------------------

def pop_num(ev,number)

	gev(ev).do(seq(go("off_y",-8,90,:qio),go("off_y",8,90,:qio)))

	x = gev(ev).screen_x 
	y = gev(ev).screen_y - 20

	# Create the pop
	pop = Pop.new(ein,eout,@vp_over)
    pop.number = nm
    pop.move(x,y)
    pop.start
	$scene.add_pop(pop)

end


def pop_dmg(ev,number)

	# Jump the target? # Might will cut this
	gev(ev).do(seq(go("off_y",-8,90,:qio),go("off_y",8,90,:qio)))

	# Position
	x = gev(ev).screen_x
	y = gev(ev).screen_y - 20
	
	# Create the pop
	pop = Pop.new(:fall,:fade,@vp_over)
    pop.number(number,:dmg)
    pop.move(x,y)
    pop.start
	$scene.add_pop(pop)

end

def pop_heal(ev,number)

	# Jump the target? # Might will cut this
	#gev(ev).do(seq(go("off_y",-8,90,:qio),go("off_y",8,90,:qio)))

	# Position
	x = gev(ev).screen_x
	y = gev(ev).screen_y - 20
		
	# Create the pop
	pop = Pop.new(:rise,:fade,@vp_over)
    pop.number(number,:hp)
    pop.move(x,y)
    pop.start
	$scene.add_pop(pop)

end

def pop_gain(ev,number,suffix)

	# Position
	x = gev(ev).screen_x
	y = gev(ev).screen_y - 60
		
	# Create the pop
	pop = Pop.new(:rise,:fade,@vp_over)
    pop.number(number,suffix,suffix)
    pop.move(x,y)
    pop.start
	$scene.add_pop(pop)

end

def pop_crit(ev)

	# Position
	x = gev(ev).screen_x
	y = gev(ev).screen_y + 5
		
	# Create the pop
	pop = Pop.new(:rise,:fade,@vp_over)
    pop.image('critical')
    pop.move(x,y)
    pop.start
	$scene.add_pop(pop)

end

def pop_state(ev,state)

	# Position
	x = gev(ev).screen_x
	y = gev(ev).screen_y - 50
		
	# Create the pop
	pop = Pop.new(:rise,:fade,@vp_over)
    pop.image(state)
    pop.move(x,y)
    pop.start
	$scene.add_pop(pop)

end

# -------------------------------------------------------------------------





