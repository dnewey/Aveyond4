#==============================================================================
# ** Console
#==============================================================================

class DebugConsole

	INPUT_COLOR = Color.new(30,30,30,210)

	MAX_LOGS = 11


	def initialize(vp)

		# Prepare log
		@history = []
		@console_text = ""
		@console_sprite = Sprite.new(vp)
		@console_sprite.move(0,410)
		refresh_console

		# Showing previous
		@logs = []
		@osd_sprite = Sprite.new(vp)

		hide

	end

	def update

		# If console not showing
		if !active?
			show if $keyboard.press?(VK_TAB) 
		end

		# Hide console if press TILDE
		hide if active? && $keyboard.press?(VK_TAB)
		hide if active? && $keyboard.press?(VK_ESC)

		if !active?
			if $keyboard.state?(VK_BS)
				@osd_sprite.show
			else
				@osd_sprite.hide
			end
		end

		return if !active?

		# Show last
		if $keyboard.press?(VK_DOWN)
			@console_text = @history.empty? ? "" : @history.pop
			refresh_console
		end
									
		# Check console input
		console_chars.each{ |c|
			if $keyboard.press?(c)
				@console_text += $keyboard.to_char(c)
				refresh_console
			end
		}

		# Check inputs now
		if $keyboard.press?(VK_ENTER)
			begin
				eval(@console_text)
			rescue Exception => e
			 	log_scr(e.class.to_s+" --- '" + @console_text + "'")		      
		    end
		    @history.push(@console_text)
			@console_text = ""
			refresh_console
		end

		if $keyboard.hold?(VK_BS)
			@console_text.chop!
			refresh_console
		end

	end

	def hide
		@console_sprite.hide
		@osd_sprite.hide
	end

	def show
		@console_sprite.show
		@osd_sprite.show
	end

	def active?
		return @console_sprite.visible
	end

	def refresh_console
		@console_sprite.bitmap = Bitmap.new(640,60)

		@console_sprite.bitmap.fill_rect(0,0,640,30,INPUT_COLOR)
		@console_sprite.bitmap.draw_text(8,0,640,30,"-> "+@console_text) # Make gfx.width

		if !@history.empty?
			@console_sprite.bitmap.fill_rect(0,30,640,30,Color.new(0,0,0,120))
			@console_sprite.bitmap.draw_text(8,30,640,30,"   "+@history[-1]) # Make gfx.width
		end	

	end

	def refresh_osd

		@osd_sprite.bitmap = Bitmap.new(640,480)#$game.width,$game.height)

		cx = 0
		cy = 6

		@osd_sprite.bitmap.fill_rect(cx,cy,640,50,Color.new(30,30,30,235))
		@osd_sprite.bitmap.font.size = 28
		@osd_sprite.bitmap.draw_text(cx+8,cy,640,50,"::LOG HISTORY::")

		cy += 60

		@osd_sprite.bitmap.font.size = 22

		@logs.each{ |log|

			out = log[0]
			color = log[1]

			size = @osd_sprite.bitmap.text_size(out)
			@osd_sprite.bitmap.fill_rect(cx,cy,size.width+20,size.height+6,color)
			@osd_sprite.bitmap.draw_text(cx+8,cy+3,600,size.height,out)

			cy += 32

		}

	end

	def log(msg)

		@logs.push(msg)
		@logs.shift while @logs.count > MAX_LOGS
		refresh_osd

	end

	def console_chars
		chars = (48..57).to_a
		chars += (65..90).to_a
		chars += (186..222).to_a
		chars += [32]
		return chars
	end

end