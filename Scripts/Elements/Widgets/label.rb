#==============================================================================
# Widget_Label
#==============================================================================

class Label < Sprite
  
  # accessors
  attr_accessor :align 
  attr_accessor :font 
  attr_accessor :shadow
  attr_accessor :fixed_width
  attr_accessor :padding

  attr_accessor :gradient

  attr_accessor :icon_oy
    
  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def initialize(vp)
    super(vp)

    @font = $fonts.debug
    @shadow = nil

    @text = "Label"

    @align = 0

    @icon = nil

    @padding = 5

    @icon_oy = 0

    # If there is a width, don't auto size width
    @fixed_width = 0

  end

  def update
    super
    #redraw
  end
  
  #--------------------------------------------------------------------------
  # * Manage
  #--------------------------------------------------------------------------
  def text=(text)
    text = text.to_s
    if @text != text
      @text = text
      refresh
    end
  end

  def icon=(icon)
    @icon = icon
    refresh
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
      size.width += @padding*2
      size.width += 32 if @icon
      size.height += @padding*2
      self.bitmap = Bitmap.new(size.width,size.height)
    end

    self.bitmap.font = @font

    # Draw the icon
    if @icon

      self.bitmap.blt(@padding,(size.height-28)/2+3+@icon_oy,@icon,@icon.rect)

    end

    # Draw the text
    x = @padding
    x += 26 if @icon
    y = @padding
    w = self.bitmap.width-@padding*2
    h = self.bitmap.height-@padding*2
    
    if @shadow
      self.bitmap.font = @shadow
      self.bitmap.draw_text(x+1,y+1,w,h,@text,@align)
    end

    self.bitmap.font = @font
    if @gradient
      self.bitmap.draw_gtext(x,y,w,h,@text,@align)
    else
      self.bitmap.draw_text(x,y,w,h,@text,@align)
    end
        
  end
  
end