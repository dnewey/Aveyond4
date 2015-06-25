#==============================================================================
# Ui_Bar
#==============================================================================

class Ui_Bar < SpriteGroup

	def initialize(vp)
		super()

		@base = Sprite.new(vp)
		@base.bitmap = Bitmap.new(640,32)
		@base.bitmap.fill_rand
		add(@base)

		# Buttons
		cx = 4

		@quit = Button.new(vp)
		@quit.bitmap = $cache.icon("misc/quit")
		@quit.press = Proc.new{ log_info("QUIT BUTTON") }
		add(@quit,cx,4)

		cx += 24 + 4

		@char = Button.new(vp)
		@char.bitmap = $cache.icon("misc/char")
		add(@char,cx,4)

		cx += 24 + 4

		@save = Button.new(vp)
		@save.bitmap = $cache.icon("misc/keys")
		add(@save,cx,4)

		cx += 24 + 4

		@journal = Button.new(vp)
		@journal.bitmap = $cache.icon("misc/journal")
		add(@journal,cx,4)

		cx += 24 + 4

		@items = Button.new(vp)
		@items.bitmap = $cache.icon("misc/coins")
		add(@items,cx,4)

		cx += 24 + 4

		@settings = Button.new(vp)
		@settings.bitmap = $cache.icon("misc/settings")
		add(@settings,cx,4)

		cx += 24 + 4

		@help = Button.new(vp)
		@help.bitmap = $cache.icon("misc/unknown")
		add(@help,cx,4)

		move(0,480-32)

	end

	def dispose
		@base.dispose
		@quit.dispose
		@char.dispose
		@save.dispose
		@journal.dispose
		@items.dispose
		@settings.dispose
		@help.dispose
	end

	def update
		super()
	end

end