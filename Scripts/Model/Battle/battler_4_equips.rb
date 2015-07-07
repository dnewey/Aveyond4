
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

	def equip_result(new_equip)
		# What is the stat
		type = new_equip.stats.split("\n")[0].split("=>")[0]
		slot = new_equip.slot
		old = @equips[slot]
		before = stat(type)
		@equips[slot] = new_equip.id
		after = stat(type)
		@equips[slot] = old

		log_scr("TYPE")
		log_scr(type)
		log_scr("BEFORE")
		log_scr(before)
		log_scr("AFTER")
		log_scr(after)

		return (after - before).to_s
	end

end