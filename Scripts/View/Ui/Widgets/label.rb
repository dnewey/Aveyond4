#==============================================================================
# Widget_Label
#==============================================================================



class Widget_Label < Widget
  
  # accessors
  attr_accessor :align, :font, :skin, :padding, :fix_width, :indent
    
  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def create

    @font = Fonts.get('textbox')
    @skin = nil

    @text = "Label"

    @righty = ''#{}"x 10"

    @align = :left

    @padding = 5
    @indent = 0

    # If there is a width, don't auto size width
    @fix_width = 0
    
  end

  def update
    super
    #redraw
  end
  
  #--------------------------------------------------------------------------
  # * Manage
  #--------------------------------------------------------------------------
  def text=(text)
    return if text == nil
    @text = text
    #redraw if @text != ''
  end
    
  #--------------------------------------------------------------------------
  # * Redraw
  #--------------------------------------------------------------------------
  def refresh

    #self.bitmap.clear

    # Resize as required
    self.height = @font.height + (@padding * 2)
    if @fix_width > 0
      self.width = @fix_width
    else
      self.width = @font.width(@text) + (@padding*2) + @indent
    end
    
    self.from_skin(@skin) if @skin != nil
    self.bitmap = Bitmap.new(self.width,self.height) if @skin == nil

    # Draw the font!!!!
    cy = (self.height - @font.height) / 2
    if @align == :left
      cx = @indent + @padding
    elsif @align == :center
      cx = (self.width - @font.width(@text)) / 2
    else
      cx = self.width - @font.width(@text) - @padding
    end

    @text.split('').each{ |c|
      self.bitmap.blt(cx,cy,@font.letter(c),@font.letter(c).rect)
      cx += @font.step(c)
    }


    #if @righty != ""

      cx = self.width - @font.width(@righty) - @padding

      @righty.split('').each{ |c|
        self.bitmap.blt(cx,cy,@font.letter(c),@font.letter(c).rect)
        cx += @font.step(c)
      }

    #end

    
  end
  
end