
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

end