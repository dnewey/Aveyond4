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
    @crossfade = Seal::Source.new # Swap with music after done

    @atmosphere = Seal::Source.new

    @environmental = [] # Looping, fade by distance
    # UNLIMITED

    @system = []
    2.times{ @system.push(Seal::Source.new) }

    @sfx = []
    5.times{ @sfx.push(Seal::Source.new) }
    # NEVER DESTROY

    @mode = :normal

    @sfx_vol = 1.0 # Set by mode
    
  end

  def env(sound,pos)
    @environmental.each{ |snd|
      if snd.file == sound
        snd.addpos(pos)
        return
      end
    }
    @environmental.push(EnviroSource.new(sound,pos))
  end

  def music
    @source.stream = Seal::Stream.open("Audio/BGM/gunblade.ogg",Seal::Format::OV)

  end

  def inside

  end

  def sfx
    
    @source.play
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
    @source.pause
  end


  def unpause
    @source.play
  end



  def change_mode(mode)
    @mode = mode

    # Create new effect and volume modifier
    case mode
      when :normal


      when :cave
        # pre =Seal::Reverb::Preset::CAVE
          # r = Seal::Reverb.new(pre)
          # @slot = Seal::EffectSlot.new(r)
          # @source.feed(@slot, 0)
    end

  end

  def update

    @environmental.each{ |e| e.update }

  end

end