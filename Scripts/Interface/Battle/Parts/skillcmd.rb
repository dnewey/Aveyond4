
class SkillCmd < ItemCmd

	def setup(battler,action)

		@battler = battler

		skill_list = @battler.skill_list(action)

		log_info(skill_list)
		@box.type = :skill
		@list.type = :skill
		if @battler.id == 'boy'
			@list.type = :skill_boy
		end
		if @battler.id == 'phy'
			@list.type = :skill_phy
		end
		@list.setup(skill_list)
		change(skill_list[0]) if !skill_list.empty?

		open
	end

	def get_skill
		return @item
	end

	def change(option)
		return if !@box
		@item = option
		@box.skill(option)
		#@box.center(462,130+@list.page_idx*@list.item_height)
	end

end