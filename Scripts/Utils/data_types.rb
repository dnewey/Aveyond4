
class UsableData
	attr_reader :id
	attr_reader :name
	attr_reader :description
	attr_reader :price
	attr_reader :action
	attr_reader :icon
	attr_reader :battle
	attr_accessor :tab
end

class KeyItemData
	attr_reader :id
	attr_reader :name
	attr_reader :description
	attr_reader :icon
	attr_reader :chapter
	attr_accessor :tab
end

class ShopData
	attr_reader :id
	attr_reader :name
	attr_reader :description
	attr_reader :icon
	attr_reader :value
	attr_accessor :tab
end

class GearData
	attr_reader :id
	attr_reader :name
	attr_reader :slot
	attr_reader :geartype
	attr_reader :description
	attr_reader :stats
	attr_reader :mods
	attr_reader :icon
	attr_reader :source
	attr_accessor :tab
end

class SkillData
	attr_reader :id
	attr_reader :name
	attr_reader :book
	attr_reader :description
	attr_reader :icon
	attr_reader :cost
	attr_reader :hits
	attr_reader :scope
	attr_reader :anim_a
	attr_reader :anim_b
	attr_reader :stats
	attr_reader :effects
end

class StateData
	attr_reader :id
	attr_reader :name
	attr_reader :stats
	attr_reader :mods
end

class ActorData
	attr_reader :id
	attr_reader :name
	attr_reader :profile
	attr_reader :actions
	attr_reader :resource
	attr_reader :slots
	attr_reader :mods
end

class EnemyData
	attr_reader :id
	attr_reader :name
	attr_reader :actions
	attr_reader :stats
	attr_reader :loot
end

class ZoneData
	attr_reader :id
	attr_reader :music
	attr_reader :atmosphere
	attr_reader :reverb
	attr_reader :tint
	attr_reader :weather
	attr_reader :fog
	attr_reader :panoramas
	attr_reader :enemies
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
	attr_reader :location
	attr_reader :req
	attr_reader :reward
	attr_reader :type
end

class AnimData
	attr_reader :id
	attr_reader :frames
	attr_reader :delay
	attr_reader :fadeout
	attr_reader :order
	attr_reader :blend
	attr_reader :opacity
	attr_reader :sound
end

class NumberData
	attr_reader :id
	attr_reader :value
	attr_reader :notes
end

