#==============================================================================
# Ui_Info
#==============================================================================

class Ui_Info < SpriteGroup

	def initialize(vp,message)
		super()

		@message = message
		@hiding = false

		# Map
		@map = Label.new(vp)
		@map.font = $fonts.pop_type
		@map.icon = $cache.icon("items/map")
		@map.text = $map.nice_name
		add(@map,0,0)

		@icon = Sprite.new(vp)
		@icon.bitmap = $cache.icon("misc/coins")
		add(@icon,610,0)

		@gold = Label.new(vp)
		@gold.font = $fonts.pop_type
		@gold.fixed_width = 200
		@gold.align = 2
		@gold.text = $party.gold.to_s
		add(@gold,410,0)

		move(0,415)

		@visible_gold = $party.gold
		@visible_map = $map.nice_name

		@visible_id = $map.id

		refresh

	end

	def dispose
		@map.dispose
		@gold.dispose
	end

	def hide
		super
		@hiding = true
	end

	def show
		super
		@hiding = false
	end

	def update
		super

		if (@message.busy? && @message.mode == :vn) || @hiding
			@gold.opacity -= 5
			@icon.opacity -= 5
			@map.opacity -= 5
		else
			@gold.opacity += 5
			@icon.opacity += 5
			@map.opacity += 5
		end

		refresh if @visible_gold != $party.gold || @visible_id != $map.id
	end

	def refresh
		@visible_gold = $party.gold
		@visible_map = $map.nice_name
		@visible_id = $map.id

		@map.text = @visible_map
		@gold.text = @visible_gold.to_s

	end

end