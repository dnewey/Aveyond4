
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
	attr_reader :id
	attr_reader :name
	attr_reader :book
	attr_reader :description
	attr_reader :hits
	attr_reader :scope
	attr_reader :anim_a
	attr_reader :anim_b
	attr_reader :stats
	attr_reader :effects
end

class StateData

end

class ActorData
	attr_reader :id
	attr_reader :name
	attr_reader :profile
	attr_reader :actions
	attr_reader :resource
	attr_reader :slots
	attr_reader :statratings
end

class EnemyData

end

class ZoneData
	attr_reader :id
	attr_reader :bgm
	attr_reader :bgs
	attr_reader :tint
	attr_reader :weather
end

class ProgressData
	attr_reader :category
	attr_reader :id
	attr_reader :value
end

class QuestData
	attr_reader :id
	attr_reader :name
	attr_reader :description
	#attr_reader :category
	#attr_reader :icon
	#attr_reader :price
	#attr_reader :action
end
