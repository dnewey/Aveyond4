#==============================================================================
# Ui_Bar
#==============================================================================

class Ui_Bar < SpriteGroup

	def initialize(vp)
		super()

		@base = Sprite.new(vp)
		@base.bitmap = $cache.menu_common("bottom-bar")
		#@base.bitmap.fill_rand
		add(@base)

		# Buttons
		cx = 6

		@quit = Button.new(vp)
		@quit.bitmap = $cache.icon("misc/quit")
		@quit.press = Proc.new{ open_main_menu }
		@quit.select = Proc.new{ $tweens.clear(@quit); @quit.do(seq(go("oy",-4,100,:qio),go("oy",4,100,:qio))) }
		@quit.deselect = Proc.new{ $tweens.clear(@quit); @quit.oy = 0 }
		add(@quit,cx,4)

		cx += 32

		@journal = Button.new(vp)
		@journal.bitmap = $cache.icon("misc/journal")
		@journal.select = Proc.new{ $tweens.clear(@journal); @journal.do(seq(go("oy",-4,100,:qio),go("oy",4,100,:qio))) }
		@journal.deselect = Proc.new{ $tweens.clear(@journal); @journal.oy = 0 }
		add(@journal,cx,4)

		cx += 32

		@items = Button.new(vp)
		@items.bitmap = $cache.icon("misc/items")
		@items.select = Proc.new{ $tweens.clear(@items); @items.do(seq(go("oy",-4,100,:qio),go("oy",4,100,:qio))) }
		@items.deselect = Proc.new{ $tweens.clear(@items); @items.oy = 0 }
		add(@items,cx,4)

		cx += 32

		@party = Button.new(vp)
		@party.bitmap = $cache.icon("misc/party")
		@party.select = Proc.new{ $tweens.clear(@party); @party.do(seq(go("oy",-4,100,:qio),go("oy",4,100,:qio))) }
		@party.deselect = Proc.new{ $tweens.clear(@party); @party.oy = 0 }
		add(@party,cx,4)

		cx += 32

		@settings = Button.new(vp)
		@settings.bitmap = $cache.icon("misc/settings")
		@settings.select = Proc.new{ $tweens.clear(@settings); @settings.do(seq(go("oy",-4,100,:qio),go("oy",4,100,:qio))) }
		@settings.deselect = Proc.new{ $tweens.clear(@settings); @settings.oy = 0 }
		add(@settings,cx,4)

		cx += 32

		@sound = Button.new(vp)
		@sound.bitmap = $cache.icon("misc/sound")
		@sound.select = Proc.new{ $tweens.clear(@sound); @sound.do(seq(go("oy",-4,100,:qio),go("oy",4,100,:qio))) }
		@sound.deselect = Proc.new{ $tweens.clear(@sound); @sound.oy = 0 }
		add(@sound,cx,4)

		cx += 32

		@save = Button.new(vp)
		@save.bitmap = $cache.icon("misc/save")
		@save.select = Proc.new{ $tweens.clear(@save); @save.do(seq(go("oy",-4,100,:qio),go("oy",4,100,:qio))) }
		@save.deselect = Proc.new{ $tweens.clear(@save); @save.oy = 0 }
		add(@save,cx,4)

		# Chars
		i = 0
		$party.active.each{ |m|

			char = $party.get(m)

			# Add icon
			icon = Sprite.new(vp)
			icon.bitmap = $cache.icon("faces/#{m}")
			add(icon,238+i*98,4)

			hp_bar = Bar.new(vp,66,8)
			hp_bar.opacity = 200
			add(hp_bar,27+238+i*98,8)

			mp_bar = Bar.new(vp,66,8)
			mp_bar.opacity = 200
			add(mp_bar,27+238+i*98,18)

			i += 1

		}

		move(0,480-32)

	end

	def dispose
		# Dispose all in spritegroup
	end

	def update
		super()
	end

end