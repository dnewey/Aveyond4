
class SkillCmd < ItemCmd

	def setup(battler,action)

		@battler = battler

		skill_list = @battler.skill_list(action)

		@box.type = :skill
		@list.type = :skill
		@list.user = @battler.id
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
		@box.move(326,100) if @box

		#if @box && @last_option != option
			@last_option = option
			$tweens.clear(@box)
			@box.y -= 7
			@box.do(go("y",7,150,:qio))
		#end

	end

end