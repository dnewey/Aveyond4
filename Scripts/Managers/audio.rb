#==============================================================================
# ** Audio Manager
#==============================================================================

class AudioManager

  def initialize
  	@bgm = nil
  	@bgs = nil
  end

  # send_blank to force start music
  def play_bgm(bgm)
    @bgm = bgm
    return if !$settings.music
    Audio.bgm_play("Audio/BGM/" + bgm.name, bgm.volume, bgm.pitch)
  end

  def play_bgs(bgs)
	@bgm = bgm
	return if !$settings.music
    Audio.bgm_play("Audio/BGM/" + bgm.name, bgm.volume, bgm.pitch)
  end

  def stop_bgm
    Audio.bgm_stop
  end

  def stop_bgs
    Audio.bgs_stop
  end

  def fadeout_bgm(time)
    @bgm = nil
    Audio.bgm_fade(time * 1000)
  end
  
  def fadeout_bgs(time)
    @bgs = nil
    Audio.bgs_fade(time * 1000)
  end

  def play_me(me)
  	return if !$settings.music
    Audio.me_play("Audio/ME/" + me.name, me.volume, me.pitch)
  end

  def play_se(se)
    return if !$settings.sound
    Audio.se_play("Audio/SE/" + se.name, se.volume, se.pitch)
  end

  #--------------------------------------------------------------------------
  # * Turn on music
  #--------------------------------------------------------------------------
  def enable_music
    Audio.bgm_play("Audio/BGM/" + @bgm.name, @bgm.volume, @bgm.pitch)
    Audio.bgs_play("Audio/BGS/" + @bgs.name, @bgs.volume, @bgs.pitch)
  end     
  
  #--------------------------------------------------------------------------
  # * Turn off music
  #--------------------------------------------------------------------------
  def disable_music
      stop_bgm
      stop_bgs
  end     

end