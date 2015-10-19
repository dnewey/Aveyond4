
def bqs(id,skill,turn)
	$battle.queue_skill(id,skill,turn)
end

def bqas(id,skill,turn)
	$battle.queue_ally_skill(id,skill,turn)
end

def bqt(text,turn)
	$battle.queue_text(text,turn)
end

def bqe(turn)
	$battle.queue_escape(turn)
end

def bqj(who,turn)
	$battle.queue_join(who,turn)
end