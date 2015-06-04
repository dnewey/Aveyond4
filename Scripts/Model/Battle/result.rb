
class Attack_Result

	attr_accessor :target
	
	attr_accessor :damage
	attr_accessor :critical

	attr_accessor :state_add
	attr_accessor :state_remove

	attr_accessor :transform

end

class Attack_Round

	attr_accessor :anim_a
	attr_accessor :anim_b

	attr_accessor :skill

end

class Attack_Plan

	def initialize

		@attacks = []

	end

	def add(attack)
		@attacks.push(attack)
	end

	def next_attack
		return @attacks.shift
	end

	def done?
		return @attacks.empty?
	end

end