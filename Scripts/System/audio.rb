#==============================================================================
# ** Audio Manager
#==============================================================================

class EnviroSource < Seal::Source

  attr_reader :file

  def initialize(sound,pos)
    super()

    @file = sound

    @positions = [pos]
    self.buffer = Seal::Buffer.new("Audio/SE/#{sound}.ogg")
    self.looping = true
    self.play

    @short = 96 * 4 # *4 to convert to REAL coords
    @long = 320 * 4

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
    if dist < @short
      self.gain = 1.0
      return
    end

    # If over max, off
    if dist > @long
      self.gain = 0.0
      return
    end

    # Scale
    self.gain = 1.0 - (dist - @short).to_f / (@long-@short).to_f


  end

end

class AudioManager


  def initialize

    Seal.startup

    @music = Seal::Source.new
    @atmosphere = Seal::Source.new

    # Looping, fade by distance
    @environmental = [] 

    # System Effects
    @system = []

    # Sound effects with reverb
    @sfx = []


    @mode = :normal
    @effect = nil

    @sfx_vol = 1.0 # Set by mode

    #change_mode(:cave)
    
  end

  def env(file,pos)
    @environmental.each{ |file|
      if snd.file == file
        snd.addpos(pos)
        return
      end
    }
    @environmental.push(EnviroSource.new(file,pos))
  end

  def music(file)
    @music.stream = Seal::Stream.open(file)
    @music.play
  end

  def sys(file,vol)

    log_scr(@sys.count)

    # Check through sources, if empty, use, if none, add
    @sys.each{ |src|
      if !src.playing?
        src.buffer = Seal::Buffer.new("Audio/SE/#{file}.ogg")
        src.play
        return
      end
    }

    # Add new
    src = Seal::Source.new
    buf = Seal::Buffer.new("Audio/SE/#{file}.ogg")
    src.buffer = buf
    src.play
    @sys.push(src)

  end

  def sfx(file,vol)

    log_scr(@sfx.count)

    # Check through sources, if empty, use, if none, add
    @sfx.each{ |src|
      if !src.playing?
        src.buffer = Seal::Buffer.new("Audio/SE/#{file}.ogg")
        
        src.play
        return
      end
    }

    # Add new
    src = Seal::Source.new
    buf = Seal::Buffer.new("Audio/SE/#{file}.ogg")
    src.buffer = buf
    src.feed(@effect, 0) if @effect != nil
    src.play
    @sfx.push(src)

  end

  def dip(src)

    # Dip the music while the src plays then fade up

  end


  # send_blank to force start music
  def play_bgm(bgm)
    @bgm = bgm
    Audio.bgm_play("Audio/BGM/" + bgm)
  end

  def music(m)
    @music = Seal::Stream.new("Audio/BGM/gunblade.ogg")
  end



  def pause
    @music.pause
  end

  def unpause
    @music.play
  end

  # Change mode between maps so clear sources also
  def change_mode(mode)

    @mode = mode

    # Create new effect and volume modifier
    case mode
      when :normal
        @effect = nil
        return

      when :cave
        preset = Seal::Reverb::Preset::CAVE
        
    end

    # Prepare the effect to be added to each newly created source
    @effect = Seal::EffectSlot.new(Seal::Reverb.new(preset))
   
  end

  def update

    @environmental.each{ |e| e.update }

  end

end