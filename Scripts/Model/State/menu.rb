
# Menu state
# Hold cursor positions, current character etc etc etc

class DataBox
	attr_accessor :type
	attr_accessor :text
	attr_accessor :icon
	attr_accessor :misc

	def initialize(type,text,icon="",misc="")
		@type = type
		@text = text
		@icon = icon
		@misc = misc
	end

end

class MenuData

end