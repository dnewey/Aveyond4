#==============================================================================
# ** Progress Functions
#==============================================================================

# Quests
def quest(id) 
	$progress.add_quest(id) 
	# Pop up a text
end

def quest_s(id)

end

def unquest(id)
	$progress.end_quest(id)
	# show quest complete
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