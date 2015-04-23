class Object
	def do(tween)
		# Register
		tween.set_parent(self)
		$tweens.register(tween)
		tween.start
	end

	# These don't work for some reason
	def go(var,amount,dur,ease=:linear)
		self.do(TimedTween.new(var,amount,dur,ease))
	end

	def to(var,target,speed=nil)
		self.do(TargetTween.new(var,target,speed))
	end

	def done?
		return $tweens.done?(self)
	end
end