#==============================================================================
# ** Scene_Splash
#==============================================================================

class Scene_Splash

	def initialize
	
		@round = :logo
	end

	def update
		# Go to next movie?
		case @round
			when :logo
				Graphics.play_movie('Movies/logo.mp4')
				@round = :title
			when :title
				Graphics.play_movie('Movies/logo.mp4')
				@round = :start
			when :start
				$menu.menu_page = :main
				$game.push_scene Scene_Menu.new()
				@round = :enough
		end
	end

end