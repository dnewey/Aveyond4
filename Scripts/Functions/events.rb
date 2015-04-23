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