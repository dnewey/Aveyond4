#============================================================================== 
# ** Input
#==============================================================================

class InputManager

	def dir4
		return 2 if $keyboard.state?(VK_DOWN)
		return 4 if $keyboard.state?(VK_LEFT)
		return 6 if $keyboard.state?(VK_RIGHT)
		return 8 if $keyboard.state?(VK_UP)
		return 0
	end

	def action?
		return $keyboard.press?(VK_ENTER) ||
			   $keyboard.press?(VK_SPACE) 
	end

	def click?
		return $keyboard.press?(VK_LBUTTON)
	end

	def cancel?
		return $keyboard.press?(VK_ESC) || $keyboard.press?(VK_NUM0)
	end

	def rclick?
		return $keyboard.press?(VK_RBUTTON)
	end

	def left?
		return $keyboard.press?(VK_LEFT)
	end

	def right?
		return $keyboard.press?(VK_RIGHT)
	end

	def up?
		return $keyboard.press?(VK_UP)
	end

	def down?
		return $keyboard.press?(VK_DOWN)
	end

	def shortcut?(s)

	end

	def shift?
		return $keyboard.state?(VK_SHIFT)
	end

end