#==============================================================================
# ** State Functions
#==============================================================================

# Flag shorthands
def flag(id) $state.flag(id) end
def unflag(id) $state.unflag(id) end
def flag?(id) return $state.flag?(id) end

# Var shorthands
def var(id,a=1) $state.var(id,a) end
def unvar(id,a=1) $state.var(id,a) end
def var?(id,a) return $state.var?(id,a) end

# State shortands
def state(e,s) 
	$state.state(gid(e),s)
end
def unstate(e,s)
	$state.unstate(gid(e),s)
end
def state?(e,s)
	return $state.state?(gid(e),s)
end

# Misc shorthands
def loc(e) gev(e).saveloc end

def erase(e) gev(e).erase end
def delete(e) gev(e).delete end
def disable(e) gev(e).disable end

def enable(e) gev(e).enable end
