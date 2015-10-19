
class Attack_Result

	attr_accessor :target
	
	attr_accessor :damage
	attr_accessor :critical

	attr_accessor :heal

	attr_accessor :evade
	attr_accessor :resist

	attr_accessor :gain_mana

	attr_accessor :state_add
	attr_accessor :state_remove

	attr_accessor :transform

	attr_accessor :empower
	attr_accessor :steal
	attr_accessor :pocket
	attr_accessor :escape
	attr_accessor :revive

end

class Attack_Round

	attr_accessor :anim
	attr_accessor :text

	attr_accessor :skill

end

class Attack_Plan

	def initialize

		@attacks = []
		@cancel = false

	end

	def add(attack)
		@attacks.push(attack)
	end

	def next_attack
		return @attacks.shift
	end

	def cancel
		@cancel = true
	end

	def done?
		return true if @cancel
		return @attacks.empty?
	end

end