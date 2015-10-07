#==============================================================================
# ** Mnu_Phye
#==============================================================================

class Mnu_Phye < Mnu_Base

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

		src = ['arinya','kubaba','baal','crystalis','icetooth']
		titles = ['Arinya','Kubaba','Baal the Brute','Crystalis','Icetooth']

		cx = 28
		cy = 128

		(0..4).each{ |i|

			lbl = Label.new(vp)
			lbl.icon = $cache.icon("misc/phy-#{src[i]}")
		    lbl.font = $fonts.list
		    lbl.shadow = $fonts.list_shadow
		    lbl.text = titles[i]
		    lbl.move(cx,cy)
		    self.left.push(lbl)

		    cx = 44
			cy += 28

		    lbl = Label.new(vp)
			lbl.font = $fonts.pop_text
		    if !$progress.demons.include?(src[i])
		    	lbl.icon = $cache.icon("stats/phy-not")
		    	lbl.text = "Status: At Large"
		    else
		    	lbl.icon = $cache.icon("stats/phy-done")
				lbl.text = "Status: Decimated"
		    end

		    lbl.move(cx,cy)
		    self.left.push(lbl)

		    cx = 28
			cy += 26

		}

		# The swords!
		swords = Sprite.new(vp)
		swords.bitmap = $cache.menu_common("phy-sword-#{$progress.demons.count}")
		swords.move(45,415)
		self.left.push(swords)


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