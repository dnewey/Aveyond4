#==============================================================================
# ** Debug
#==============================================================================

def log_err(msg) $debug.log(msg,'ERROR') end
def log_scr(msg) $debug.log(msg,'SCRIPT') end
def log_info(msg) $debug.log(msg,'INFO') end
def log_sys(msg) $debug.log(msg,'SYSTEM') end
def log_ev(msg) $debug.log(msg,'EVENT') end

class DebugManager

	DEBUG_TIME = 240

	INFO_COLOR = Color.new(220,171,1,120)
	SCRIPT_COLOR = Color.new(128,0,64,120)
	ERROR_COLOR = Color.new(202,0,0,120)
	SYSTEM_COLOR = Color.new(128,0,128,120)
	EVENT_COLOR = Color.new(0,128,128,120)

	INPUT_COLOR = Color.new(0,0,0,160)

	def initialize		
		return if !DEBUG

		# Prepare log file
		@path = $appdata + "\\log.txt"
		File.open(@path, 'w') { |file| }	
		
		# Prepare on screen log
		@viewport = Viewport.new(0,0,640,480)
		@viewport.z = 9999
		
		@sprites = []
		@timer = 120

		# Prepare log
		@previous_text = ""
		@console_text = ""
		@console_sprite = Sprite.new(@viewport)
		@console_sprite.move(20,400)
		@console_sprite.hide
		refresh_console

	end
	

	def update

		if Input.press?(Input::B)
			@timer = 0
		end

		# Fade away sprites
		@timer -= 1
		if !@sprites.empty? && @timer < 20
			@sprites.each{ |s| s.opacity = @timer * 12.6 }
		end
		if @timer <= 0
			@sprites.each{ |s| s.dispose }.clear
		end		

		# Debug keys
		debug_keys

		# If console not showing
		if !@console_sprite.visible
			$keyboard.press?(192) ? @console_sprite.show : return
		end

		# Hide console
		return @console_sprite.hide if $keyboard.press?(192)


		if $keyboard.press?(18)
			@console_text = @previous_text
			refresh_console
		end
									
		# Check console input
		console_chars.each{ |c|
			if $keyboard.hold?(c)
				@console_text += $keyboard.to_char(c)
				refresh_console
			end
		}

		# Check inputs now
		if Input.trigger?(Input::C)
			begin
				eval(@console_text)
			rescue Exception => e
			 	log_scr("Console FAIL: "+e.class.to_s+" --- '" + @console_text + "'")		      
		    end
		    @previous_text = @console_text
			@console_text = ""
			refresh_console
		end

		if $keyboard.press?(8)
			@console_text.chop!
			refresh_console
		end

	end

	def debug_keys

		if $keyboard.press?(48)
			log_info "1 - Toggle Superspeed"
			log_info "2 - Do something else"
		end

	end

	def refresh_console
		@console_sprite.bitmap = Bitmap.new(600,30)
		@console_sprite.bitmap.font.size = 22
		@console_sprite.bitmap.font.bold = true
		@console_sprite.bitmap.fill(INPUT_COLOR)
		@console_sprite.bitmap.draw_text(8,0,600,24,@console_text)
	end

	def console_chars
		chars = (48..57).to_a
		chars += (65..90).to_a
		chars += (186..222).to_a
		chars += [32]
		return chars
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

		# Create the sprite
		spr = Sprite.new(@viewport)
		spr.bitmap = Bitmap.new(600,24)
		spr.bitmap.font.size = 18
		spr.bitmap.font.bold = true
		w = spr.bitmap.text_size(out).width
		spr.bitmap.fill_rect(0,0,w+20,spr.bitmap.height,color)
		spr.bitmap.draw_text(8,0,600,24,out)

		# Position
		spr.x = 5
		spr.y = 5 + 28 * @sprites.count
		@sprites.push(spr)

		# Reset log display
		@timer = DEBUG_TIME
		@sprites.each{ |s| s.opacity = 255 }

	end

end