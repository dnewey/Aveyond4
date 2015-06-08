
class SkillCmd < ItemCmd

	def setup(battler)

		@battler = battler

		skill_list = @battler.skill_list

		log_info(skill_list)
		@box.type = :skill
		@list.type = :skill
		@list.setup(skill_list)
		change(skill_list[0])

		open
	end

	def get_skill
		return @item
	end

	def change(option)
		@item = option
		@box.skill(option)
		#@box.center(462,130+@list.page_idx*@list.item_height)
	end

end