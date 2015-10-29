#==============================================================================
# Tabs
#==============================================================================

class Page_Tabs < Sprite

  SPACING = 0

  attr_accessor :change

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

    @total_width = 0

    # Proc
    @change = nil

    move(116,78)

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

    @ranges = []

    # Draw the tabs
    cx = 0
    idx = 0
    @gfx.each{ |b|
      src = b
      src = @gfx_on[idx] if idx == @idx
      self.bitmap.blt(cx,0,src,src.rect)
      @ranges.push([cx,cx+b.width])
      cx += b.width + SPACING
      idx += 1
    }

    @total_width = cx

  end

  def update

    return if @names.empty?

  	# Check inputs and that
  	if $input.right?
      @idx += 1
      if @idx > @names.count - 1
        @idx = @names.count - 1
        return
      end
      change_tab
      refresh      
  	end

  	if $input.left? #&& @dynamo.done?
      @idx -= 1
      if @idx < 0
        @idx = 0
        return
      end
      change_tab
      refresh  
  	end

    pos = $mouse.position.dup

    #return if pos[0] > @total_width
    return if pos[0] < self.x

    pos[0] -= self.x



    # Check mouseover
    @ranges.each_index{ |i|

      next if i == @idx

      range = @ranges[i]

      next if pos[1] < self.y
      next if pos[1] > self.y + 20

      next if pos[0] < range[0]
      next if pos[0] > range[1]

      if $input.click?

        @idx = i
        change_tab
        refresh  

      end
      
    }

  end

  def change_tab
    sys('tab')
    @change.call(@names[@idx]) if @change
  end

 end