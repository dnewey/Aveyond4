class State

	def initialize

		@flags = []
		@vars = {}

		# Event modifiers
		@states = {} # Event states
		@locs = {}
		@deleted = []
		@disabled = []

		# Deleted in future
		@nospawn = []

		# Menu indexes?

	end

	def flag(f)
		@flags.push(f) if !@flags.include?(f)
		$scene.map.need_refresh = true if !$scene.is_a?(Scene_Menu)
	end

	def unflag(f)
		@flags.delete(f)
		$scene.map.need_refresh = true
	end

	def flag?(f)
		return @flags.include?(f)
	end

	def var(v,a)
		if @vars.has_key?(v)
			@vars[v] += a
		else
			@vars[v] = a
		end
		$scene.map.need_refresh = true
	end

	def unvar(v,a)
		if @vars.has_key?(v)
			@vars[v] -= a
		else
			@vars[v] = -a
		end
		$scene.map.need_refresh = true
	end

	def var?(v,t)
		return false if !@vars.has_key?(v)
		return @vars[v] >= t
	end

	def varval(v)
		return 0 if !@vars.has_key?(v)
		return @vars[v]
	end

	def state(e,s)
		@states[[$scene.map.id,e,s]] = true
		$scene.map.need_refresh = true
	end

	def unstate(e,s)
		@states[[$scene.map.id,e,s]] = false
		$scene.map.need_refresh = true
	end

	def state?(e,s)
		return false if !@states.has_key?([$scene.map.id,e,s])
		return @states[[$scene.map.id,e,s]]
	end

	def loc(e)
		ev = gev(e)
		@locs[[$scene.map.id,e]] = [ev.x,ev.y,ev.direction,ev.off_x,ev.off_y]
	end
	def nloc(e)
		@locs.delete([$scene.map.id,e])
	end

	def loc?(e)
		return @locs.has_key?([$scene.map.id,e])			
	end

	def getloc(e)
		return @locs[[$scene.map.id,e]]
	end

	def delete(e)
		@deleted.push([$scene.map.id,e])
	end

	def delete?(e)
		return @deleted.include?([$scene.map.id,e])
	end

	def disable(e)
		@disabled.push([$scene.map.id,e])
	end

	def disable?(e)
		return @disabled.include?([$scene.map.id,e])
	end

	def enable(e)
		@disabled.delete([$scene.map.id,e])
	end

	def nospawn(e)
		@nospawn.push([$scene.map.id,e])
	end

	def nospawn?(e)
		return @nospawn.include?([$scene.map.id,e])
	end

end
