#==============================================================================
# Ui_Info
#==============================================================================

class Ui_Info < SpriteGroup

	def initialize(vp)
		super()

		# Map
		@map = Label.new(vp)
		#@map.font = 
		@map.icon = $cache.icon("items/map")
		@map.text = "Wintershireton"
		add(@map,0,0)

		@gold = Label.new(vp)
		#@map.font = 
		@gold.icon = $cache.icon("misc/coins")
		@gold.text = 250.to_s
		add(@gold,560,0)

		move(0,415)

	end

	def refresh

	end

end