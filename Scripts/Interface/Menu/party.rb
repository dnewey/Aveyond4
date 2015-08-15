
class Mnu_Party < Mnu_Base

	def initialize(vp)
		super(vp)

		@title.change('party')
		@subtitle.text = "Change up your party members"

		remove_menu
		remove_info

		@first = nil

		@active = Sprite.new(vp)
		@active.bitmap = $cache.menu_tab('active')
		@active.move(130,110)
		@left.push(@active)

		@reserve = Sprite.new(vp)
		@reserve.bitmap = $cache.menu_tab('reserve')
		@reserve.move(436,110)
		@right.push(@reserve)

		@reserve = Sprite.new(vp)
		@reserve.bitmap = $cache.menu_common('switch')
		@reserve.move(293,285)
		@right.push(@reserve)
		
		@grid = Ui_Grid.new(vp)
		@other.push(@grid)
		setup_grid


		open

		@grid.all.each{ |a|
			a.opacity = 0
			a.do(go("opacity",255,200,:qio))
		}

	end

	def setup_grid


		
		@grid.move(30,138)

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

		@grid.cx = 344
		@grid.cy = 138

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

	def dispose
		@grid.dispose
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

	def close
		super

		@grid.hide_glow
		@grid.all.each{ |a|
			a.do(go("opacity",-255,200,:qio))
		}

	end

end