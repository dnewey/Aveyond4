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

		page(:main)

		hide

	end

	def page(newpage)
		clear

		case newpage
			when :main
				add("General Settings",Proc.new{ page(:settings) })
				add("Debug Settings",Proc.new{ page(:debug) })
				add("Progress: #{$progress.progress}",nil) if !$progress.nil?
				@esc = Proc.new{ hide }
			when :settings
				add("Toggle Fullscreen",Proc.new{ $game.toggle })
				@esc = Proc.new{ page(:main) }

		end
		refresh
	end


	def clear
		@idx = 0
		@actions.clear
		refresh
	end

	def add(text,proc)
		@actions.push([text,proc])
	end

	def update

		if $keyboard.press?(VK_ESC)
			active? ? @esc.call : show
		end

		return if !active?

		if $keyboard.press?(VK_ENTER)
			@actions[@idx][1].call if @actions[@idx][1] != nil
		end
		
		if $keyboard.press?(VK_DOWN)
			@idx += 1 if @idx != @actions.count - 1
		end

		if $keyboard.press?(VK_UP)
			@idx -= 1 if @idx != 0
		end

		@idx_sprite.y = 46 + (@idx * 34)
		

		#refresh

	end

	def refresh

		@mnu_sprite.bitmap = Bitmap.new(640,480)#$game.width,$game.height)
		@text_sprite.bitmap = Bitmap.new(640,480)#$game.width,$game.height)

		@idx_sprite.bitmap = Bitmap.new(400,30)
		@idx_sprite.bitmap.fill(Color.new(50,120,180,240))

		cx = 0
		cy = 6

		@mnu_sprite.bitmap.fill_rect(cx,cy,640,30,Color.new(0,0,0,160))
		@text_sprite.bitmap.draw_text(cx+8,cy,640,30,@menu_title)

		cy += 40

		@actions.each_index{ |i|

			out = "-> "+@actions[i][0]
			color = Color.new(0,0,0,120)

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


