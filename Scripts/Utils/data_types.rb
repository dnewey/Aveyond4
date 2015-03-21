
class ItemData
	attr_reader :id
	attr_reader :name
	attr_reader :description
	attr_reader :category
	attr_reader :icon
	attr_reader :price
	attr_reader :action
end

class WeaponData
	attr_reader :id
	attr_reader :name
	attr_reader :description
	attr_reader :category
	attr_reader :icon
	attr_reader :price
	attr_reader :action
end

class ArmorData
	attr_reader :id
	attr_reader :name
	attr_reader :description
	attr_reader :category
	attr_reader :icon
	attr_reader :price
	attr_reader :action
end

class SkillData

end

class StateData

end

class ActorData
	attr_reader :id
	attr_reader :name
	attr_reader :profile
	attr_reader :armor
	attr_reader :actions
	attr_reader :resource
	attr_reader :slots
	attr_reader :statratings
end

class EnemyData

end

class ZoneData
	attr_reader :bgm
	attr_reader :bgs
end

class ProgressData
	attr_reader :category
	attr_reader :id
	attr_reader :value
end

class QuestData
	attr_reader :id
end
