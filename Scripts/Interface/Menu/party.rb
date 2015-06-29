
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
		@left.push(@active)

		@reserve = Sprite.new(vp)
		@reserve.bitmap = $cache.menu_tab('all')
		@reserve.move(450,105)
		@right.push(@reserve)
		
		@grid = Ui_Grid.new(vp)
		@other.push(@grid)
		setup_grid

		@info.dispose
		self.left.delete(@info)

	end

	def setup_grid
		
		@grid.move(15,128)

		@grid.add_party_mem('a.0',$party.active[0])
		if $party.active.count > 1
			@grid.add_party_mem('a.1',$party.active[1])
		else
			@grid.add_party_mem('a.1',nil)
		end
		if $party.active.count > 2
			@grid.add_party_mem('a.2',$party.active[2])
		else
			@grid.add_party_mem('a.2',nil)
		end
		if $party.active.count > 3
			@grid.add_party_mem('a.3',$party.active[3])
		else
			@grid.add_party_mem('a.3',nil)
		end

		@grid.cx = 324
		@grid.cy = 128

		@grid.add_party_mem('r.0',$party.reserve[0])
		if $party.reserve.count > 1
			@grid.add_party_mem('r.1',$party.reserve[1])
		else
			@grid.add_party_mem('r.1',nil)
		end
		if $party.reserve.count > 2
			@grid.add_party_mem('r.2',$party.reserve[2])
		else
			@grid.add_party_mem('r.2',nil)
		end
		if $party.reserve.count > 3
			@grid.add_party_mem('r.3',$party.reserve[3])
		else
			@grid.add_party_mem('r.3',nil)
		end

	end

	def update
		super

		@grid.update

		# Get chosen grid option
		if $input.action? || $input.click?
			choose(@grid.get_chosen)
		end

	end

	def choose(option)
		if @first == nil
			@first = option
			@grid.get_box(option).wallpaper = $cache.menu_wallpaper('blue')
		else
			$party.swap(@first,option)
			@first = nil			
			@grid.clear
			setup_grid
			@grid.choose(option)
		end
	end

	def change(option)

		@page.clear


	end

	def select(option)	
		
	end

end