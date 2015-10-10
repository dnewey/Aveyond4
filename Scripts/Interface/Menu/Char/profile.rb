#==============================================================================
# ** Mnu_Profile
#==============================================================================

class Mnu_Profile < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('Profile')
		@title.icon($menu.char)
		@subtitle.text = "Master of deception"

		@char = $party.get($menu.char)
		profile = $data.profiles[$menu.char]

		remove_menu
		remove_info

		@box = Box.new(vp,350,350)
		@box.skin = $cache.menu_common("skin")
		@box.wallpaper = $cache.menu_wallpaper("diamonds")
		@box.move(15,115)
		self.left.push(@box)

		spacing = 28
		
		data = []
		data.push(["faces/boy","Name: #{profile.name}"])
		data.push(["faces/boy","Home: #{profile.home}"])
		data.push(["faces/boy","Age: #{profile.age}"])
		data.push(["faces/boy","Biography:"])

		cx = 26
		cy = 125

		# Name
		lbl = Label.new(vp)
	    lbl.font = $fonts.list
	    lbl.shadow = $fonts.list_shadow
	    lbl.icon = $cache.icon("faces/#{$menu.char}")
	    lbl.text = "Name: #{profile.name}"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cy += spacing

	    # Age
	    lbl = Label.new(vp)
	    lbl.font = $fonts.list
	    lbl.shadow = $fonts.list_shadow
	    lbl.icon = $cache.icon('misc/cooldown')
	    lbl.text = "Age: #{profile.age}"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cy += spacing

	    # Home
	    lbl = Label.new(vp)
	    lbl.font = $fonts.list
	    lbl.shadow = $fonts.list_shadow
	    lbl.icon = $cache.icon('misc/home')
	    lbl.text = "Home: #{profile.home}"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cy += spacing

	    # Bio
	    lbl = Label.new(vp)
	    lbl.font = $fonts.list
	    lbl.shadow = $fonts.list_shadow
	    lbl.icon = $cache.icon('misc/bio')
	    lbl.text = "Biography"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cy += spacing

	    area = Area.new(vp)
	    area.fixed_width = 310
    	area.font = $fonts.pop_text
    	area.text = profile.bio
    	area.move(cx+4,cy)
    	self.left.push(area)

    	cy += area.height - 2

    	# Hint
	    lbl = Label.new(vp)
	    lbl.font = $fonts.list
	    lbl.shadow = $fonts.list_shadow
	    lbl.icon = $cache.icon('misc/credits')
	    lbl.text = "Tip"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cy += spacing

	    area = Area.new(vp)
	    area.fixed_width = 310
    	area.font = $fonts.pop_text
    	area.text = profile.tip
    	area.move(cx+4,cy)
    	self.left.push(area)

    	cy += area.height - 2

    	# Fact
	    lbl = Label.new(vp)
	    lbl.font = $fonts.list
	    lbl.shadow = $fonts.list_shadow
	    lbl.icon = $cache.icon('misc/fact')
	    lbl.text = "Fun Fact"
	    lbl.move(cx,cy)
	    self.left.push(lbl)

	    cy += spacing

	    area = Area.new(vp)
	    area.fixed_width = 310
    	area.font = $fonts.pop_text
    	area.text = profile.fact
    	area.move(cx+4,cy)
    	self.left.push(area)


		@port = Port_Full.new(vp)
		@port.happy
		self.right.push(@port)

		open

	end

	def update

		if $input.right? || $input.mclick?
			$menu.char = $party.get_next($menu.char)
			$scene.queue_menu("Profile")
			close_soon(0)
		end

		if $input.left?
			$menu.char = $party.get_prev($menu.char)
			$scene.queue_menu("Profile")
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