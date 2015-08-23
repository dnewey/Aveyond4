#==============================================================================
# ** Debug
#==============================================================================

def log_err(msg) $debug.log(msg,'ERROR') end
def log_scr(msg) $debug.log(msg,'SCRIPT') end
def log_info(msg) $debug.log(msg,'INFO') end
def log_sys(msg) $debug.log(msg,'SYSTEM') end
def log_ev(msg) $debug.log(msg,'EVENT') end

class DebugManager

	attr_accessor :disable_flags

	OSD_OPACITY = 230

	INFO_COLOR = Color.new(220,171,1,OSD_OPACITY)
	SCRIPT_COLOR = Color.new(128,0,64,OSD_OPACITY)
	ERROR_COLOR = Color.new(202,0,0,OSD_OPACITY)
	SYSTEM_COLOR = Color.new(0,128,128,OSD_OPACITY)
	EVENT_COLOR = Color.new(128,128,128,OSD_OPACITY)

	attr_reader :last_color

	def initialize		
		return if !DEBUG

		$DEBUG = true

		# Temp debug options
		@disable_flags = false

		# Prepare log file
		@path = $appdata + "\\log.txt"
		File.open(@path, 'w') { |file| }	

		
		# Prepare on screen log
		@viewport = Viewport.new(0,0,640,480)
		@viewport.z = 5000
		
		@console = DebugConsole.new(@viewport)

		@menu = DebugMenu.new(@viewport)

		@track = Sprite.new(@viewport)
	    @track.bitmap = Bitmap.new(150,30)

		@last_color = INFO_COLOR

	end	

	def update
		return if !DEBUG

		@console.update if !@menu.active?
		@menu.update if !@console.active?

		# If tracking, do it
		if @track_obj
			@track.bitmap.fill(Color.new(0,0,0))
			@track.bitmap.font = $fonts.debug_min
   	 		@track.bitmap.draw_text(10,0,150,30,@track_obj.send(@track_val).to_s,0)
   	    end

	end

	def track(obj,val)

		@track_obj = obj
		@track_val = val

	end

	def log(msg,type='LOG')
	    return if !DEBUG

	    msg = "NIL" if msg == nil
	    if msg.is_a?(Array)
	    	msg = "Array: "+msg.join(", ")
	    end
	    if msg.is_a?(Hash)

	    end
		out = type + "\t" + msg.to_s
		File.open(@path, 'a') { |file| file.puts(out) }

		out = msg.to_s
		color = nil

		case type
			when 'INFO'; color = INFO_COLOR
			when 'SCRIPT'; color = SCRIPT_COLOR
			when 'ERROR'; color = ERROR_COLOR
			when 'SYSTEM'; color = SYSTEM_COLOR
			when 'EVENT'; color = EVENT_COLOR
		end

		@console.log([out,color])

		@last_color = color

	end

	def busy?
		return @console.active? || @menu.active?
	end
end