
# Audio

def sfx(file,vol=1.0,delay=0)
	if delay > 0
		$audio.queue(file,vol,delay)
	else
		$audio.sfx(file,vol)
	end
end

def sys(file,vol=1.0)
	$audio.sys(file,vol)
end

def music(file,vol=1.0)
	$audio.music(file,vol)
end

def atmosphere(file)
	$audio.atmosphere(file)
end

def music_pause
	$audio.pause
end

def music_unpause
	$audio.unpause
end

def music_fadeout
	$audio.music_target = 0.0
end

def music_fadein
	$audio.music_target = 1.0
end

def audio_fadeout
	$audio.music_target = 0.0
end

def atmosphere_fadeout
	$audio.atmosphere_target = 0.0
end