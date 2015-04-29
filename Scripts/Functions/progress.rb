#==============================================================================
# ** Progress Functions
#==============================================================================

# Quests
def quest(id) 
	$progress.quest(id) 
	# Pop up a text
end

def quest_s(id)

end

def unquest(id)
	$progress.unquest(id)
	# show quest complete
end

def quest?(id)
	return $progress.quest?(id)
end

def complete?(id)
	return $progress.complete?(id)
end


# Progress
def progress(id) $progress.progress(id) end
def progress?(id) return $progress.progress?(id) end

def before?(id) return $progress.before?(id) end
def beyond?(id) return $progress.beyond?(id) end