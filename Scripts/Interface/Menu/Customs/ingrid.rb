#==============================================================================
# ** Mnu_Ingrid
#==============================================================================

class Mnu_Ingrid < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Status')
		@title.icon($menu.char)
		@subtitle.text = "The Witching Hour"

		@char = $party.get($menu.char)

		remove_menu
		remove_info

		@box = Box.new(vp,300,350)
		@box.skin = $cache.menu_common("skin")
		@box.wallpaper = $cache.menu_wallpaper("diamonds")
		@box.move(15,115)
		self.left.push(@box)

		spacing = 28

		# Potion making

		cx = 28
		cy = 126

		lbl = Label.new(vp)
		lbl.icon = $cache.icon("misc/potions")
	    lbl.font = $fonts.list
	    lbl.shadow = $fonts.list_shadow
	    lbl.text = "Potion Brewing"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cx = 34
	    cy += 30

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("stats/level")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Recipes Known: #{@char.level}"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cx = 34
	    cy += spacing

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("items/potion-blue")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Potions Made: #{@char.level}"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    # Guild

	    cx = 28
		cy += 32

		lbl = Label.new(vp)
		lbl.icon = $cache.icon("items/witch-hat")
	    lbl.font = $fonts.list
	    lbl.shadow = $fonts.list_shadow
	    lbl.text = "Witch Coven"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cx = 34
	    cy += 30

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("stats/level")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Coven In: Potioneers"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	   	cx = 34
	    cy += spacing

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("stats/level")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Guild Level: #{@char.level}"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    # Attraction

	    cx = 28
		cy += 32

		lbl = Label.new(vp)
		lbl.icon = $cache.icon("misc/attract-get")
	    lbl.font = $fonts.list
	    lbl.shadow = $fonts.list_shadow
	    lbl.text = "Attraction"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cx = 34
	    cy += 30

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("faces/boy")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Boyle: #{@char.level}"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	   	cx = 34
	    cy += spacing

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("faces/hib")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Hi'beru: #{@char.level}"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cx = 34
	    cy += spacing

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("faces/phy")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Phye: #{@char.level}"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

		@port = Port_Full.new(vp)
		self.right.push(@port)

		open

	end

	def update
		
		# Cancel out of grid
		if $input.cancel? || $input.rclick?
			@left.each{ |a| $tweens.clear(a) }
			@right.each{ |a| $tweens.clear(a) }
			@other.each{ |a| $tweens.clear(a) }
			$scene.queue_menu("Char")
			close_now
		end
		
		super
		
	end

end