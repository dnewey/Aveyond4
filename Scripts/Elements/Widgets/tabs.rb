#==============================================================================
# Tabs
#==============================================================================

# Horizontal list of sorts
# Image based only
# Drawn to single sprite

class Tabs < Sprite

  SPACING = 5

  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def initialize(vp)
    super(vp)

  	#@parent = nil
    @names = []
  	@gfx = []

    @ranges = []

  	@tab_idx = 0

  end

  def push(name,gfx)
    @names.push(name)
    @gfx.push($cache.menu(gfx))
    refresh
  end

  def dispose
  	
  end

  def refresh

    # Calc width
    width = @gfx.inject(0){ |t,b| t += b.width + SPACING } - SPACING
    height = @gfx[0].height#@gfx.max_by{ |b| b.height }

    self.bitmap = Bitmap.new(width,height)

    # Draw the tabs
    cx = 0
    @gfx.each{ |b|
      self.bitmap.blt(cx,0,b,b.rect)
      cx += b.width + SPACING
    }

  end

  def update

  	# Check inputs and that
  	if $keyboard.press?(VK_RIGHT)
      @idx += 1
      refresh      
  	end

  	if $keyboard.press?(VK_LEFT) #&& @dynamo.done?
      @idx -= 1
      refresh  
  	end

    pos = $mouse.position

    # Check mouseover
    # @sprites.each_index{ |i|
      
    # }

  end

 end