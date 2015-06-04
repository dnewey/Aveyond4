#==============================================================================
# Widget_Label
#==============================================================================

class Area < Sprite
  
  # accessors
  attr_accessor :font 
  attr_accessor :fixed_width
  attr_accessor :padding
    
  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def initialize(vp)
    super(vp)

    @font = $fonts.debug

    @text = "Label"

    @padding = 5
    @spacing = 5

    # Required for next lining
    @fixed_width = 250
    
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

  	# Split into lines that fit
  	lines = [""]
  	cx = 0
  	@text.split(" ").each{ |word|
  		w = $fonts.size(word,@font)
  		cx += w.width
  		if cx < @fixed_width
  			lines[-1] += word + ' '
  			cx += @spacing
  		else
  			lines.push(word + ' ')
  			cx = 0
  		end
  	}

  	#log_scr(lines)

  	height = $fonts.size("Happy",@font).height

  	# Build the bitmap now
  	w = @fixed_width
    h = height * lines.count

    self.bitmap = Bitmap.new(w+@padding*2,h+@padding*2)
    self.bitmap.font = @font

    cy = 0
    lines.each{ |line|
    	self.bitmap.draw_text(@padding,@padding+cy,w,height,line)
    	cy += height
    }
    
    
  end
  
end