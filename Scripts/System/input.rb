#============================================================================== 
# ** Input
#==============================================================================

class InputManager

	def dir4
		return 2 if $keyboard.state?(VK_DOWN) || $keyboard.state?(VK_S)
		return 4 if $keyboard.state?(VK_LEFT) || $keyboard.state?(VK_A)
		return 6 if $keyboard.state?(VK_RIGHT) || $keyboard.state?(VK_D)
		return 8 if $keyboard.state?(VK_UP) || $keyboard.state?(VK_W)
		return 0
	end

	def action?
		return $keyboard.press?(VK_ENTER) ||
			   $keyboard.press?(VK_SPACE) 
	end

	def click?
		return false if !$settings.mouse
		return $keyboard.press?(VK_LBUTTON)
	end

	def cancel?
		return $keyboard.press?(VK_ESC) || $keyboard.press?(VK_NUM0)
	end

	def rclick?
		return false if !$settings.mouse
		return $keyboard.press?(VK_RBUTTON)
	end

	def left?
		return $keyboard.press?(VK_LEFT) || $keyboard.press?(VK_A)
	end

	def right?
		return $keyboard.press?(VK_RIGHT) || $keyboard.press?(VK_D)
	end

	def up?
		return $keyboard.press?(VK_UP) || $keyboard.press?(VK_W)
	end

	def down?
		return $keyboard.press?(VK_DOWN) || $keyboard.press?(VK_S)
	end

	def shortcut?(s)

	end

	def shift?
		return $keyboard.state?(VK_SHIFT)
	end

end