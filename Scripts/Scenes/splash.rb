#==============================================================================
# ** Scene_Splash
#==============================================================================

class Scene_Splash

	def initialize

		music('sample-start')

		@vp = Viewport.new(0,0,$game.width,$game.height)

		@white = Sprite.new(@vp)
		@white.bitmap = $cache.title("white")
		#@white.opacity = 0

		@logo = Sprite.new(@vp)
		@logo.bitmap = $cache.title("logo")
		@logo.x = 320
		@logo.y = 340		
		@logo.ox = 320
		@logo.oy = 340
		@logo.y -= 50
		@logo.opacity = 0

		@sheen = Sprite.new(@vp)
		@sheen.bitmap = $cache.title("sheen")
		@sheen.blend_type = 1
		@sheen.x = -300
		@sheen.opacity = 220

		@mist = Sprite.new(@vp)
		@mist.bitmap = $cache.overlay('mist-portal')
		@mist.opacity = 0

		@round = :logo_appear
		@wait = 15

		#@round = :title
		
	end

	def terminate

		@logo.dispose
		@vp.dispose

	end

	def update

		@wait -= 1
		return if @wait > 0

		# Go to next movie?
		case @round

			when :logo_appear
				
				@logo.do(go('opacity',255,700,:qio))
				@logo.do(go('y',50,600,:quad_io))

				@round = :logo_sheen
				@wait = 20

			when :logo_sheen

				sys('logo')
				@sheen.do(go('x',800,750,:qio))
				@round = :mist_in
				@wait = 50

			when :mist_in				
				
				Graphics.freeze
				@mist.opacity = 255
				src = "Graphics/Transitions/Cave"
				Graphics.transition(230,src)
				#@logo.do(go('opacity',-255,1500,:qio))

				@wait = 1
				@round = :title

			when :title
				$game.pop_scene
				$game.push_scene Scene_Title.new()
				@round = :enough

		end

	end

end