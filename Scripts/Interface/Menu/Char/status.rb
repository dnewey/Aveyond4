#==============================================================================
# ** Mnu_Status
#==============================================================================

class Mnu_Status < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Status')
		@title.icon($menu.char)
		@subtitle.text = "Master of deception"

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
	    lbl.text = "Overall"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cx = 34
	    cy += 30

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("stats/level")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Level: #{@char.level}"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cx = 34
	    cy += 26

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("stats/xp")
	    lbl.font = $fonts.pop_text
	    lbl.text = "XP: #{@char.xp} of #{@char.next_exp}"
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

	   	cy += 26

	   	# Only show mana for mana users
	   	if ['boy','ing','hib','phy'].include?(@char.id)
		   	
		   	lbl = Label.new(vp)
		   	if @char.id == 'boy'
				lbl.icon = $cache.icon("stats/darkness")
				type = "DP"
			elsif @char.id == 'ing' || @char.id == 'hib'
				lbl.icon = $cache.icon("stats/rage")
				type = "RP"
			else
				lbl.icon = $cache.icon("stats/mana")
				type = "MP"
			end
		    lbl.font = $fonts.pop_text
		    lbl.text = "Max #{type}: #{@char.maxmp}  (#{@char.stat_pure('mp')} + #{@char.stat_gear('mp')})"
		    lbl.move(cx,cy)
		    self.left.push(lbl)

		   	cy += 26

	    end 

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("stats/str")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Strength: #{@char.str}  (#{@char.stat_pure('str')} + #{@char.stat_gear('str')})"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	   	cy += 26

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("stats/def")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Defense: #{@char.def}  (#{@char.stat_pure('def')} + #{@char.stat_gear('def')})"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cx = 28
		cy += 28

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("misc/secondary")
	    lbl.font = $fonts.list
	    lbl.shadow = $fonts.list_shadow
	    lbl.text = "Secondary Stats"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cx = 34
	    cy += 30

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("stats/luck")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Luck: #{@char.luk}%"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cy += 26

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("stats/eva")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Evasion: #{@char.eva}%"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cy += 26

	    lbl = Label.new(vp)
		lbl.icon = $cache.icon("stats/res")
	    lbl.font = $fonts.pop_text
	    lbl.text = "Resist: #{@char.res}%"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

		@port = Port_Full.new(vp)
		self.right.push(@port)

		open

	end

	def update

		if $input.right? || $input.mclick?
			$menu.char = $party.get_next($menu.char)
			$scene.queue_menu("Status")
			close_soon(0)
		end

		if $input.left?
			$menu.char = $party.get_prev($menu.char)
			$scene.queue_menu("Status")
			close_soon(0)
		end
		
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