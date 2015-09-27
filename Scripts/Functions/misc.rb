
def arch_investigate

	# Check the item, do the flag
	case $menu.chosen

		when 'dig-nothing'
			flag("arch-nothing")

		when 'dig-vhs'
			flag("arch-vhs")

		when 'dig-shop'
			flag("arch-shop")

		when 'dig-quest'
			flag("arch-quest")

		when 'dig-attract'
			flag("arch-attract")

		else
			flag("arch-void")

	end

	unitem($menu.chosen)
	$menu.chosen = nil

end

def gogogo

	log_ev("Debug function GO!")

	log_sys("Refreshing stat mods")
	$party.all_battlers.each{ |b| b.refresh_stat_mods }

end