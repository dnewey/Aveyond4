

def shop_choice

	case $menu.grid_action

		when 'Buy'

			# Have money, buy it
			data = $data.items[gev(me).name]
			if $party.gold >= data.price
				item(gev(me).name,'b')
				state(me,'sold')
				ungold(data.price)
				delete(me)
			else
				text("#{$shopkeep}: You can't afford that.")				
			end

		when 'Info'

			text("#{$shopkeep}: That's a covey balm.")

		when 'Cancel'

	end


end

def setup_item_shop

	$menu.shop_init
	stock = []

	case $map.zone.id

		when '@windshire'	
			stock.push('covey')
			stock.push('cheese')
			stock.push('bread')
			stock.push('mutton')

		when '@tor'	
			stock.push('covey')
			stock.push('cheese')
			stock.push('bread')
			stock.push('mutton')

		when '@royal-town'	
			stock.push('covey')
			stock.push('cheese')
			stock.push('bread')
			stock.push('mutton')

		when '@weeville'	
			stock.push('covey')
			stock.push('cheese')
			stock.push('bread')
			stock.push('mutton')

		when '@elf-town'	
			stock.push('covey')
			stock.push('cheese')
			stock.push('bread')
			stock.push('mutton')

		when '@dwarf-town'	
			stock.push('covey')
			stock.push('cheese')
			stock.push('bread')
			stock.push('mutton')

	end

	stock.each{ |s| $menu.shop_add(s) }
	open_shop_buy

end

def setup_smith_shop

	$menu.shop_init
	stock = []

	case $map.zone.id

		when '@windshire'	
			stock.push('mid-arm-shire')
			stock.push('mys-claw-shire')

		when '@tor'	
			stock.push('mid-arm-tor')
			stock.push('heavy-arm-tor')
			stock.push('helm-tor')
			stock.push('rob-shield-tor')

		when '@royal-town'	
			stock.push('mid-arm-royal')
			stock.push('heavy-arm-royal')
			stock.push('rob-hammer-royal')

		when '@royal-crusade'	
			stock.push('helm-royal')
			stock.push('rob-shield-royal')

		when '@elf-town'	
			stock.push('mid-arm-elves')
			stock.push('heavy-arm-elves')
			stock.push('rob-shield-elves')

		when '@dwarf-town'	
			stock.push('mid-arm-shire')

	end

	stock.each{ |s| $menu.shop_add(s) }
	open_shop_smith

end

def setup_magic_shop

	$menu.shop_init
	stock = []

	case $map.zone.id

		when '@windshire'	
			stock.push('light-arm-shire')
			stock.push('ing-athame-shire')

		when '@tor'	
			stock.push('light-arm-tor')
			stock.push('ing-wand-tor')

		when '@royal-town'	
			stock.push('light-arm-royal')
			stock.push('ing-wand-royal')
			stock.push('mys-claw-royal')

		when '@weeville'	
			stock.push('light-arm-wee')
			stock.push('ing-athame-wee')

		when '@elf-town'	
			stock.push('light-arm-elves')

		when '@dwarf-town'	
			stock.push('light-arm-dwarves')

	end

	stock.each{ |s| $menu.shop_add(s) }
	open_shop_magic

end

def setup_chester_shop

	$menu.shop_init
	stock = []

	boy = $party.get('boy')

	# Based on $progress.chester_level



	# Skills to add at level five - DEMONS
	if $progress.chester_level >= 5
		
		stock.push('ug-mana-5')
		stock.push('ug-staff-7')
		stock.push('ug-passive-scare')
	end

	# Skills to add at level 4 - DWARVIES
	if $progress.chester_level >= 4
		stock.push('ug-mana-4')
		stock.push('staff-4')
		stock.push('ug-staff-6')
		stock.push('ug-passive-cheeki')
		stock.push('ug-magic-minion')
		stock.push('triumph-2')
	end

	# Skills to add at level 3 - ELVES
	if $progress.chester_level >= 3
		stock.push('levitate')
		stock.push('flames-3')
		stock.push('ug-mana-3')
		stock.push('ug-staff-5')
		stock.push('ug-passive-shop')
	end

	# Skills to add at level 2 - ROYAL
	if $progress.chester_level >= 2
		stock.push('sacrifice')
		stock.push('contempt-3')
		stock.push('ug-mana-2')
		stock.push('staff-3')
		stock.push('ug-staff-3')
		stock.push('ug-staff-4')
	end

	# Skills to add at level 1 - TOR
	if $progress.chester_level >= 1
		stock.push('triumph')
		stock.push('flames-2')
		stock.push('ug-mana-1')
		stock.push('ug-staff-2')
	end

	# Skills to add ALWAYS - WINSHIRE
	if $progress.chester_level >= 0
		stock.push('empower')
		stock.push('contempt-2')
		stock.push('staff-2')
		stock.push('ug-staff-1')
	end
	
	# Don't add if have
	stock.delete_if{ |s| boy.has_skill?(s) }

	# Don't include multiple of the same types, only use lowest

	# Add skills to shop
	stock.each{ |s| $menu.shop_add(s) }
	open_shop_chester

end

def buy_chester_skill(skill)

	boy = $party.get('boy')

	case skill

		# New skills

		when 'sacrifice','empower','triumph'
			boy.learn(skill)

		# Skill upgrades

		when 'contempt-2','contempt-3'
			boy.replace_skill('contempt',skill)

		when 'flames-2','flames-3'
			boy.replace_skill('flames',skill)

		when 'staff-2','staff-3','staff-4','staff-5','staff-6'
			boy.replace_skill('staff',skill)	

		when 'triumph-2'
			boy.replace_skill('triumph',skill)		


		# Staff upgrades

		when 'ug-staff-1','ug-staff-2','ug-staff-3','ug-staff-4','ug-staff-5','ug-staff-6','ug-staff-7'

			# Replace boy equip with new
			eq = skill.sub('ug','boy')
			boy.force_equip('staff',eq)


		# Stat upgrades

		when 'ug-mana-1'
			boy.grant_stat('mp',10)
		when 'ug-mana-2'
			boy.grant_stat('mp',10)
		when 'ug-mana-3'
			boy.grant_stat('mp',10)
		when 'ug-mana-4'
			boy.grant_stat('mp',10)
		when 'ug-mana-5'
			boy.grant_stat('mp',10)


		# Passives
		when 'ug-passive-shop'
			$party.passive_shop = true

		when 'ug-passive-cheeki'
			$party.passive_cheekis = true

		when 'ug-passive-scare'
			$party.passive_scare = true


	end

end