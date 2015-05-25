
class ItemCmd

	def initialize(vp)

		@menu = List_Common.new(vp)
		@menu.list.select = Proc.new{ |option| self.select(option) }
		@menu.list.cancel = Proc.new{ |option| self.cancel(option) }
		@menu.list.change = Proc.new{ |option| self.change(option) }
		
		data = []
		data.push('covey')
		data.push('covey')
		data.push('covey')

		@menu.list.setup(data)

	end

end