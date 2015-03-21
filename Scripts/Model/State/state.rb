
module Av

	class State

		def initialize

			@flags = []
			@vars = {}

			# Event modifiers
			@states = {} # Event states
			@locs = {}
			@deleted = []
			@disabled = []

		end

		def flag!(f)
			@flags.push(f) if !@flags.include?(f)
		end

		def unflag!(f)
			@flags.delete(f)
		end

		def flag?(f)
			return @flags.include?(f)
		end

		def var!(v,a)
			if @vars.has_key?(v)
				@vars[v] += a
			else
				@vars[v] = a
			end
		end

		def unvar!(v,a)
			if @vars.has_key?(v)
				@vars[v] -= a
			else
				@vars[v] = -a
			end
		end

		def var?(v,t)
			return false if !@vars.has_key?(v)
			return @vars[v] >= t
		end

		def state!(e,s)
			@states[[$map.id,e,s]] = true
		end

		def unstate!(e,s)
			@states[[$map.id,e,s]] = false
		end

		def state?(e,s)
			return false if !@states.has_key?([$map.id,e,s])
			return @states[[$map.id,e,s]]
		end

		def loc!(e)
			@locs[[$map.id,e]] = [e.x,e.y]
		end

		def loc?(e)
			return @locs.has_key?([$map.id,e])			
		end

		def getloc(e)
			return @locs[[$map.id,e]]
		end

		def delete!(e)
			@deleted.push([$map.id,e])
		end

		def delete?(e)
			return @deleted.include?([$map.id,e])
		end

		def disable!(e)
			@disabled.push([$map.id,e])
		end

		def disable?(e)
			return @disabled.include?([$map.id,e])
		end

	end

end