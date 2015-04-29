
def sequence(a,b)
	return SequenceTween.new(a,b)
end

def repeat(a,times=-1)
	return LoopTween.new(a,times)
end

def parallel(*args)
	return ParallelTween.new(args)
end

def pingpong(var,amount,duration,ease=:linear)
	return PingPongTween.new(var,amount,duration,ease)
end

def set(var,value)
	return SetTween.new(var,value)
end

def delay(duration)
	return DelayTween.new(duration)
end

def call(script)
	return CallTween.new(script)
end

def go(var,amount,dur,ease=:linear)
	return TimedTween.new(var,amount,dur,ease)
end

def to(var,target,speed=nil)
	return TargetTween.new(var,target,speed)
end

def proc(prc,delay=0)
	return ProcTween.new(prc,delay)
end


#==============================================================================
# ** Tweens
#==============================================================================

class Tween

	attr_reader :parent

	def initialize
		@parent = nil
	end

	def set_parent(parent)
		@parent = parent
	end

	def disposed?
		return @parent.disposed? if !@parent.nil?
		return false
	end

	def start
	end

end

class SetTween < Tween

	def initialize(var,value)
		@var = var
		@value = value
	end

	def done?
		return true
	end

	def start
		@parent.send(@var+"=",@value)
	end

	def copy
		return SetTween(@var,@value)
	end

end

class CallTween < Tween

	def initialize(script)
		@script = script
	end

	def done?
		return true
	end

	def start
		eval(@script)
	end

	def copy
		return CallTween(@script)
	end

end

class ProcTween < Tween

	def initialize(proc,delay)
		@proc = proc
		@delay = delay
	end

	def done?
		return @delay <= 0
	end

	def update(delta)
		@delay -= delta
		@proc.call()if done?
	end

end

class DelayTween < Tween

	def initialize(duration)
		@elapsed = 0
		@duration = duration
	end

	def done?
		return @elapsed >= @duration
	end

	def update(delta)
		@elapsed += delta
		@elapsed = @duration if @elapsed > @duration
	end

end

# Timed Tween
class TimedTween < Tween

	attr_accessor :elapsed, :duration, :ease

	def initialize(var,amount,duration,ease=:linear)
		@elapsed = 0
		@duration = duration
		@ease = ease
		@var = var
		@amount = amount
	end

	def done?
		return @elapsed >= @duration
	end

	def start
		@initial = @parent.send(@var)
	end

	def update(delta)
		@elapsed += delta
		@elapsed = @duration if @elapsed > @duration
		var = easing(elapsed, @initial, @amount, @duration, @ease)
		@parent.send(@var+"=",var)
	end

	def reverse
		nano = TimedTween.new(@var,-@amount,@duration,@ease)
		nano.set_parent(@parent)
		return nano
	end

	def copy
		nano = TimedTween.new(@var,@amount,@duration,@ease)
		nano.set_parent(@parent)
		return nano
	end

end

class TargetTween < Tween

	attr_accessor :initial, :target, :speed

	def initialize(var,target,speed=nil) # speed default to 10% distance
		@target = target
		@var = var
		@speed = speed
	end

	def done?
		return @target == @parent.send(@var)
	end

	def start
		@initial = @parent.send(@var)
		@dist = @target - @initial
		@speed = @dist.to_f/10 if @speed == nil
	end

	def update(delta)
		val = @parent.send(@var)
		if (@target-val).abs < @speed.abs
			val = @target
		else
			val += @speed
		end		
		@parent.send(@var+"=",val)
	end

	def reverse

	end

	def copy
		nano = TargetTween.new(@var,@target,@speed)
		nano.set_parent(@parent)
		return nano
	end

end

#==============================================================================
# ** Hosts
#==============================================================================

class PingPongTween < TimedTween

	def done?
		# Never ending nano
		return false
	end

	def update(delta)
		super(delta)
		if @elapsed == @duration
			@initial = @parent.send(@var)
			@elapsed = 0
			@amount= -@amount
		end
	end

end

#==============================================================================
# ** Hosts
#==============================================================================

class LoopTween < Tween

	def initialize(child,times=-1)
		#super
		@initial = child.copy
		@child = child
		@times = times
	end

	def done?
		return @child.done? && @times == 0
	end

	def set_parent(parent)
		super(parent)
		@initial.set_parent(parent) if @initial
		@child.set_parent(parent)
	end

	def start
		@child.start
	end

	def update(delta)
		@child.update(delta)
		if @child.done?
			@times -= 1
			if @times != 0
				@child = @initial
				@initial = @child.copy
				@child.set_parent(@parent)
				#log_append 'start child'
				@child.start
			end
		end
	end

	def reverse

	end

	def copy
		return LoopTween.new(@child.copy, @times)
	end

end

class SequenceTween < Tween

	def initialize(*args)
		@sequence = args
	end

	def push(nano)
		@sequence.push(nano)
	end

	def set_parent(parent)
		super(parent)
		@sequence.each{ |n| n.set_parent(parent)}
	end

	def done?
		return @sequence.empty?
	end

	def clear
		@sequence.clear
	end

	def start
		start_instants
	end

	def start_instants
		return if @sequence.empty?
		#log_append @sequence.first
		@sequence.first.start
		while !@sequence.empty? && @sequence.first.done?
			@sequence.shift#.dispose
			@sequence.first.start if !@sequence.empty?
		end
	end

	def update(delta)
		return if @sequence.empty?
		@sequence.first.update(delta)
		if @sequence.first.done?
			@sequence.shift#.dispose
			start_instants
		end
	end

	def count
		return @sequence.count
	end

	def reverse
		nano = SequenceTween.new()
		@sequence.reverse.each{ |n|
			nano.push(n.copy)
		}
		return nano
	end

	def copy
		nano = SequenceTween.new()
		@sequence.each{ |n|
			nano.push(n.copy)
		}
		return nano
	end

end

class ParallelTween < Tween

	def initialize(*args)
		@nanos = args
	end

	def push(nano)
		@nanos.push(nano)
	end

	def set_parent(parent)
		super(parent)
		@nanos.each{ |n| n.set_parent(parent)}
	end

	def done?
		@nanos.each{ |n|
			return false if !n.done?
		}
		return true
	end

	def start
		@nanos.each{ |n| 
			n.start
		}
	end

	def update(delta)
		@nanos.each{ |n| 
			n.update(delta)
		}
	end

	def reverse

	end

	def copy
		nano = ParallelTween.new()
		@nanos.each{ |n|
			nano.push(n.copy)
		}
		return nano
	end

end