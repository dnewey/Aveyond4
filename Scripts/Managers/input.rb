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

	def cancel?
		return $keyboard.press?(VK_ESC)
	end

	def shortcut?(s)

	end

	def shift?
		return $keyboard.state?(VK_SHIFT)
	end

end