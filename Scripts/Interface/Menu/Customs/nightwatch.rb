#==============================================================================
# ** Mnu_Nightwatch
#==============================================================================

class Mnu_Nightwatch < Mnu_Base

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

		src = ['mouse','cat','rabbit','racoon','squirrel']
		titles = ['Midnight Mouse','Creeping Cat','Racing Rabbit','Rascal Racoon','Militant Squirrel']

		cx = 28
		cy = 126

		(0..$progress.night_rank-1).each{ |i|

			lbl = Label.new(vp)
			lbl.icon = $cache.icon("misc/nw-#{src[i]}")
		    lbl.font = $fonts.list
		    lbl.shadow = $fonts.list_shadow
		    lbl.text = titles[i]
		    lbl.move(cx,cy)
		    self.left.push(lbl)

		    cx = 44
			cy += 28

		    lbl = Label.new(vp)
			lbl.icon = $cache.icon("stats/xp")
		    lbl.font = $fonts.pop_text
		    lbl.text = "Progress: #{$progress.night_xp}%"
		    lbl.move(cx,cy)
		    self.left.push(lbl)

		    cx = 28
			cy += 24

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