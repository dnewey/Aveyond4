#==============================================================================
# Tabs
#==============================================================================

# Horizontal list of sorts
# Image based only
# Drawn to single sprite

class Page_Tabs < Sprite

  SPACING = 5

  attr_accessor :tab_proc

  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def initialize(vp)
    super(vp)

  	#@parent = nil
    @names = []
  	@gfx = []
    @gfx_on = []

    @ranges = []

  	@idx = 0

    move(20,108)

  end

  def push(name)
    @names.push(name)
    @gfx.push($cache.menu_tab(name))
    @gfx_on.push($cache.menu_tab(name+"-on"))
    refresh
  end

  def refresh

    return if @gfx.empty?

    # Calc width
    width = @gfx.inject(0){ |t,b| t += b.width + SPACING } - SPACING
    height = @gfx[0].height#@gfx.max_by{ |b| b.height }

    self.bitmap = Bitmap.new(width,height)

    # Draw the tabs
    cx = 0
    idx = 0
    @gfx.each{ |b|
      src = b
      src = @gfx_on[idx] if idx == @idx
      self.bitmap.blt(cx,0,src,src.rect)
      cx += b.width + SPACING
      idx += 1
    }

  end

  def update

    return if @names.empty?

  	# Check inputs and that
  	if $input.right?
      @idx += 1
      @tab_proc.call(@tabs[@idx]) if @tab_proc
      refresh      
  	end

  	if $input.left? #&& @dynamo.done?
      @idx -= 1
      @tab_proc.call(@tabs[@idx]) if @tab_proc
      refresh  
  	end

    pos = $mouse.position

    # Check mouseover
    # @sprites.each_index{ |i|
      
    # }

  end

 end