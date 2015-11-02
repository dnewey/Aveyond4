#==============================================================================
# ** Mnu_Progress
#==============================================================================

class Mnu_Progress < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Progress')
		@title.icon($menu.char)
		@subtitle.text = "So much to do"

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
		lbl.icon = $cache.icon("misc/main")
	    lbl.font = $fonts.list
	    lbl.shadow = $fonts.list_shadow
	    lbl.text = "Quests"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cx = 34
	    cy += 29

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("stats/level")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Main Quests: #{$progress.main_quests_complete}"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cx = 34
	    cy += 26

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("stats/level")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Side Quests: #{$progress.side_quests_complete}"
	    lbl.move(cx,cy)
	    self.left.push(lbl)
		
		cx = 28
		cy += 28

		# If boyle creatures started
		if $progress.creatures.values.inject{|sum,x| sum + x } > 0

			lbl = Label.new(vp)
			lbl.icon = $cache.icon("misc/char")
		    lbl.font = $fonts.list
		    lbl.shadow = $fonts.list_shadow
		    lbl.text = "Personal Missions"
		    lbl.move(cx,cy)
		    self.left.push(lbl)

			cx = 34
		    cy += 29

		end

	    # Only show creatures if boyle has caught one
	    if $progress.creatures.values.inject{|sum,x| sum + x } > 0

		    lbl = Label.new(vp)
			lbl.icon = $cache.icon("stats/xp")
		    lbl.font = $fonts.pop_text
		    lbl.text = "Cheekis Found: #{$progress.creatures.values.inject{|sum,x| sum + x }}"
		    lbl.move(cx,cy)
		    self.left.push(lbl)

		    cx = 34
		    cy += 26

		end

		# Potions
		$progress.potions = 0 if $progress.potions == nil # Save fix
		if $progress.potions > 0

		   	lbl = Label.new(vp)
			lbl.icon = $cache.icon("stats/xp")
		    lbl.font = $fonts.pop_text
		    lbl.text = "Potions Brewed: #{$progress.potions}"
		    lbl.move(cx,cy)
		    self.left.push(lbl)

		    cx = 34
		    cy += 26

		end

	    # Nightwatch
	    if $progress.night_xp > 0

	    	titles = ['Midnight Mouse','Creeping Cat','Racing Rabbit','Rascal Racoon','Militant Squirrel']

		    lbl = Label.new(vp)
			lbl.icon = $cache.icon("stats/xp")
		    lbl.font = $fonts.pop_text
		    lbl.text = "Nightwatch Rank: #{titles[$progress.night_rank-1]}"
		    lbl.move(cx,cy)
		    self.left.push(lbl)

		    cx = 34
		    cy += 26

		end

	    # Phye demons
	    if !$progress.demons.empty?

		    lbl = Label.new(vp)
			lbl.icon = $cache.icon("stats/xp")
		    lbl.font = $fonts.pop_text
		    lbl.text = "Demons Dispatched: #{$progress.demons.count}"
		    lbl.move(cx,cy)
		    self.left.push(lbl)
			
			cy += 28

		end

		cx = 28

		lbl = Label.new(vp)
		lbl.icon = $cache.icon("misc/coins")
	    lbl.font = $fonts.list
	    lbl.shadow = $fonts.list_shadow
	    lbl.text = "Extra Activities"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

		cx = 34
	    cy += 29

	    # Shop items
	    if !$progress.store_done.empty?

		    lbl = Label.new(vp)
			lbl.icon = $cache.icon("stats/luk")
		    lbl.font = $fonts.pop_text
		    lbl.text = "Shop Selling: #{$progress.store_done.count}"
		    lbl.move(cx,cy)
		    self.left.push(lbl)

		    cx = 34
		    cy += 26

		end

		# Arena here
		if false

		    lbl = Label.new(vp)
			lbl.icon = $cache.icon("stats/luk")
		    lbl.font = $fonts.pop_text
		    lbl.text = "Arena Battles: 0"
		    lbl.move(cx,cy)
		    self.left.push(lbl)

		    cx = 34
		    cy += 26

		end

	    if false

		    lbl = Label.new(vp)
			lbl.icon = $cache.icon("stats/luk")
		    lbl.font = $fonts.pop_text
		    lbl.text = "Something: 0"
		    lbl.move(cx,cy)
		    self.left.push(lbl)

		end

		@port = Port_Full.new(vp)
		self.right.push(@port)

		open

	end

end