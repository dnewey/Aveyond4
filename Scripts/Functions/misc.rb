
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

		when 'dig-chki'
			flag("arch-chki")

		else
			item($menu.chosen,1,'s')
			flag("arch-void")

	end

	unitem($menu.chosen)
	$menu.chosen = nil

end

def test_riddle_answer

	win = false

	# Does the item match the current quest
	if $progress.quest_active?('rq-riddle-1')
		win = ($menu.chosen == 'punkin-key')	
	end

	if $progress.quest_active?('rq-riddle-2')
		win = ($menu.chosen == 'cheese')			
	end

	if $progress.quest_active?('rq-riddle-3')
		win = ($menu.chosen == 'chocolate')			
	end

	if $progress.quest_active?('rq-riddle-4')
		win = ($menu.chosen == 'lemon')			
	end

	if $progress.quest_active?('rq-riddle-5')
		win = ($menu.chosen == 'elf-bread')			
	end

	if $progress.quest_active?('rq-riddle-6')
		win = ($menu.chosen == 'doll-witch')			
	end

	if $progress.quest_active?('rq-riddle-7')
		win = ($menu.chosen == 'mist-food')			
	end

	if win
		state(me,'riddle-win')
	else
		text('this: Not right!')
	end
	$menu.chosen = nil

end

def complete_riddle

	# Does the item match the current quest
	if $progress.quest_active?('rq-riddle-1')
		unquest('rq-riddle-1')	
	end

	if $progress.quest_active?('rq-riddle-2')
		unquest('rq-riddle-2')	
	end

	if $progress.quest_active?('rq-riddle-3')
		unquest('rq-riddle-3')	
	end

	if $progress.quest_active?('rq-riddle-4')
		unquest('rq-riddle-4')	
	end

	if $progress.quest_active?('rq-riddle-5')
		unquest('rq-riddle-5')	
	end

	if $progress.quest_active?('rq-riddle-6')
		unquest('rq-riddle-6')	
	end

	if $progress.quest_active?('rq-riddle-7')
		unquest('rq-riddle-7')	
	end

end

def text_riddle

	# Does the item match the current quest
	if $progress.quest_active?('rq-riddle-1')
		txt = $data.quests['rq-riddle-1'].description
		text('this:'+txt)
	end

	if $progress.quest_active?('rq-riddle-2')
		txt = $data.quests['rq-riddle-2'].description
		text('this:'+txt)
	end

	if $progress.quest_active?('rq-riddle-3')
		txt = $data.quests['rq-riddle-3'].description
		text('this:'+txt)
	end

	if $progress.quest_active?('rq-riddle-4')
		txt = $data.quests['rq-riddle-4'].description
		text('this:'+txt)
	end

	if $progress.quest_active?('rq-riddle-5')
		txt = $data.quests['rq-riddle-5'].description
		text('this:'+txt)
	end

	if $progress.quest_active?('rq-riddle-6')
		txt = $data.quests['rq-riddle-6'].description
		text('this:'+txt)
	end

	if $progress.quest_active?('rq-riddle-7')
		txt = $data.quests['rq-riddle-7'].description
		text('this:'+txt)
	end

end

def next_riddle

	if $progress.quest_complete?('rq-riddle-7')
		
	end

	if $progress.quest_complete?('rq-riddle-6')
		quest('rq-riddle-7')	
		return
	end

	if $progress.quest_complete?('rq-riddle-5')
		quest('rq-riddle-6')
		return
	end

	if $progress.quest_complete?('rq-riddle-4')
		quest('rq-riddle-5')	
		return
	end

	if $progress.quest_complete?('rq-riddle-3')
		quest('rq-riddle-4')	
		return
	end

	if $progress.quest_complete?('rq-riddle-2')
		quest('rq-riddle-3')
		return
	end

	if $progress.quest_complete?('rq-riddle-1')
		quest('rq-riddle-2')
	end

end

def show_book(which)

	data = $data.books[which]
	text('sys:'+data.title)


end

def party_gossip

	# Check who is in the party
	if $party.all.include?('phy')
		gossips = 12
	elsif $party.all.include?('row')
		gossips = 10
	elsif $party.all.include?('hib')
		gossips = 8
	elsif $party.all.include?('rob')
		gossips = 6
	else
		gossips = 4
	end

	# Choose a gossip
	$player.next_common = 31 + rand(gossips)

end

def witch_gossip

	$player.next_common = 51 + rand(7)

end

def vault_card_refresh

	# MAIN ROOM MAIN ROOM
	cards = []
	[67,41,68].each{|e|
		cards.push(card_from_ev(e))
	}

	log_info cards

	if cards.sort == ['','archer','thief']
		flag('vaughn-ch1')
	end

	if cards.sort == ['archer','arrow','king']
		flag('vaughn-ch2')
	end

	if cards.sort == ['','crown','thief']
		flag('vaughn-ch3')
	end

	if cards.sort == ['begger','dagger','thief']
		flag('vaughn-ch4')
	end

	# ARCHER POISONS ARROW

	cards = []
	[69,70,71].each{|e|
		cards.push(card_from_ev(e))
	}

	if cards.sort == ['archer','arrow','poison']
		flag('vaughn-side-archer')
	end
	
	# KING TRADES BEGGAR

	cards = []
	[72,73,74].each{|e|
		cards.push(card_from_ev(e))
	}

	if cards.sort == ['','beggar','king']
		flag('vaughn-side-king')
	end

	# THIEF PAYS ARCHER

	cards = []
	[75,76,77].each{|e|
		cards.push(card_from_ev(e))
	}

	if cards.sort == ['archer','gold','thief']
		flag('vaughn-side-payment')
	end


end

def gogogo

	log_ev("Debug function GO!")

	log_sys("Refreshing stat mods")
	$party.all_battlers.each{ |b| b.refresh_stat_mods }

end