module Seal

  #LIB_DIR = "System/"
  class SealAPI < Win32API
    STRCPY_S = Win32API.new('msvcrt', 'strcpy_s', 'pll', 'i')

    def initialize(func, arg_types, return_type = 'i', *args)
      @return_string = return_type == 'p'
      library = File.join(defined?(LIB_DIR) ? LIB_DIR : '.', 'seal')
      super(library, "seal_#{func}", arg_types, return_type, *args)
    end

    def [](*args)
      result = call(*args)
      if @return_string and result.is_a? Integer
        # String pointer is returned to Ruby as an integer even though we
        # specified 'p' as the return value - possibly a bug in Ruby 1.9.3's
        # Win32API implementation. Work around it.
        message_buffer = ' ' * 128
        STRCPY_S.call(message_buffer, message_buffer.size, result)
        return message_buffer.strip
      end
      result
    end unless method_defined? :[]
  end

  module Helper
    GET_ERR_MSG = SealAPI.new('get_err_msg', 'i', 'p')

    class << self
      def define_enum(mod, constants, start_value = 0)
        constants.each_with_index do |constant, index|
          mod.const_set(constant, start_value + index)
        end
      end

      # Returns a destructor for a native Seal object. This is most likely
      # called in the initializer method, but we cannot define the proc handler
      # there because that will capture the binding of the implicit `self` (due
      # to the nature of closure), which makes the object that `self` refers to
      # unrecyclable.
      def free(obj, destroyer)
        lambda { |object_id| destroyer[obj] }
      end
    end

  private
    def check_error(error_code)
      raise SealError, GET_ERR_MSG[error_code], caller.shift if error_code != 0
      nil
    end

    def input_audio(media, filename, format, inputter)
      check_error(inputter[media, filename, format])
    end

    def set_obj_int(obj, int, setter)
      check_error(setter[obj, int])
      int
    end

    def get_obj_int(obj, getter)
      buffer = '    '
      check_error(getter[obj, buffer])
      buffer.unpack('i')[0]
    end

    def set_obj_char(obj, bool, setter)
      set_obj_int(obj, bool ? 1 : 0, setter)
    end

    def get_obj_char(obj, getter)
      buffer = ' '
      check_error(getter[obj, buffer])
      buffer.unpack('c')[0] != 0
    end

    # Win32API does not support float argument type, need to pass as integer.
    def set_obj_float(obj, float, setter)
      check_error(setter[obj, [float].pack('f').unpack('i')[0]])
      float
    end

    def get_obj_float(obj, getter)
      float_buffer = '    '
      check_error(getter[obj, float_buffer])
      float_buffer.unpack('f')[0]
    end
  end

  VERSION = SealAPI.new('get_version', 'v', 'p')[]

  class << self
    include Helper

    STARTUP = SealAPI.new('startup', 'p')
    CLEANUP = SealAPI.new('cleanup', 'v', 'v')
    GET_PER_SRC_EFFECT_LIMIT = SealAPI.new('get_per_src_effect_limit', 'v')

    def startup(device = nil)
      check_error(STARTUP[device ? device : 0])
    end

    def cleanup
      CLEANUP[]
    end

    def per_source_effect_limit
      GET_PER_SRC_EFFECT_LIMIT[]
    end
  end

  module Format
    Helper.define_enum(self, [
      :UNKNOWN,
      :WAV,
      :OV,
      :MPG
    ])
  end

  class SealError < Exception
  end

  class Buffer
    include Helper

    INIT = SealAPI.new('init_buf', 'p')
    DESTROY = SealAPI.new('destroy_buf', 'p')
    LOAD = SealAPI.new('load2buf', 'ppi')
    GET_SIZE = SealAPI.new('get_buf_size', 'pp')
    GET_FREQ = SealAPI.new('get_buf_freq', 'pp')
    GET_BPS = SealAPI.new('get_buf_bps', 'pp')
    GET_NCHANNELS = SealAPI.new('get_buf_nchannels', 'pp')

    def initialize(filename, format = Format::UNKNOWN)
      @buffer = '    '
      check_error(INIT[@buffer])
      input_audio(@buffer, filename, format, LOAD)
      ObjectSpace.define_finalizer(self, Helper.free(@buffer, DESTROY))
      self
    end

    def load(filename, format = Format::UNKNOWN)
      input_audio(@buffer, filename, format, LOAD)
      self
    end

    def size
      get_obj_int(@buffer, GET_SIZE)
    end

    def frequency
      get_obj_int(@buffer, GET_FREQ)
    end

    def bit_depth
      get_obj_int(@buffer, GET_BPS)
    end

    def channel_count
      get_obj_int(@buffer, GET_NCHANNELS)
    end
  end

  class Stream
    include Helper

    OPEN = SealAPI.new('open_stream', 'ppi')
    CLOSE = SealAPI.new('close_stream', 'p')
    REWIND = SealAPI.new('rewind_stream', 'p')

    class << self
      alias open new
    end

    def initialize(filename, format = Format::UNKNOWN)
      @stream = '    ' * 5
      input_audio(@stream, filename, format, OPEN)
      ObjectSpace.define_finalizer(self, Helper.free(@stream, CLOSE))
      self
    end

    def frequency
      field(4)
    end

    def bit_depth
      field(2)
    end

    def channel_count
      field(3)
    end

    def rewind
      check_error(REWIND[@stream])
    end

    def close
      check_error(CLOSE[@stream])
    end

  private
    def field(index)
      @stream[index * 4, 4].unpack('i')[0]
    end
  end

  class Reverb
    include Helper

    INIT = SealAPI.new('init_rvb', 'p')
    DESTROY = SealAPI.new('destroy_rvb', 'p')
    LOAD = SealAPI.new('load_rvb', 'pi')
    SET_DENSITY = SealAPI.new('set_rvb_density', 'pi')
    SET_DIFFUSION = SealAPI.new('set_rvb_diffusion', 'pi')
    SET_GAIN = SealAPI.new('set_rvb_gain', 'pi')
    SET_HFGAIN = SealAPI.new('set_rvb_hfgain', 'pi')
    SET_DECAY_TIME = SealAPI.new('set_rvb_decay_time', 'pi')
    SET_HFDECAY_RATIO = SealAPI.new('set_rvb_hfdecay_ratio', 'pi')
    SET_REFLECTIONS_GAIN = SealAPI.new('set_rvb_reflections_gain', 'pi')
    SET_REFLECTIONS_DELAY = SealAPI.new('set_rvb_reflections_delay', 'pi')
    SET_LATE_GAIN = SealAPI.new('set_rvb_late_gain', 'pi')
    SET_LATE_DELAY = SealAPI.new('set_rvb_late_delay', 'pi')
    SET_AIR_ABSORBTION_HFGAIN =
      SealAPI.new('set_rvb_air_absorbtion_hfgain', 'pi')
    SET_ROOM_ROLLOFF_FACTOR = SealAPI.new('set_rvb_room_rolloff_factor', 'pi')
    SET_HFDECAY_LIMITED = SealAPI.new('set_rvb_hfdecay_limited', 'pi')
    GET_DENSITY = SealAPI.new('get_rvb_density', 'pp')
    GET_DIFFUSION = SealAPI.new('get_rvb_diffusion', 'pp')
    GET_GAIN = SealAPI.new('get_rvb_gain', 'pp')
    GET_HFGAIN = SealAPI.new('get_rvb_hfgain', 'pp')
    GET_DECAY_TIME = SealAPI.new('get_rvb_decay_time', 'pp')
    GET_HFDECAY_RATIO = SealAPI.new('get_rvb_hfdecay_ratio', 'pp')
    GET_REFLECTIONS_GAIN = SealAPI.new('get_rvb_reflections_gain', 'pp')
    GET_REFLECTIONS_DELAY = SealAPI.new('get_rvb_reflections_delay', 'pp')
    GET_LATE_GAIN = SealAPI.new('get_rvb_late_gain', 'pp')
    GET_LATE_DELAY = SealAPI.new('get_rvb_late_delay', 'pp')
    GET_AIR_ABSORBTION_HFGAIN =
      SealAPI.new('get_rvb_air_absorbtion_hfgain', 'pp')
    GET_ROOM_ROLLOFF_FACTOR = SealAPI.new('get_rvb_room_rolloff_factor', 'pp')
    IS_HFDECAY_LIMITED = SealAPI.new('is_rvb_hfdecay_limited', 'pp')

    def initialize(preset = nil)
      @effect = '    '
      check_error(INIT[@effect])
      load(preset) if preset
      ObjectSpace.define_finalizer(self, Helper.free(@effect, DESTROY))
      self
    end

    def load(preset)
      check_error(LOAD[@effect, preset])
    end

    def density=(density)
      set_obj_float(@effect, density, SET_DENSITY)
    end

    def diffusion=(diffusion)
      set_obj_float(@effect, diffusion, SET_DIFFUSION)
    end

    def gain=(gain)
      set_obj_float(@effect, gain, SET_GAIN)
    end

    def hfgain=(hfgain)
      set_obj_float(@effect, hfgain, SET_HFGAIN)
    end

    def decay_time=(decay_time)
      set_obj_float(@effect, decay_time, SET_DECAY_TIME)
    end

    def hfdecay_ratio=(hfdecay_ratio)
      set_obj_float(@effect, hfdecay_ratio, SET_HFDECAY_RATIO)
    end

    def reflections_gain=(reflections_gain)
      set_obj_float(@effect, reflections_gain, SET_REFLECTIONS_GAIN)
    end

    def reflections_delay=(reflections_delay)
      set_obj_float(@effect, reflections_delay, SET_REFLECTIONS_DELAY)
    end

    def late_gain=(late_gain)
      set_obj_float(@effect, late_gain, SET_LATE_GAIN)
    end

    def late_delay=(late_delay)
      set_obj_float(@effect, late_delay, SET_LATE_DELAY)
    end

    def air_absorbtion_hfgain=(air_absorbtion_hfgain)
      set_obj_float(@effect, air_absorbtion_hfgain, SET_AIR_ABSORBTION_HFGAIN)
    end

    def room_rolloff_factor=(room_rolloff_factor)
      set_obj_float(@effect, room_rolloff_factor, SET_ROOM_ROLLOFF_FACTOR)
    end

    def hfdecay_limited=(hfdecay_limited)
      set_obj_char(@effect, hfdecay_limited, SET_HFDECAY_LIMITED)
    end

    def density
      get_obj_float(@effect, GET_DENSITY)
    end

    def diffusion
      get_obj_float(@effect, GET_DIFFUSION)
    end

    def gain
      get_obj_float(@effect, GET_GAIN)
    end

    def hfgain
      get_obj_float(@effect, GET_HFGAIN)
    end

    def decay_time
      get_obj_float(@effect, GET_DECAY_TIME)
    end

    def hfdecay_ratio
      get_obj_float(@effect, GET_HFDECAY_RATIO)
    end

    def reflections_gain
      get_obj_float(@effect, GET_REFLECTIONS_GAIN)
    end

    def reflections_delay
      get_obj_float(@effect, GET_REFLECTIONS_DELAY)
    end

    def late_gain
      get_obj_float(@effect, GET_LATE_GAIN)
    end

    def late_delay
      get_obj_float(@effect, GET_LATE_DELAY)
    end

    def air_absorbtion_hfgain
      get_obj_float(@effect, GET_AIR_ABSORBTION_HFGAIN)
    end

    def room_rolloff_factor
      get_obj_float(@effect, GET_ROOM_ROLLOFF_FACTOR)
    end

    def hfdecay_limited
      get_obj_char(@effect, IS_HFDECAY_LIMITED)
    end

    alias hfdecay_limited? hfdecay_limited

    module Preset
      Helper.define_enum(self, [
        :GENERIC,
        :PADDEDCELL,
        :ROOM,
        :BATHROOM,
        :LIVINGROOM,
        :STONEROOM,
        :AUDITORIUM,
        :CONCERTHALL,
        :CAVE,
        :ARENA,
        :HANGAR,
        :CARPETEDHALLWAY,
        :HALLWAY,
        :STONECORRIDOR,
        :ALLEY,
        :FOREST,
        :CITY,
        :MOUNTAINS,
        :QUARRY,
        :PLAIN,
        :PARKINGLOT,
        :SEWERPIPE,
        :UNDERWATER,
        :DRUGGED,
        :DIZZY,
        :PSYCHOTIC
      ])
    end
  end

  class Source
    include Helper

    INIT = SealAPI.new('init_src', 'p')
    DESTROY = SealAPI.new('destroy_src', 'p')
    PLAY = SealAPI.new('play_src', 'p')
    STOP = SealAPI.new('stop_src', 'p')
    REWIND = SealAPI.new('rewind_src', 'p')
    PAUSE = SealAPI.new('pause_src', 'p')
    DETACH = SealAPI.new('detach_src_audio', 'p')
    MOVE = SealAPI.new('move_src', 'p')
    SET_BUF = SealAPI.new('set_src_buf', 'pp')
    SET_STREAM = SealAPI.new('set_src_stream', 'pp')
    FEED_EFS = SealAPI.new('feed_efs', 'ppi')
    UPDATE = SealAPI.new('update_src', 'p')
    SET_POS = SealAPI.new('set_src_pos', 'piii')
    SET_VEL = SealAPI.new('set_src_vel', 'piii')
    SET_GAIN = SealAPI.new('set_src_gain', 'pi')
    SET_PITCH = SealAPI.new('set_src_pitch', 'pi')
    SET_AUTO = SealAPI.new('set_src_auto', 'pi')
    SET_RELATIVE = SealAPI.new('set_src_relative', 'pi')
    SET_LOOPING = SealAPI.new('set_src_looping', 'pi')
    SET_QUEUE_SIZE = SealAPI.new('set_src_queue_size', 'pi')
    SET_CHUNK_SIZE = SealAPI.new('set_src_chunk_size', 'pi')
    GET_POS = SealAPI.new('get_src_pos', 'pppp')
    GET_VEL = SealAPI.new('get_src_vel', 'pppp')
    GET_GAIN = SealAPI.new('get_src_gain', 'pp')
    GET_PITCH = SealAPI.new('get_src_pitch', 'pp')
    GET_AUTO = SealAPI.new('is_src_auto', 'pp')
    GET_RELATIVE = SealAPI.new('is_src_relative', 'pp')
    GET_LOOPING = SealAPI.new('is_src_looping', 'pp')
    GET_QUEUE_SIZE = SealAPI.new('get_src_queue_size', 'pp')
    GET_CHUNK_SIZE = SealAPI.new('get_src_chunk_size', 'pp')
    GET_TYPE = SealAPI.new('get_src_type', 'pp')
    GET_STATE = SealAPI.new('get_src_state', 'pp')

    def initialize
      @source = '    ' * 5
      check_error(INIT[@source])
      ObjectSpace.define_finalizer(self, Helper.free(@source, DESTROY))
      self
    end

    def play
      operate(PLAY)
    end

    def stop
      operate(STOP)
    end

    def rewind
      operate(REWIND)
    end

    def pause
      operate(PAUSE)
    end

    def move
      operate(MOVE)
    end

    def buffer=(buffer)
      set_audio(:@buffer, buffer, SET_BUF)
    end

    def stream=(stream)
      set_audio(:@stream, stream, SET_STREAM)
    end

    attr_reader :buffer, :stream

    def feed(effect_slot, index)
      native_efs_obj = effect_slot.instance_variable_get(:@effect_slot)
      check_error(FEED_EFS[@source, native_efs_obj, index])
      self
    end

    def update
      operate(UPDATE)
    end

    def position=(position)
      set_3float(position, SET_POS)
    end

    def velocity=(velocity)
      set_3float(velocity, SET_VEL)
    end

    def gain=(gain)
      return if gain < 0
      set_obj_float(@source, gain, SET_GAIN)
    end

    def pitch=(pitch)
      set_obj_float(@source, pitch, SET_PITCH)
    end

    def auto=(auto)
      set_obj_char(@source, auto, SET_AUTO)
    end

    def queue_size=(queue_size)
      set_obj_int(@source, queue_size, SET_QUEUE_SIZE)
    end

    def chunk_size=(chunk_size)
      set_obj_int(@source, chunk_size, SET_CHUNK_SIZE)
    end

    def relative=(relative)
      set_obj_char(@source, relative, SET_RELATIVE)
    end

    def looping=(looping)
      set_obj_char(@source, looping, SET_LOOPING)
    end

    def position
      get_3float(GET_POS)
    end

    def velocity
      get_3float(GET_VEL)
    end

    def gain
      get_obj_float(@source, GET_GAIN)
    end

    def pitch
      get_obj_float(@source, GET_PITCH)
    end

    def auto
      get_obj_char(@source, GET_AUTO)
    end

    def relative
      get_obj_char(@source, GET_RELATIVE)
    end

    def looping
      get_obj_char(@source, GET_LOOPING)
    end

    alias auto? auto
    alias relative? relative
    alias looping? looping

    def queue_size
      get_obj_int(@source, GET_QUEUE_SIZE)
    end

    def chunk_size
      get_obj_int(@source, GET_CHUNK_SIZE)
    end

    def type
      case get_obj_int(@source, GET_TYPE)
      when Type::STATIC
        Type::STATIC
      when Type::STREAMING
        Type::STREAMING
      else
        Type::UNDETERMINED
      end
    end

    def state
      case get_obj_int(@source, GET_STATE)
      when State::PLAYING
        State::PLAYING
      when State::PAUSED
        State::PAUSED
      when State::STOPPED
        State::STOPPED
      else
        State::INITIAL
      end
    end

  private
    def operate(operation)
      check_error(operation[@source])
      self
    end

    def set_audio(var, audio, setter)
      if audio.nil?
        operate(DETACH)
      else
        check_error(setter[@source, audio.instance_variable_get(var)])
      end
      instance_variable_set(var, audio)
      audio
    end

    def set_3float(float_tuple, setter)
      integer_tuple = float_tuple.pack('f*').unpack('i*')
      check_error(setter[@source, *integer_tuple])
      float_tuple
    end

    def get_3float(getter)
      float_tuple_buffers = Array.new(3) { '    ' }
      check_error(getter[@source, *float_tuple_buffers])
      float_tuple_buffers.join.unpack('f*')
    end

    module State
      Helper.define_enum(self, [
        :INITIAL,
        :PLAYING,
        :PAUSED,
        :STOPPED
      ])
    end

    module Type
      Helper.define_enum(self, [
        :UNDETERMINED,
        :STATIC,
        :STREAMING
      ])
    end
  end

  class EffectSlot
    include Helper

    INIT = SealAPI.new('init_efs', 'p')
    DESTROY = SealAPI.new('destroy_efs', 'p')
    SET_EFFECT = SealAPI.new('set_efs_effect', 'pp')
    SET_GAIN = SealAPI.new('set_efs_gain', 'pi')
    SET_AUTO = SealAPI.new('set_efs_auto', 'pi')
    GET_GAIN = SealAPI.new('get_efs_gain', 'pp')
    GET_AUTO = SealAPI.new('is_efs_auto', 'pp')

    def initialize(effect = nil)
      @effect_slot = '    '
      check_error(INIT[@effect_slot])
      self.effect = effect if effect
      ObjectSpace.define_finalizer(self, Helper.free(@effect_slot, DESTROY))
      self
    end

    def effect=(effect)
      native_effect_obj = effect ? effect.instance_variable_get(:@effect) : 0
      check_error(SET_EFFECT[@effect_slot, native_effect_obj])
      @effect = effect
      effect
    end

    attr_reader :effect

    def gain=(gain)
      set_obj_float(@effect_slot, gain, SET_GAIN)
    end

    def gain
      get_obj_float(@effect_slot, GET_GAIN)
    end

    def auto=(auto)
      set_obj_char(@effect_slot, auto, SET_AUTO)
    end

    def auto
      get_obj_char(@effect_slot, GET_AUTO)
    end

    alias auto? auto
  end
end