class Object
	def do(tween)
		# Register
		tween.set_parent(self)
		$tweens.register(tween)
		tween.start
	end
	def done?
		return $tweens.done?(self)
	end
end