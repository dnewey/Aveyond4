#==============================================================================
# Ui_Book
#==============================================================================

class Ui_Book < SpriteGroup

	def initialize(vp)
		super()

		@base = Sprite.new(vp)
		@base.bitmap = $cache.menu_book('base')
		add(@base,0,0)

		@page = Sprite.new(vp)
		#@page.bitmap = $cache.menu_book('sampler')
		add(@page,0,0)

		@turner = Sprite.new(vp)
		@turner.bitmap = $cache.menu_book('turn-1')
		@turner.opacity = 0
		add(@turner,0,0)

		move(48,4)

		@state = :idle

		@page_idx = $menu.potion_page
		@turn_step = 20
		@turn_dir = 1

		@page.bitmap = $cache.menu_book("page-#{@page_idx}")
		@state = :fadein

		# Key display
		@key_left = Sprite.new(vp)
		@key_left.bitmap = $cache.icon('misc/key-left')
		@key_left.move(110,370)

		@key_right = Sprite.new(vp)
		@key_right.bitmap = $cache.icon('misc/key-right')
		@key_right.move(530,370)

		#refresh

	end

	def dispose
		$menu.potion_page = @page_idx
		@base.dispose
		@page.dispose
		@turner.dispose
	end

	def update
		super

		case @state

			when :fadeout

				@page.opacity -= 40
				if @page.opacity <= 0
					@state = :flip
				end



			when :flip

				@turn_step += (12 * @turn_dir)
				@turner.bitmap = $cache.menu_book("turn-#{@turn_step/20}")
				@turner.opacity = 255
				if (@turn_dir == 1 && @turn_step >= 119) || (@turn_dir == -1 && @turn_step <= 20)
					@turner.opacity = 0
					@state = :fadein
					@page.bitmap = $cache.menu_book("page-#{@page_idx}")
				end

			when :fadein

	
				@page.opacity += 40
				if @page.opacity >= 255
					@turner.opacity = 0
					@state = :idle
				end

		end

		# Mouse cursor

		if $mouse.x > 420 || $mouse.x < 220
			$mouse.change_cursor('Use')
		else
			$mouse.change_cursor('Default')
		end

		# Check left and right inputs to change pages
		return if @state != :idle
		if @page_idx != 0 && $input.left?
			@page_idx -= 1
			@turn_step = 119
			@turn_dir = -1
			@state = :fadeout
			sfx('page')
		end

		if @page_idx != 4 && $input.right?
			@page_idx += 1
			@turn_step = 20
			@turn_dir = 1
			@state = :fadeout
			sfx('page')
		end

		if $input.click?

			# If to the right
			if @page_idx != 4 && $mouse.x > 420
				@page_idx += 1
				@turn_step = 20
				@turn_dir = 1
				@state = :fadeout
				sfx('page')
			end

			if @page_idx != 0 &&  $mouse.x < 220
				@page_idx -= 1
				@turn_step = 119
				@turn_dir = -1
				@state = :fadeout
				sfx('page')
			end

		end

	end

end