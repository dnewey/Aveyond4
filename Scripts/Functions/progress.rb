#==============================================================================
# ** Progress Functions
#==============================================================================

# Quests
def quest(id) 
	sys('quest')
	$progress.add_quest(id) 
	pop_quest(id)
	$scene.hud.quest_sparkle("misc/profile")
end

def unquest(id)
	sys('quest-complete')
	$progress.end_quest(id)
	pop_unquest(id)
end

def quest?(id)
	return active?(id) || complete?(id)
end

def active?(id)
	return $progress.quest_active?(id)
end

def complete?(id)
	return $progress.quest_complete?(id)
end

# Progress
def progress(id) $progress.progress(id) end
def progress?(id) return $progress.progress?(id) end

def before?(id) return $progress.before?(id) end
def beyond?(id) return $progress.beyond?(id) end

def attract(who)
	case who
		when 'boy'
			$progress.attract_boy += 1
		when 'hib'
			$progress.attract_hib += 1
		when 'phy'
			$progress.attract_phy += 1
	end
	sys('attract')
	pop_attract(who)
end