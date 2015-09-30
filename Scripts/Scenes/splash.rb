#==============================================================================
# ** Scene_Splash
#==============================================================================

class Scene_Splash

	def initialize

		music('sample-start')

		@vp = Viewport.new(0,0,$game.width,$game.height)

		@logo = Sprite.new(@vp)
		@logo.bitmap = $cache.menu("Splash/logo")
		@logo.y = 100
		@logo.opacity = 0


		# Sky
		@sky = Sprite.new(@vp)
		@sky.bitmap = $cache.menu("Splash/test-sky")
		@sky.opacity = 0

		# Clouds
		@clouds = Sprite.new(@vp)
		@clouds.bitmap = $cache.menu("Splash/test-clouds")
		@clouds.x -= 50
		@clouds.opacity = 0
		#@clouds.do(pingpong("x",100,6000,:qio))

		# Wall
		@wall = Sprite.new(@vp)
		@wall.bitmap = $cache.menu("Splash/test-wall")
		@wall.opacity = 0

		@spark = Spark.new('evil-aura',270,60,@vp)
		@spark.zoom_x = 2.0
		@spark.zoom_y = 2.0
		@spark.opacity = 0

		@spark2 = Spark.new('evil-aura',420,60,@vp)
		@spark2.zoom_x = 2.0
		@spark2.zoom_y = 2.0
		@spark2.opacity = 0

		# Boy
		@boy = Sprite.new(@vp)
		@boy.bitmap = $cache.menu("Splash/test-boy")
		@boy.opacity = 0

		# Title
		@title = Sprite.new(@vp)
		@title.bitmap = $cache.menu("Splash/test-title")
		@title.opacity = 0

		# @boy = Sprite.new(@vp)
		# @boy.bitmap = $cache.face_menu("boy")
		# @boy.x = 160
		# @boy.y = 30
		# @boy.opacity = 0

		@mist = Sprite.new(@vp)
		@mist.bitmap = $cache.overlay('mist-portal')
		@mist.opacity = 0

		@round = :logo_appear
		@wait = 30

		#@round = :reveal
		#@wait = 0
		
	end

	def terminate

		@logo.dispose
		@vp.dispose

	end

	def update

		@spark.update
		@spark2.update

		@wait -= 1
		return if @wait > 0

		# Go to next movie?
		case @round

			when :logo_appear
				
				@logo.do(go('opacity',255,700,:qio))
				@logo.do(go('y',-100,500,:qio))

				@round = :mist_in
				@wait = 90

			when :mist_in
				
				Graphics.freeze
				@mist.opacity = 255
				src = "Graphics/Transitions/Cave"
				Graphics.transition(200,src)
				#@logo.do(go('opacity',-255,1500,:qio))

				@round = :start
				@wait = 15

			when :start

				Graphics.freeze

				@mist.opacity = 0

				# Prepare the title and all that
				@sky.opacity = 255
				@clouds.opacity = 255
				@wall.opacity = 255
				@spark.opacity = 255
				@spark2.opacity = 255
				@boy.opacity = 255
				@title.opacity = 255

				src = "Graphics/Transitions/Cave_inv"
				Graphics.transition(20,src)

				@round = :title
				@wait = 120

			when :reveal

			when :title
				$game.pop_scene
				$game.push_scene Scene_Title.new()
				@round = :enough
		end

	end

end