#==============================================================================
# Widget_Label
#==============================================================================

class Label < Sprite
  
  # accessors
  attr_accessor :align 
  attr_accessor :font 
  attr_accessor :fixed_width
  attr_accessor :padding
  attr_accessor :indent
    
  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def initialize(vp)
    super(vp)

    @font = $fonts.debug

    @text = "Label"

    @align = 0

    @padding = 5
    @indent = 0

    # If there is a width, don't auto size width
    @fixed_width = 0

    @height = 0
    
  end

  def update
    super
    #redraw
  end
  
  #--------------------------------------------------------------------------
  # * Manage
  #--------------------------------------------------------------------------
  def text=(text)
    if @text != text
      @text = text
      refresh
    end
  end
    
  #--------------------------------------------------------------------------
  # * Redraw
  #--------------------------------------------------------------------------
  def refresh

    # If fixed width, don't recreate
    if @fixed_width > 0 
      if self.bitmap && self.bitmap.width == @fix_width
        self.bitmap.clear
      else
        size = $fonts.size(@text,@font)
        size.height += @padding*2
        self.bitmap = Bitmap.new(@fixed_width,size.height)
      end
    else
      size = $fonts.size(@text,@font)
      size.width += @padding*2+@indent
      size.height += @padding*2
      self.bitmap = Bitmap.new(size.width,size.height)
    end

    # Draw the text
    x = @padding+@indent
    y = @padding
    w = self.bitmap.width-@padding*2
    h = self.bitmap.height-@padding*2
    self.bitmap.draw_text(x,y,w,h,@text,@align)
    
  end
  
end