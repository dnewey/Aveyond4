#==============================================================================
# ** Nano Manager
#==============================================================================

class NanoManager

	def initialize
		@nanos = []
		@last = Time.now
	end

	def update

		# calc delta
		delta = ((Time.now - @last) * 1000).to_i
		@last = Time.now

		@nanos.delete_if{ |n| n == nil || n.done? }
	    @nanos.each{ |n| n.update(delta) }

	end

	def register(nano)
		@nanos.push(nano)
	end

	def clear(object)
		@nanos.delete_if{ |n| n.parent == object } 
	end

	def clear_all
		@nanos.clear
	end

	def done?(object)
		return @nanos.select{ |n| n.parent == object }.empty?
	end

end