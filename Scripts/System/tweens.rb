#==============================================================================
# ** Nano Manager
#==============================================================================

class TweenManager

	def initialize
		@tweens = []
		@last = Time.now
	end

	def update

		# calc delta
		delta = ((Time.now - @last) * 1000).to_i
		@last = Time.now

		@tweens.delete_if{ |n| n.disposed? || n == nil || n.done? }
	    @tweens.each{ |n| n.update(delta) }

	end

	def register(tween)
		@tweens.push(tween)
	end

	def clear(object)
		@tweens.delete_if{ |n| n.parent == object } 
	end

	def clear_all
		@tweens.clear
	end

	def done?(object)
		return @tweens.select{ |n| n.parent == object }.empty?
	end

end