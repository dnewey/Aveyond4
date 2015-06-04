
class SkillCmd < ItemCmd

	def setup(battler)

		@battler = battler

		@list.opacity = 255
		@window.opacity = 255
		@box.opacity = 255

		skill_list = @battler.skill_list

		log_info(skill_list)
		@box.type = :skill
		@list.type = :skill
		@list.setup(skill_list)
		change(skill_list[0])
	end

	def get_skill
		return @item
	end

end