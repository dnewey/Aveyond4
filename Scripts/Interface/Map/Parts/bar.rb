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
		@quit.press = Proc.new{ open_sub_menu("Quit") }
		@quit.select = Proc.new{ $tweens.clear(@quit); @quit.do(seq(go("oy",-4,100,:qio),go("oy",4,100,:qio))) }
		@quit.deselect = Proc.new{ $tweens.clear(@quit); @quit.oy = 0 }
		add(@quit,cx,4)

		cx += 32

		@journal = Button.new(vp)
		@journal.bitmap = $cache.icon("misc/journal")
		@journal.press = Proc.new{ open_sub_menu("Journal") }
		@journal.select = Proc.new{ $tweens.clear(@journal); @journal.do(seq(go("oy",-4,100,:qio),go("oy",4,100,:qio))) }
		@journal.deselect = Proc.new{ $tweens.clear(@journal); @journal.oy = 0 }
		add(@journal,cx,4)

		cx += 32

		@items = Button.new(vp)
		@items.bitmap = $cache.icon("misc/items")
		@items.press = Proc.new{ open_sub_menu("Items") }
		@items.select = Proc.new{ $tweens.clear(@items); @items.do(seq(go("oy",-4,100,:qio),go("oy",4,100,:qio))) }
		@items.deselect = Proc.new{ $tweens.clear(@items); @items.oy = 0 }
		add(@items,cx,4)

		cx += 32

		@party = Button.new(vp)
		@party.bitmap = $cache.icon("misc/party")
		@party.press = Proc.new{ open_sub_menu("Party") }
		@party.select = Proc.new{ $tweens.clear(@party); @party.do(seq(go("oy",-4,100,:qio),go("oy",4,100,:qio))) }
		@party.deselect = Proc.new{ $tweens.clear(@party); @party.oy = 0 }
		add(@party,cx,4)

		cx += 32

		@settings = Button.new(vp)
		@settings.bitmap = $cache.icon("misc/settings")
		@settings.press = Proc.new{ open_sub_menu("Options") }
		@settings.select = Proc.new{ $tweens.clear(@settings); @settings.do(seq(go("oy",-4,100,:qio),go("oy",4,100,:qio))) }
		@settings.deselect = Proc.new{ $tweens.clear(@settings); @settings.oy = 0 }
		add(@settings,cx,4)

		cx += 32

		@sound = Button.new(vp)
		@sound.bitmap = $cache.icon("misc/sound")
		@quit.press = Proc.new{ log_err("TOGGLE SOUND") }
		@sound.select = Proc.new{ $tweens.clear(@sound); @sound.do(seq(go("oy",-4,100,:qio),go("oy",4,100,:qio))) }
		@sound.deselect = Proc.new{ $tweens.clear(@sound); @sound.oy = 0 }
		add(@sound,cx,4)

		cx += 32

		@save = Button.new(vp)
		@save.bitmap = $cache.icon("misc/save")
		@save.press = Proc.new{ open_sub_menu("Save") }
		@save.select = Proc.new{ $tweens.clear(@save); @save.do(seq(go("oy",-4,100,:qio),go("oy",4,100,:qio))) }
		@save.deselect = Proc.new{ $tweens.clear(@save); @save.oy = 0 }
		add(@save,cx,4)

		@hp_bars = []
		@mp_bars = []

		# Chars
		i = 0
		$party.active.each{ |m|

			char = $party.get(m)

			# Add icon
			icon = Button.new(vp)
			icon.bitmap = $cache.icon("faces/#{m}")
			icon.press = Proc.new{ 
				$tweens.clear(icon); icon.do(seq(go("oy",-4,100,:qio),go("oy",4,100,:qio),call("open_char_menu('#{m}')")))				 
			}
			icon.select = Proc.new{ $tweens.clear(icon); icon.do(seq(go("oy",-4,100,:qio),go("oy",4,100,:qio))) }
			icon.deselect = Proc.new{ $tweens.clear(icon); icon.oy = 0 }
			add(icon,238+i*98,4)

			mp_bar = Bar.new(vp,66,6)
			mp_bar.opacity = 200
			mp_bar.for(:mp)
			add(mp_bar,27+238+i*98,9)
			@mp_bars.push(mp_bar)

			case m
				when 'boy', 'ing', 'hib', 'phy'
					mp_bar.for(m)
				else
					mp_bar.hide
			end

			hp_bar = Bar.new(vp,66,8)
			hp_bar.opacity = 200
			hp_bar.for(:hp)
			add(hp_bar,27+238+i*98,17)
			@hp_bars.push(hp_bar)

			i += 1

		}

		move(0,480-32)

	end

	def dispose
		# Dispose all in spritegroup
	end

	def update
		super()

		# Update the bars
		$party.active.each_index{ |i|
			@hp_bars[i].value = $party.get($party.active[i]).hp_percent
			@mp_bars[i].value = $party.get($party.active[i]).mp_percent
		}

		(@mp_bars+@hp_bars).each{ |b| b.update }

	end

end