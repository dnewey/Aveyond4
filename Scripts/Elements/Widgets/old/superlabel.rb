#==============================================================================
# Widget_Label
#==============================================================================

# 
class Widget_SuperLabel < Widget
  
  # accessors
  attr_accessor :align, :font, :width, :spacing
  attr_reader :text
    
  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def create

    #@font = Fonts.get('textbox')
    @text = "Label"
    @align =  0
    @width = 0

    @spacing = 1.0
    
    # Hold child letters in a layer?
    @children = []

    @angle = 0

    #rebuild
    
  end

  #--------------------------------------------------------------------------
  # * Manage
  #--------------------------------------------------------------------------
  def text=(text)
    return if text == nil
    @text = text
    #rebuild
  end

  def update
    super

    font = Fonts.get('textbox')
    # reput positions of characters
    cx = self.x
    @children.each{ |char| 
      char.x = cx
      #char.y = self.y
      cx += char.bitmap.width + @spacing - font.shadow
    }    

    #CENTER
    width = 0
    @children.each{ |char| 
      width += char.bitmap.width + @spacing - font.shadow
    }  
    width -= @spacing

    # get starter
    cx = self.x - width/2
    @children.each{ |char| 
      char.x = cx
      #char.y = self.y
      cx += char.bitmap.width + @spacing - font.shadow
    }   

    angle = @angle
    @angle += 0.1
    step = 0.2
    power = 8
    @children.each{ |c| 
      c.y = self.y + power * Math.sin(angle)
      angle += step
    }

  end
    
  #--------------------------------------------------------------------------
  # * Redraw
  #--------------------------------------------------------------------------
  def refresh
  
    @children.each { |c| c.dispose }
    @children.clear

    cx = self.x

    font = Fonts.get('textbox')
    d = 0
    z = 0

    @text.split('').each{ |c|
      log_append(c)
      char = Sprite.new(self.viewport)
      char.bitmap = font.letter(c)
      char.x = cx + char.bitmap.width/2
      char.y = self.y
      char.z += z
      z += 1
      char.ox = char.bitmap.width/2
      char.oy = char.bitmap.height/2
      cx += char.bitmap.width + @spacing - font.shadow
      #char.do(sequence(delay(d),pingpong("y",10,800,:quad_in_out)))
      #d += 50
      @children.push(char)
    }
    
    #self.do(pingpong("spacing",7,300,:quad_in_out))
    
  end
  
end