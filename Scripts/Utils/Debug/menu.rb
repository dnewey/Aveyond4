#==============================================================================
# ** Actions
#==============================================================================

class DebugMenu

	def initialize(vp)

		@actions = []
		@idx = 0

		@mnu_sprite = Sprite.new(vp)
		@idx_sprite = Sprite.new(vp)
		@text_sprite = Sprite.new(vp)
		@text_sprite.z += 10

		@idx_sprite.y = 10

		@menu_title = "DEBUG MENU"

		@esc = Proc.new{ hide }

		@cursor_pos = {}

		page(:main)

		hide

	end

	def page(newpage)

		@cursor_pos[@page] = @idx

		clear

		@page = newpage

		case newpage
			when :main

				add(">> Debug Settings",Proc.new{ page(:debug) })
				
				add("-- Disable Flags",Proc.new{ $debug.disable_flags = true })
				add("-- Export Text",Proc.new{ execute_spellcheck })


				@esc = Proc.new{ hide }

			when :settings

				@menu_title = "GENERAL SETTINGS"

				add(":: Toggle Fullscreen",Proc.new{ $game.flip_window })

				@esc = Proc.new{ page(:main) }

			when :debug

				@menu_title = "DEBUG SETTINGS"

				add(":: Toggle skip title - "+$settings.debug_skip_title.to_s.upcase,Proc.new{ $settings.debug_skip_title ^= true })
				add(":: Toggle draw fps - "+$settings.debug_draw_fps.to_s.upcase,Proc.new{ $settings.debug_draw_fps ^= true })
				add(":: Toggle draw helpers - "+$settings.debug_draw_helpers.to_s.upcase,Proc.new{ $settings.debug_draw_helpers ^= true })
				add(":: Toggle power test - "+$settings.debug_power_test.to_s.upcase,Proc.new{ $settings.debug_power_test ^= true })

				@esc = Proc.new{ page(:main) }

		end
		refresh
	end


	def clear
		#@idx = 0
		@actions.clear
		refresh
	end

	def add(text,proc)
		@actions.push([text,proc])
	end

	def update

		if $keyboard.press?(VK_TILDE)
			active? ? @esc.call : show
		end

		if $keyboard.press?(VK_ESC)
			@esc.call if active?
		end

		return if !active?

		if $keyboard.press?(VK_ENTER)
			@actions[@idx][1].call if @actions[@idx][1] != nil
			page(@page)
		end
		
		if $keyboard.press?(VK_DOWN)
			@idx += 1 if @idx != @actions.count - 1
			#@idx_sprite.bitmap.fill(Color.new(rand(255),rand(255),rand(255)))
		end

		if $keyboard.press?(VK_UP)
			@idx -= 1 if @idx != 0
			#@idx_sprite.bitmap.fill(Color.new(rand(255),rand(255),rand(255)))
		end

		@idx_sprite.y = 66 + (@idx * 34)
		

		#refresh

	end

	def refresh


		@idx = @cursor_pos.has_key?(@page) ? @cursor_pos[@page] : 0

		@mnu_sprite.bitmap = Bitmap.new(640,480)#$game.width,$game.height)
		@text_sprite.bitmap = Bitmap.new(640,480)#$game.width,$game.height)

		@idx_sprite.bitmap = Bitmap.new(400,30)
		@idx_sprite.bitmap.fill(Color.new(40,110,170,240))

		cx = 0
		cy = 6

		@mnu_sprite.bitmap.fill_rect(cx,cy,640,50,Color.new(30,30,30,235))
		@text_sprite.bitmap.font.size = 28
		@text_sprite.bitmap.draw_text(cx+8,cy,640,50,"::"+@menu_title+"::")

		cy += 60

		@text_sprite.bitmap.font.size = 22

		@actions.each_index{ |i|

			out = @actions[i][0]
			color = Color.new(30,30,30,210)

			size = @mnu_sprite.bitmap.text_size(out)
			@mnu_sprite.bitmap.fill_rect(cx,cy,400,30,color)
			@text_sprite.bitmap.draw_text(cx+8,cy+0,600,size.height+6,out)

			cy += 34

		}

	end


	def show
		page(:main)
		@mnu_sprite.show
		@idx_sprite.show
		@text_sprite.show
	end

	def hide
		@mnu_sprite.hide
		@idx_sprite.hide
		@text_sprite.hide
	end

	def active?
		@mnu_sprite.visible
	end

end


