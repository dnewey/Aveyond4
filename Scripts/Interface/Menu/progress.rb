#==============================================================================
# ** Mnu_Progress
#==============================================================================

class Mnu_Progress < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Progress')
		@title.icon($menu.char)
		@subtitle.text = "1 MILLION PERCENT!"

		@char = $party.get($menu.char)

		remove_menu
		remove_info

		@box = Box.new(vp,300,350)
		@box.skin = $cache.menu_common("skin")
		@box.wallpaper = $cache.menu_wallpaper("diamonds")
		@box.move(15,115)
		self.left.push(@box)

		cx = 28
		cy = 124

		lbl = Label.new(vp)
		lbl.icon = $cache.icon("misc/level")
	    lbl.font = $fonts.list
	    lbl.shadow = $fonts.list_shadow
	    lbl.text = "Quests"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cx = 34
	    cy += 30

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("stats/level")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Main Quests: #{$progress.complete.count}"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cx = 34
	    cy += 26

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("stats/xp")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Side Quests: 45/50"
	    lbl.move(cx,cy)
	    self.left.push(lbl)
		
		cx = 28
		cy += 28

		lbl = Label.new(vp)
		lbl.icon = $cache.icon("misc/primary")
	    lbl.font = $fonts.list
	    lbl.shadow = $fonts.list_shadow
	    lbl.text = "Primary Stats"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cx = 34
	    cy += 30

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("stats/heal")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Max HP: #{@char.maxhp}  (#{@char.stat_pure('hp')} + #{@char.stat_gear('hp')})"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

		@port = Port_Full.new(vp)
		self.right.push(@port)

		open

	end

end