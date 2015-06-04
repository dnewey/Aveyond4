
class Group

	def initialize(args)

		@events = args

	end

	def method_missing(m,*args)

		@events.each{ |ev|
			if ev.is_a?(String)
				argstring = " '#{ev}',"
			else
				argstring = " #{ev},"
			end

			args.each{ |a|
				if a.is_a?(String)
					argstring+=(" '"+a+"',")
				else
					argstring+=(" "+a+",")
				end
			}
			eval(m.to_s[1..-1]+argstring.chop)
		}

	end

end

def grp(*args)
	return Group.new(args)
end