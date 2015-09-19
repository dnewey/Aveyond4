

def shop_choice

	case $menu.grid_action

		when 'Buy'

			# Have money, buy it
			item(gev(me).name,'b')


		when 'Info'

			text("36: That's a covey balm")


		when 'Cancel'

	end


end