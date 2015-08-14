
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

	def equip_list
		list = []
		@slots.each{ |s|
			list.push(@equips[s])
		}
		log_info(list)
		return list
	end

	def equip_result(new_equip,slot)
		# What is the stat
		return 'none' if new_equip.stats == nil || new_equip.stats == ''
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