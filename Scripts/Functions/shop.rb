

def shop_choice

	case $menu.grid_action

		when 'Buy'

			# Have money, buy it
			data = $data.items[gev(me).name]
			if $party.gold >= data.price
				item(gev(me).name,'b')
				state(me,'sold')
				state(me,'on')
				ungold(data.price)
				erase me
			else
				text("#{$shopkeep}: You can't afford that.")				
			end

		when 'Info'

			case gev(me).name

			# Windshire

			when 'level-egg'
				text("#{$shopkeep}: Eggs contain the essence of life.")

			when 'mutton-bag'
				text("#{$shopkeep}: They're fine, I just couldn't finish them all. They're not THAT old.")

			when 'p-kit'
				text("#{$shopkeep}: Use that to start over if you make a mistake with a potion. Personally, I feel that any potion is a mistake.")

			when 'acc-ghost'
				text("#{$shopkeep}: There's something spooky about that thing.")

			when 'cheeki'
				text("#{$shopkeep}: I found it creeping around. Probably worth 500 gold.")

			when 'junk-bandana-blue'
				text("#{$shopkeep}: That washed up on the shore facing Whisper Woods.")

				#Wyrmwood

			when 'soda-ash'
					text("#{$shopkeep}: That's used in potion making, isn't it?")

			when 'haunch'
					text("#{$shopkeep}: I have a haunch you'd enjoy that.")

			when 'covey'
					text("#{$shopkeep}: I don't use mana.")

			when 'vamp-teeth'
					text("#{$shopkeep}: If you want them, you should get them before Vic Venom wakes up.")

			# Goblin Cave

			when 'doll-vamp'
					text("#{$shopkeep}: People trade and collect these types of things.")

			when 'acc-frog-boots'
					text("#{$shopkeep}: Be careful with that.")

			#Tor

			when 'super-balm'
					text("#{$shopkeep}: I think I've been trying to sell that to the wrong crowd. Maybe you'd have more luck.")

			when 'spider-eyes'
					text("#{$shopkeep}: Witches sometimes buy this sort of stuff.")

			when 'spell-zit'
					text("#{$shopkeep}: I won that in a game of two-card flip.")

			# Royal Town Outdoor

			when 'helm-royal'
				text("#{$shopkeep}: A paladin gave it to me.")

			when 'mutton'
				text("#{$shopkeep}: Straight from Windshire.")

			when 'tinctura'
				text("#{$shopkeep}: That is a good item! Well worth it!")

			when 'pine-drink'
				text("#{$shopkeep}: That'll give you a real boost.")

			when 'grape-drink'
				text("#{$shopkeep}: That'll give you a real boost.")

			when 'apple-drink'
				text("#{$shopkeep}: That'll give you a real boost.")

			# Fruit Shop

			when 'fruit-a'
				text("#{$shopkeep}: I eat five of those a day.")

			when 'fruit-b'
				text("#{$shopkeep}: Remove the skin before eating that.")

			when 'fruit-c'
				text("#{$shopkeep}: Remove the skin before eating that.")

			when 'fruit-d'
				text("#{$shopkeep}: Remove the skin before eating that.")

			# Crete Street

			when 'mineral-man'
				text("#{$shopkeep}: Those things grow into the weirdest shapes.")

			when 'juniper'
				text("#{$shopkeep}: That's a very ^mysterious item that will sell out soon.")

			when 'magic-scroll-summon'
				text("#{$shopkeep}: Don't be using that in town, the guards will come after me.")

			when 'brightsword-potion'
				text("#{$shopkeep}: I was once bitten by a drakefang, very painful.")

			# Royal Town Indoor

			when 'recipe-blabber'
				text("#{$shopkeep}: It's all gibberish to me.")

			when 'fan'
				text("#{$shopkeep}: Keep yourself cool and look cool doing it.")

			when 'spell-pig'
				text("#{$shopkeep}: I tried to master the skill myself but I failed.")

			when 'acc-snake-boots'
				text("#{$shopkeep}: Be careful when you wear that, they can see you.")

			# Weeville

			when 'god-food'
				text("#{$shopkeep}: The Dark God just loves this stuff.")			

			when 'tonic'
				text("#{$shopkeep}: The recipe has been handed down through generations.")			

			when 'spell-pie'
				text("#{$shopkeep}: I don't accept refunds if you are unable to use the spell.")			

			# Delamere

			when 'book-hib-help'
				text("#{$shopkeep}: I don't care for reading, too boring.")			

			when 'wine'
				text("#{$shopkeep}: Tether your steed for the eveing and indulge.")			

			when 'spell-mud'
				text("#{$shopkeep}: I recommended this to only the best witches.")			

			when 'elf-cloth'
				text("#{$shopkeep}: It's so soft. Feel how soft it is.")			

			# Dwarf Town

			when 'secret-recipe'
				text("#{$shopkeep}: Shhh, that's only for my most special customers.")			

			when 'hib-book-heal'
				text("#{$shopkeep}: That one of those heebie-jeebie books.")			

			when 'acc-bat-boots'
				text("#{$shopkeep}: It doesn't take echolocation to see this is a good deal.")			

			when 'crab-hammer'
				text("#{$shopkeep}: A might hammer indeed, use it wisely.")			

			when 'recipe-calming'
				text("#{$shopkeep}: Get your cauldron ready, this is a good one.")			

			end

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
			stock.push('haunch')
			stock.push('mutton')
			stock.push('pepper')
			stock.push('cassia')

		when '@wyrmwood'	
			stock.push('covey')
			stock.push('gingerbread')
			stock.push('toffee-apple')
			stock.push('cheese')
			stock.push('haunch')
			stock.push('cassia')
			stock.push('pepper')			

		when '@tor'	
			stock.push('covey')
			stock.push('cheese')
			stock.push('bread')
			stock.push('haunch')
			stock.push('kurry')
			stock.push('cassia')
			stock.push('pepper')

		when '@royal-town'	
			stock.push('covey')
			stock.push('cheese')
			stock.push('bread')
			stock.push('cheese-round')
			stock.push('haunch')
			stock.push('cassia')
			stock.push('pepper')

		when '@weeville'	
			stock.push('fruit-c')
			stock.push('covey')
			stock.push('cheese')
			stock.push('bread')
			stock.push('haunch')
			stock.push('cassia')
			stock.push('pepper')

		when '@elf-town'	
			stock.push('covey')
			stock.push('cheese')
			stock.push('bread')
			stock.push('haunch')
			stock.push('cassia')
			stock.push('elf-bread')
			stock.push('pepper')

		when '@dwarf-town'	
			stock.push('covey')
			stock.push('cheese')
			stock.push('bread')
			stock.push('haunch')
			stock.push('cassia')
			stock.push('sausage')
			stock.push('pepper')

		when '@ravwyn'
			stock.push('covey')
			stock.push('cheese')
			stock.push('bread')
			stock.push('haunch')
			stock.push('cassia')
			stock.push('biscuit')
			stock.push('pepper')

	end

	stock.each{ |s| $menu.shop_add(s) }
	open_shop_buy

end

def setup_special_shop(type)

	$menu.shop_init
	stock = []

	case type

		when 'fruit'	
			stock.push('fruit-a')
			stock.push('fruit-b')
			stock.push('fruit-c')
			stock.push('fruit-d')
			stock.push('fruit-e')

		when 'grape'	
			stock.push('grape-drink')
			stock.push('pine-drink')
			stock.push('apple-drink')

		when 'preserves'	
			stock.push('lemon')
			stock.push('gingerbread')
			stock.push('jam')
			stock.push('jam-2')

		when 'pastry'	
			stock.push('fruit-a')

		when 'ingredients'	
			stock.push('fruit-a')

		when 'keys'	
			stock.push('game-key-1')
			stock.push('game-key-2')
			stock.push('game-key-3')
			stock.push('game-key-4')
			stock.push('game-key-5')
			stock.push('game-key-6')
			stock.push('game-key-7')
			stock.push('game-key-8')
			stock.push('game-key-9')

		when 'helms'	
			stock.push('helm-ultimate')

		when 'diamond'	
			stock.push('heavy-arm-ultimate')

		when 'leather'	
			stock.push('mid-arm-ultimate')

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
			stock.push('mid-arm-shire-a')
			stock.push('mid-arm-shire-e')
			stock.push('mys-claw-shire')

		when '@tor'	
			stock.push('mid-arm-tor')
			stock.push('heavy-arm-tor')
			stock.push('helm-tor')
			stock.push('rob-shield-tor')

		when '@tor'	
			stock.push('boy-arm-briar')
			stock.push('acc-arena')

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
			stock.push('rob-hammer-elves')
			stock.push('helm-elves')

		when '@dwarf-town'	
			stock.push('mid-arm-dwarf')
			stock.push('helm-dwarf')
			stock.push('heavy-arm-dwarf')
			stock.push('rob-shield-dwarf')

		when '@ravwyn'	
			stock.push('mid-arm-shadow')
			stock.push('heavy-arm-shadow')
			stock.push('helm-shadow')

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
			stock.push('light-arm-little')
			stock.push('ing-athame-little')

		when '@elf-town'	
			stock.push('light-arm-elves')
			stock.push('ing-wand-elves')
			stock.push('mys-claw-elves')
			stock.push('hib-charm-elf')

		when '@dwarf-town'	
			stock.push('light-arm-dwarf')
			stock.push('ing-athame-dwarf')
			stock.push('mys-claw-dwarf')
			stock.push('hib-charm-dwarf')

		when '@ravwyn'	
			stock.push('light-arm-shadow')
			stock.push('hib-charm-shadow')

		when '@wind-tower'	
			stock.push('light-arm-ultimate')

	end

	stock.each{ |s| $menu.shop_add(s) }
	open_shop_magic

end

def setup_chester_shop

	$menu.char = 'boy'

	$menu.shop_init
	stock = []

	boy = $party.get('boy')

	# Based on $progress.chester_level

	# Skills to add at level five - RAVWYN
	if $progress.chester_level >= 6
		stock.push('ug-staff-7') if boy.has_skill?('ug-staff-6')
	end

	# Skills to add at level five - DWARVES
	if $progress.chester_level >= 5		
		stock.push('ug-mana-5') if boy.has_skill?('ug-mana-4')
		stock.push('ug-staff-6') if boy.has_skill?('ug-staff-5')
		stock.push('flames-4') if boy.has_skill?('ug-flames-3')
		stock.push('ug-passive-scare')
	end

	# Skills to add at level 4 - ELVES
	if $progress.chester_level >= 4
		stock.push('ug-mana-4') if boy.has_skill?('ug-mana-3')
		stock.push('staff-4') if boy.has_skill?('staff-3')
		stock.push('ug-staff-5') if boy.has_skill?('ug-staff-4')
		stock.push('ug-passive-cheeki')
		stock.push('ug-magic-minion')
		stock.push('triumph-2')
	end

	# Skills to add at level 3 - WEE
	if $progress.chester_level >= 3
		stock.push('levitate')
		stock.push('flames-3') if boy.has_skill?('ug-flames-2')
		stock.push('ug-mana-3') if boy.has_skill?('ug-mana-2')
		stock.push('ug-staff-4') if boy.has_skill?('ug-staff-3')
		stock.push('ug-passive-shop')
	end

	# Skills to add at level 2 - ROYAL
	if $progress.chester_level >= 2
		stock.push('sacrifice')
		stock.push('contempt-3') if boy.has_skill?('contempt-2')
		stock.push('ug-mana-2') if boy.has_skill?('ug-mana-1')
		stock.push('staff-3') if boy.has_skill?('staff-2')
		stock.push('ug-staff-3') if boy.has_skill?('ug-staff-2')
	end

	# Skills to add at level 1 - TOR
	if $progress.chester_level >= 1
		stock.push('triumph')
		stock.push('flames-2')
		stock.push('ug-mana-1')
		stock.push('ug-staff-2') if boy.has_skill?('ug-staff-1')
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

	$skill = skill

	case skill

		# New skills
		when 'sacrifice','empower','triumph', 'levitate'
			boy.learn(skill)
			flag('chester-new-skill')

		# Skill upgrades
		when 'contempt-2','contempt-3'
			boy.replace_skill('contempt',skill)
			flag('chester-new-skill')

		when 'flames-2','flames-3'
			boy.replace_skill('flames',skill)
			flag('chester-new-skill')

		when 'staff-2','staff-3','staff-4','staff-5','staff-6'
			boy.replace_skill('staff',skill)	
			flag('chester-new-skill')

		when 'triumph-2'
			boy.replace_skill('triumph',skill)		
			flag('chester-new-skill')

		# Staff upgrades

		when 'ug-staff-1','ug-staff-2','ug-staff-3','ug-staff-4','ug-staff-5','ug-staff-6','ug-staff-7'

			log_sys("GET NEW STAFF")

			# Replace boy equip with new
			boy.learn(skill)
			eq = skill.sub('ug','boy')
			boy.force_equip('staff',eq)

			$staff = eq
			flag('chester-new-staff')

		# Stat upgrades

		when 'ug-mana-1'
			boy.learn(skill)
			$party.boy_mp_bonus = 10
		when 'ug-mana-2'
			boy.learn(skill)
			$party.boy_mp_bonus = 20
		when 'ug-mana-3'
			boy.learn(skill)
			$party.boy_mp_bonus = 30
		when 'ug-mana-4'
			boy.learn(skill)
			$party.boy_mp_bonus = 40
		when 'ug-mana-5'
			boy.learn(skill)
			$party.boy_mp_bonus = 50


		# Passives
		when 'ug-passive-shop'
			boy.learn(skill)
			$party.passive_shop = true

		when 'ug-passive-cheeki'
			boy.learn(skill)
			$party.passive_cheekis = true

		when 'ug-passive-scare'
			boy.learn(skill)
			$party.passive_scare = true

	end

end

