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
				$game.push_scene Scene_Title.new()
				@round = :enough
		end
	end

end