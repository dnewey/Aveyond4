#==============================================================================
# ** Nano Manager
#==============================================================================

class TweenManager

	def initialize
		@tweens = []
		@tweens_menu = []
		@last = Time.now
	end

	def update

		# calc delta
		delta = ((Time.now - @last) * 1000).to_i
		@last = Time.now

		if $scene.is_a?(Scene_Menu)
			@tweens_menu.delete_if{ |n| (n.is_a?(SpriteGroup) && n.disposed?) || (n.is_a?(Sprite) && n.disposed?) || n == nil || n.done? }		
		    @tweens_menu.each{ |n| n.update(delta) }
		else
			@tweens.delete_if{ |n| (n.is_a?(SpriteGroup) && n.disposed?) || (n.is_a?(Sprite) && n.disposed?) || n == nil || n.done? }		
		    
		    @tweens.each{ |n| 
		    	begin
		    		n.update(delta) 
		    	rescue
				end
		    }
			
		end

	end

	def register(tween)
		# Register to the set for this scene
		if $scene.is_a?(Scene_Menu)
			@tweens_menu.push(tween)	
		else
			@tweens.push(tween)
		end
	end

	def clear(object)
		if $scene.is_a?(Scene_Menu)
			@tweens_menu.delete_if{ |n| n.parent == object } 
		else
			@tweens.delete_if{ |n| n.parent == object } 
		end
	end

	def resolve(object)
		if $scene.is_a?(Scene_Menu)
			@tweens_menu.each{ |n| n.update(5000) if n.parent == object }
		else
			@tweens.each{ |n| n.update(5000) if n.parent == object }
		end
		clear(object)
	end

	def clear_all		
		if $scene.is_a?(Scene_Menu)
			@tweens_menu.clear
		else
			@tweens.clear
		end
	end

	def done?(object)
		if $scene.is_a?(Scene_Menu)
			return @tweens_menu.select{ |n| n.parent == object }.empty?
		else
			return @tweens.select{ |n| n.parent == object }.empty?
		end
	end

end