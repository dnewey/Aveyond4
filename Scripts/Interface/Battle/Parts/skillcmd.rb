
class SkillCmd

	def initialize(vp)

		#@text.bitmap = $cache.menu("battle/text.png")

		# Customized per character, but always as a nice list of types?
		# Skill would maybe be the only category for these?
		# All could be disable if need be

	end

	def setup(char)

		case char
			when 'boy'; setup_boy
			when 'ing'; setup_ing
		end
	end

	def setup_boy


	end

	def setup_ing

	end

	

end