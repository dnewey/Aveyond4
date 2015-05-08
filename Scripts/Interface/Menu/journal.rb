#==============================================================================
# ** Mnu_Items
#==============================================================================

class Mnu_Journal

	attr_accessor :closed

	def initialize(vp)

		@closed = false

		@title = Page_Title.new(vp)
		@title.change('journal')

		@tabs = Tabs.new(vp)
		@tabs.push("all")
		@tabs.push("main")
		@tabs.push("side")
		@tabs.move(120,78)

		@menu = List_Common.new(vp)
		@menu.list.select = Proc.new{ |option| self.select(option) }
		@menu.list.cancel = Proc.new{ |option| self.cancel(option) }
		@menu.list.change = Proc.new{ |option| self.change(option) }

		@menu.list.type = :quest

		data = []
		data.push('ch2-to-ferry')
		data.push('ch2-to-briar')
		data.push('ch2-return-ferry')

		@menu.list.setup(data)

		@info = Info_Box.new(vp)

		# Right side journal
		@window = Box.new(vp,300,360)
    	@window.skin = $cache.menu_common("skin-dry")
    	@window.wallpaper = $cache.menu_wallpaper("journal_page_line")
    	#@window.color = Color.new(47,45,41)
    	@window.move(320,110)

    	# Quest Name
    	@title = Label.new(vp)
    	@title.fixed_width = 250
    	@title.font = $fonts.page_ttl
    	@title.text = "Board the Ferry"
    	@title.move(340,127)

    	@desc = Area.new(vp)
    	@desc.fixed_width =  400
    	@desc.font = $fonts.page_text
    	@desc.text = "Rescue them guys in the briar woods"
    	@desc.move(340,180)

    	# Requirements


    	# Zone
    	@zone = Sprite.new(vp)
    	@zone.bitmap = $cache.menu("Zones/whisper")
    	@zone.move(340,352)



	end

	def dispose
		@menu.dispose
	end

	def update
		@tabs.update
		@menu.update
		@info.update
		@title.update
	end

	def close
		@closed = true
		@menu.hide
		@title.hide
		@info.hide
		@window.hide
		@tabs.hide
		@desc.hide
		@zone.hide
	end

	def open
		@menu.show
		@title.show
		@info.show
		@menu.list.refresh
	end

	def change(option)
		@info.title.text = option
	end

	def select(option)	
		
	end

	def cancel(option)
		$scene.close_sub
	end

end