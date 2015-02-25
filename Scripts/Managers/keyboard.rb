#==============================================================================
# ** Keyboard Manager
#==============================================================================

class KeyboardManager

	KeyState = Win32API.new("user32","GetKeyState",['i'],'i')
	
	def initialize
		@keys = []
	end

	def state?(key)
		check = KeyState.call(key) #& 0x80 == 128
		return !(check == 1 || check == 0)
	end

	def press?(key)
	  if !@keys.include?(key) && state?(key)
	  	@keys.push(key)
	  	return true
	  else
	  	return false
	  end
	end  

	def update
		@keys.delete_if { |k| !state?(k)}
	end

	  # http://www.mods.com.au/budapi_docs/Virtual%20Key%20Codes.htm

  def to_char(key)

    shift = Input.press?(Input::SHIFT)

    case key

      when 32; " "
      when 48; shift ? ')' : '0'
      when 49; shift ? '!' : '1'
      when 50; shift ? '@' : '2'
      when 51; shift ? '#' : '3'
      when 52; shift ? '$' : '4'
      when 53; shift ? '%' : '5'
      when 54; shift ? '^' : '6'
      when 55; shift ? '&' : '7'
      when 56; shift ? '*' : '8'
      when 57; shift ? '(' : '9'

      when 65..90; key.chr.downcase

      when 186; shift ? ':' : ';' 
      when 187; shift ? '+' : '=' 
      when 188; shift ? '<' : ',' 
      when 189; shift ? '_' : '-' 
      when 190; shift ? '>' : '.' 
      when 191; shift ? '?' : '/' 
      
      when 219; shift ? '{' : '[' 
      when 220; shift ? '|' : '\\'
      when 221; shift ? '}' : ']' 
      when 222; shift ? '"' : '\''

      else; nil

    end

  end

end