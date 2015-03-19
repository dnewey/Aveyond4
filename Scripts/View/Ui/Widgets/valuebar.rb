#==============================================================================
# Widget_Bar
#==============================================================================

class Widget_Bar < Widget
  
  # accessors
  attr_accessor :align, :font, :width
    
  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def create
       
    super

    @font = Fonts.get('menu_label')
    @text = "Label"
    @align = 0
    @width = 0
    
    self.bitmap = Bitmap.new(1,1)
    self.bitmap.font = @font
    redraw
    
  end
  
  #--------------------------------------------------------------------------
  # * Manage
  #--------------------------------------------------------------------------
  def set_text(text)
    return if text == nil
    @text = text
    redraw if @text != ''
  end
    
  #--------------------------------------------------------------------------
  # * Redraw
  #--------------------------------------------------------------------------
  def redraw
  
    sz = self.bitmap.text_size(@text)
    @width = sz.width if @width == 0
    self.bitmap = Bitmap.new(@width,sz.height)
    self.bitmap.font = @font    
    self.bitmap.draw_text(0,0,@width,sz.height,@text,@align) 
    
  end
  
end