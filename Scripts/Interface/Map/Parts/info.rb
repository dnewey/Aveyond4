#==============================================================================
# Ui_Info
#==============================================================================

class Ui_Info < SpriteGroup

	def initialize(vp)
		super()

		# Map
		@map = Label.new(vp)
		@map.font = $fonts.pop_type
		@map.icon = $cache.icon("items/map")
		@map.text = $map.name
		add(@map,0,0)

		@gold = Label.new(vp)
		@gold.font = $fonts.pop_type
		@gold.icon = $cache.icon("misc/coins")
		@gold.text = $party.gold.to_s
		add(@gold,560,0)

		move(0,415)

		#refresh

	end

	def update
		super
		#refresh if @visible_gold != $party.gold || @visible_map != $map.name
	end

	def refresh
		@visible_gold = $party.gold
		@visible_map = $map.name

		@map.text = $visible_map
		@gold.text = $visible_gold.to_s

	end

end