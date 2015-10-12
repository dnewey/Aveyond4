#==============================================================================
# ** Audio Manager
#==============================================================================

class AudioManager

  attr_accessor :music_target, :atmosphere_target
  attr_accessor :music_gain, :atmosphere_gain

  def initialize

    begin
      Seal.startup
    rescue
      retry
    end

    @music = Seal::Source.new
    @atmosphere = Seal::Source.new

    @music_file = nil
    @atmosphere_file = nil

    # Fade targets
    @music_gain = 1.0
    @music_target = 1.0
    @atmosphere_gain = 1.0
    @atmosphere_target = 1.0

    # Looping, fade by distance
    @environmental = [] 

    # System Effects
    @sys = []

    # Sound effects with reverb
    @sfx = []

    # Queue of sfx to play [[file,delay,vol]]
    @queue = [] 

    @mode = :normal
    @effect = nil

    @sfx_vol = 1.0 # Set by mode

    #change_mode(:cave)
    
  end

  def dispose

    # Destroy all the sources

    Seal.cleanup
  end

  def fadeout
    @music_target = 0.0
    @atmosphere_target = 0.0
  end

  def env(file,pos)
    @environmental.each{ |snd|
      if snd.file == file
        snd.addpos(pos)
        return
      end
    }
    @environmental.push(EnviroSource.new(file,pos))
    @environmental.each{ |e| e.update }    
  end

  def clear_env
    @environmental.each{ |e|
      e.stop
      e.dispose
      e = nil
    }
    @environmental.clear
  end

  def music(file,vol=1.0)

    if @music_file == file
        @music_gain = 1.0
        @music_target = 1.0
        @music.play if !@music.playing?
      return
    end

    @music.stop if @music 

    if file == nil || file == ''     
      @music_file = nil    
      return
    end
    
    @music = nil
    @music = Seal::Source.new

    @music_file = file

    @music_gain = 1.0
    @music_target = 1.0

    @music.gain = @music_gain * $settings.music_vol
    @music.looping = true
    @music.stream = Seal::Stream.open("Audio/Music/#{file}.ogg")
    @music.play
    
  end

  def atmosphere(file)

    # Nightwatch hack
    file = 'woods-night' if flag?('night-time')

      if @atmosphere_file == file
        @atmosphere_gain = 1.0
        @atmosphere_target = 1.0
      return
    end


    @atmosphere.stop if @music

    if file == nil  || file == ''
      @atmosphere_file = nil
      return
    end

    @atmosphere = nil
    @atmosphere = Seal::Source.new
    
    @atmosphere_file = file

    @atmosphere_gain = 1.0
    @atmosphere_target = 1.0

    @atmosphere.gain = @atmosphere_gain * $settings.music_vol
    @atmosphere.looping = true
    @atmosphere.stream = Seal::Stream.open("Audio/Atmosphere/#{file}.ogg")
    @atmosphere.play

  end

  def sys(file,vol=1.0)

    # Check through sources, if empty, use, if none, add
    @sys.each{ |src|
      if !src.playing?
        src.buffer = Seal::Buffer.new("Audio/Sys/#{file}.ogg")
        src.gain = vol * $settings.sound_vol
        src.play
        return
      end
    }

    # Add new
    src = Seal::Source.new
    buf = Seal::Buffer.new("Audio/Sys/#{file}.ogg")
    src.gain = vol * $settings.sound_vol
    src.buffer = buf
    src.play
    @sys.push(src)

  end

  def sfx(file,vol=1.0)

    # Check through sources, if empty, use, if none, add
    @sfx.each{ |src|
      if !src.playing?
        src.buffer = Seal::Buffer.new("Audio/Sounds/#{file}.ogg")
        src.gain = vol * $settings.sound_vol
        src.play
        return
      end
    }

    # Add new
    src = Seal::Source.new
    buf = Seal::Buffer.new("Audio/Sounds/#{file}.ogg")
    src.buffer = buf
    src.gain = vol * $settings.sound_vol
    src.feed(@effect, 0) if @effect != nil
    src.play
    @sfx.push(src)

  end

  def queue(file,vol=1.0,delay=0)
    @queue.push([file,delay,vol])
  end

  def pause
    @music.pause
  end

  def unpause
    @music.play
  end

  # Change mode between maps so clear sources also
  def change_mode(mode)

    #return

    log_sys(mode)

    @mode = mode
    preset = nil

    # Create new effect and volume modifier
    case mode
      when 'normal', ''
        preset = nil
        @effect = nil        

      when 'cave'
        preset = Seal::Reverb::Preset::CAVE
        
    end

    # Prepare the effect to be added to each newly created source
    if preset != nil
      @effect = Seal::EffectSlot.new(Seal::Reverb.new(preset))
    end

    #@sfx.each{ |s| s = nil }
    @sfx = []
    GC.start
   
  end

  def refresh_sound_volume
    (@sys + @sfx).each{ |s| s.gain = $settings.sound_vol}
  end

  def minimize
    @atmosphere_target = 0.0
    @music_target = 0.0
    @atmosphere_gain = 0.4
    @music_gain = 0.4
  end

  def update

    if @atmosphere != nil
      if @atmosphere_target != @atmosphere_gain
        if @atmosphere_target > @atmosphere.gain
          @atmosphere_gain += 0.02
          @atmosphere_gain = 1.0 if @atmosphere_gain > 1.0
        else
          @atmosphere_gain -= 0.02
          @atmosphere_gain = 0.0 if @atmosphere_gain < 0.0
        end      
      end
      @atmosphere.gain = @atmosphere_gain * $settings.music_vol
    end

    if @music != nil
      if @music_target != @music_gain
        if @music_target > @music.gain
          @music_gain += 0.02
          @music_gain = 1.0 if @music_gain > 1.0
        else
          @music_gain -= 0.02
          @music_gain = 0.0 if @music_gain < 0.0
        end      
      end
      @music.gain = @music_gain * $settings.music_vol
    end

    @environmental.each{ |e| e.update }

    # Play sfx on delay
    @queue.each{ |i|
      i[1] -= 1
      if i[1] <= 0
        sfx(i[0],i[2])
      end
    }

    @queue.delete_if{ |i| i[1] <= 0 }

  end

end

class EnviroSource < Seal::Source

  attr_reader :file

  def initialize(sound,pos)
    super()

    @file = sound

    @positions = [pos]
    self.buffer = Seal::Buffer.new("Audio/Sounds/#{sound}.ogg")
    self.looping = true
    self.gain = 0.0
    self.play

    @short = 96 * 4 # *4 to convert to REAL coords
    @long = 450 * 4

  end

  def dispose

  end

  def addpos(pos)

    @positions.push(pos)

  end

  def update

    # Use player pos for now
    px = $player.real_x
    py = $player.real_y

    # Find closest point
    src = nil
    mn = 999999999
    @positions.each{ |p| 
      dist = ((px-p[0]) * (px-p[0])) +
             ((py-p[1]) * (py-p[1]))
      if dist < mn
        mn = dist
        src = p
      end
    }

    # Use distance to figure volume
    dist = ((px-src[0]) * (px-src[0])) +
           ((py-src[1]) * (py-src[1]))

    dist = Math.sqrt(dist)

    # If under min, full volume
    if dist < @short #* @short
      self.gain = 0.5
      return
    end

    # If over max, off
    if dist > @long #* @long
      self.gain = 0.0
      return
    end

    # Scale
    self.gain = (1.0 - (dist - @short).to_f / (@long-@short).to_f) * 0.5

  end

end