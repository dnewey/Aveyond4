
def bqs(skill,turn)
	$battle.queue_sill(skill,turn)
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