
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
	# $audio.music_target = 1
	$audio.music(file,vol)
end

def atmosphere(file)
	$audio.atmosphere(file)
end

def music_skip
	$map.skip_music_change = true
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
	$audio.unpause
	$audio.music_target = 1.0
end

def music_restore
	# Restore the zone music
	$map.setup_audio
end

def audio_fadeout
	$audio.music_target = 0.0
end

def atmosphere_fadeout
	$audio.atmosphere_target = 0.0
end

def atmosphere_fadein
	$audio.atmosphere_target = 1.0
end

def atmosphere_restore
	# Restore the zone music
	$map.setup_audio
end