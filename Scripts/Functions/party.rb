#==============================================================================
# ** Item Functions
#==============================================================================

def gold(amount,type='f')
	sys('coins')
	$party.add_gold(amount)
	pop_gold(amount,type)
end

def ungold(amount)
	sys('coins')
	$party.add_gold(-amount)
end

def gold?(amount)
	return $party.has_gold?(amount)
end

def magics(amount)
	sys('coins')
	$party.add_magics(amount)
end

def unmagics(amount)
	sys('coins')
	$party.add_magics(-amount)
end

def magics?(amount)
	return $party.has_magics?(amount)
end

def magics_exchange
	adding = $party.item_number('cheeki')
	mult = $data.numbers['cheeki-magic'].value
	amount = adding*mult
	#amount = 7
	magics(amount)
	pop_magics(amount)
	unitem('cheeki',amount)
end

def bugs_exchange
	sfx 'item'
	adding = $party.item_number('night-bug')
	mult = $data.numbers['night-bugs'].value
	amount = adding*mult
	$progress.add_night_xp(amount)
	pop_night(amount)
	unitem('night-bug',amount)

	if $progress.night_xp >= 400
		$progress.night_rank = 5
		flag('nw-rank-4') 
	elsif $progress.night_xp >= 300
		$progress.night_rank = 4
		flag('nw-rank-3') 
	elsif $progress.night_xp >= 200
		$progress.night_rank = 3
		flag('nw-rank-2') 
	elsif $progress.night_xp >= 100
		$progress.night_rank = 2
		flag('nw-rank-1') 
	else
		$progress.night_rank = 1
		flag('nw-rank-0') 
	end


end

def owl_exchange
	sfx 'item'
	adding = $party.item_number('owl-feather')
	mult = $data.numbers['owl-feather'].value
	amount = adding*mult
	$progress.add_night_xp(amount)
	pop_night(amount)
	unitem('owl-feather',amount)

	if $progress.night_xp >= 400
		$progress.night_rank = 5
		flag('nw-rank-4') 
	elsif $progress.night_xp >= 300
		$progress.night_rank = 4
		flag('nw-rank-3') 
	elsif $progress.night_xp >= 200
		$progress.night_rank = 3
		flag('nw-rank-2') 
	elsif $progress.night_xp >= 100
		$progress.night_rank = 2
		flag('nw-rank-1') 
	else
		$progress.night_rank = 1
		flag('nw-rank-0') 
	end
end

def item(id,number=1,type='f')
	if !number.is_a?(Integer)
		type = number
		number = 1
	end
	sfx 'item'
	$party.add_item(id,number)
	return if !$scene.is_a?(Scene_Map) && !$scene.is_a?(Scene_Battle)
	pop_item(id,number,type) if type != 's'
end

def unitem(id,number=1)
	$party.lose_item(id,number)
end

def item?(id,number=1)
	$party.has_item?(id,number)
end

def grant_items
	$data.items.each{ |k,v|
		#log_scr(v.id)
		item(v.id,99,'s')
	}
end

def grant_shop_items
	$data.items.each{ |k,v|
		if v.tab == 'shop'
			item(v.id,1,'s')
		end
	}
end

# For the vault
def item_from_card(e)
	cards = ['archer','arrow','begger','crown','dagger','false','gold','king','poison','thief']
    cards.each{ |c|
        if $state.state?(e,'card-'+c)
          item('card-'+c)
          unstate(e,'card-'+c)
          unstate(e,'on')
          return
        end        
    }
end

def card_from_ev(e)
	cards = ['archer','arrow','begger','crown','dagger','false','gold','king','poison','thief']
    cards.each{ |c|
        if $state.state?(e,'card-'+c)
          return c
        end        
    }
    return ''
end

#==============================================================================
# ** Members
#==============================================================================

# Only this one will do popper
def join(who)
	sys('join2')
	$party.set_active(who)
	pop_join(who)
	$scene.hud.bar.refresh if $scene.is_a?(Scene_Map)
end

def join_s(who)
	$party.set_active(who)
	$scene.hud.bar.refresh if $scene.is_a?(Scene_Map)
end

def unjoin(who)
	sys('unjoin')
	pop_leave(who)
	$party.back_to_pavillion(who)
	$scene.hud.bar.refresh if $scene.is_a?(Scene_Map)
end

def unjoin_s(who)
	$party.back_to_pavillion(who)
	$scene.hud.bar.refresh if $scene.is_a?(Scene_Map)
end

def party_of_boy
	$party.backup_party
	$party.leader = 'boy'
	join_s('boy')
end

def party_of_hib
	$party.backup_party
	$party.leader = 'hib'
	join_s('hib')
end

def party_of_ing
	$party.backup_party
	$party.leader = 'ing'
	join_s('ing')
end

def party_of_nightwatch
	$party.backup_party
	$party.leader = 'rob'
	join_s('rob')
	join_s('mys')
end

def party_of_all
	$party.restore_party
end

def make_reserve(who)
	$party.set_reserve(who)
end

def make_active(who)
	$party.set_active(who)
end


def grant_stat(who,stat,amount)
	$party.get(who).grant_stat(stat,amount)
	pop_stat_bonus(who,stat,amount)
end

def grant_stat_all(stat,amount)
	($party.active+$party.reserve).each{ |m|
		$party.get(m).grant_stat(stat,amount)
	}
	pop_stat_all(stat,amount)
end

def ungrant_stat(who,stat,amount)
	$party.get(who).ungrant_stat(stat,amount)
	pop_stat_unbonus(who,stat,amount)
end

def grant_xp_all(amount)

	($party.active+$party.reserve).each{ |m|
		$party.get(m).gain_xp(amount)
		if $party.get(m).level_up?
			pop_level(m)
		end
	}

	pop_xp_all(amount)

end

def grant_level_all
	($party.active+$party.reserve).each{ |m|
		$party.get(m).grant_level
	}
	pop_level_all
end

def grant_level(who)
	$party.get(who).grant_level
	pop_level(who)
end

def grant_level_s(who)
	$party.get(who).grant_level
end

def grant_level_free(who)
	$party.get(who).grant_level(false)
	pop_level(who)
end

def learn_skill(who,skill)
	sys 'join'
	pop_learn(skill,who)
	$party.get(who).learn(skill)
end

def unlearn_skill(who,skill)
	$party.get(who).unlearn(skill)
end