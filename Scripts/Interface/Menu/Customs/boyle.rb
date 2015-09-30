#==============================================================================
# ** Mnu_Boyle
#==============================================================================

class Mnu_Boyle < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Status')
		@title.icon($menu.char)
		@subtitle.text = "Gotta catch em"

		@char = $party.get($menu.char)

		remove_menu
		remove_info

		@box = Box.new(vp,300,350)
		@box.skin = $cache.menu_common("skin")
		@box.wallpaper = $cache.menu_wallpaper("diamonds")
		@box.move(15,115)
		self.left.push(@box)

		src = ["wyrmwood",'windshire','wasteland','royal','elvaria','shadow','other']
		names = ["Wyrmwood","Windshire","Wasteland","Royal","Elvaria","Shadow Isles","Ocean and Islands"]
		totals = [30,30,30,30,30,30,30]

		cx = 28
		cy = 123

		[0,1,2,3,4,5,6].each { |i|

			next if !$progress.creatures.has_key?(src[i])

			lbl = Label.new(vp)
			lbl.icon = $cache.icon("misc/zone-#{src[i]}")
		    lbl.font = $fonts.list
		    lbl.shadow = $fonts.list_shadow
		    lbl.text = names[i]
		    lbl.move(cx,cy)
		    self.left.push(lbl)

		    cx = 44
		    cy += 25

		    found = $progress.creatures[src[i]]

		    lbl = Label.new(vp)
			lbl.icon = $cache.icon("stats/creature")
		    lbl.font = $fonts.pop_text
		    if $party.passive_cheekis
		    	lbl.text = "#{found} of #{totals[i]} Caught"
		    else
		    	lbl.text = "#{found} Caught"
		    end
		    lbl.move(cx,cy)
		    self.left.push(lbl)



	    cx = 28
		cy += 22

			}

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