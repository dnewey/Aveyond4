
class Game_Battler

	def equip(slot,new_equip)

		if @equips[slot] != nil # Remove existing
			$party.add_item(@equips[slot])
			@equips[slot] = nil
		end

		if new_equip != nil
			$party.lose_item(new_equip)
			@equips[slot] = new_equip
		end

	end

	def force_equip(slot,new_equip)
		@equips[slot] = new_equip
	end

	def equip_list
		list = []
		@slots.each{ |s|
			list.push(@equips[s])
		}
		return list
	end

	def slot(s)
		return @equips[s]
	end

	def weapon_icon
		if @equips[@slots[0]] == nil
			return 'misc/unknown'
		else
			return $data.items[@equips[@slots[0]]].icon
		end
	end



	# Compare all stat changes, prepare a list of actual changes
	# Include slot in case this is a removal
	def equip_result_mega(new_equip,slot)

		# hp, mp, str, def, eva, luk, res
		before = stat_list
		old = @equips[slot]
		@equips[slot] = new_equip
		after = stat_list
		@equips[slot] = old

		change = after.dup
		change.each_index{ |i| change[i] -= before[i] }

		return [before,after,change]

	end

	# def equip_result_single(new_equip)

	# 	slot = $data.items[new_equip]

	# end


	def equip_result(new_equip)
		# What is the stat
		return ' ' if new_equip.stats == nil || new_equip.stats == ''
		type = new_equip.stats.split("\n")[0].split("=>")[0]
		slot = new_equip.slot
		old = @equips[slot]
		before = stat(type)
		@equips[slot] = new_equip.id
		after = stat(type)
		@equips[slot] = old
		res = (after - before).to_i.to_s
		if after-before >= 0
			res = "+#{res}"
		end
		return res
	end

	def equip_result_full(new_equip,slot)
		
		# What is the stat
		# Check old and new
		type = new_equip.stats.split("\n")[0].split("=>")[0]

		old = @equips[slot]
		before = stat(type)
		@equips[slot] = new_equip.id
		after = stat(type)
		@equips[slot] = old
		
		res = (after - before).to_i.to_s
		if after-before >= 0
			res = "+#{res}"
		end
		return [before,after,res]
		
	end

end