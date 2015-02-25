
# Base for most data types
class AvData

	attr_reader :id
	attr_reader :name
	attr_reader :icon
	attr_reader :description
	attr_reader :category

end

class ItemData < AvData

	attr_reader :price
	attr_reader :usable
	attr_reader :skill
	attr_reader :action

end

class GearData < AvData

end

class SkillData < AvData

end

class StateData < AvData

end

class ActorData

end

class EnemyData

end
