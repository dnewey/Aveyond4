#==============================================================================
# ** Mnu_File
#==============================================================================

class DataBox

	attr_reader :id, :name

	def initialize(i)
		@id = i
		@name = "Item "+i.to_s
	end

end


class Mnu_File

	def initialize(vp)

		@char = Part_Char.new(vp)

		@list = List.new(vp)
		@list.x = 50
		@list.y = 60

		data = []
		(0..100).to_a.each{ |i|
			dta = DataBox.new(i)
			data.push(dta)
		}

		@list.setup(data)

	end

	def dispose

		@char.dispose

		@list.dispose

	end

	def update

		@list.update

	end

end