
class Mnu_Party < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('party')
		@subtitle.text = "Change up your party members"

		@menu.hide
		@menu.list.active = false

		@first = nil

		@active = Sprite.new(vp)
		@active.bitmap = $cache.menu_tab('all')
		@active.move(140,105)

		@reserve = Sprite.new(vp)
		@reserve.bitmap = $cache.menu_tab('all')
		@reserve.move(450,105)
		
		@grid = Ui_Grid.new(vp)
		@grid.move(15,128)

		$party.active.each{ |m|
			@grid.add_party_mem(m)
		}
		@grid.add_party_mem(nil) if $party.active.count < 4
		@grid.add_party_mem(nil) if $party.active.count < 3
		@grid.add_party_mem(nil) if $party.active.count < 2
		@grid.cx = 324
		@grid.cy = 128
		$party.reserve.each{ |m|
			@grid.add_party_mem(m)
		}
		@grid.add_party_mem(nil) if $party.reserve.count < 4
		@grid.add_party_mem(nil) if $party.reserve.count < 3
		@grid.add_party_mem(nil) if $party.reserve.count < 3

	end

	def update
		super

		@grid.update

		# Get chosen grid option
		if $input.action?
			choose(@grid.get_chosen)
		end

	end

	def choose(option)
		if @first == nil
			@first = option
			@grid.get_box(option).wallpaper = $cache.menu_wallpaper('blue')
		else

		end
	end

	def change(option)

		@page.clear


	end

	def select(option)	
		
	end

end