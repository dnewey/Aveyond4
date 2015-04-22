#==============================================================================
# The magical list
#==============================================================================

class List
      
  attr_accessor :x, :y
  attr_accessor :item_width, :item_height
  attr_accessor :item_ox, :item_space

  attr_accessor :select, :change

  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def initialize()

    # Make own viewport
    @vp = Viewport.new(0,0,1000,1000)
    @vp.z = 9999

    @font = Font.new
    @font.name = "Georgia"
    @font.size = 26
    @font.color = Color.new(245,223,200)


    @item_width = 0
    @item_height = 0

    @item_ox = 0
    @item_space = 0

    # Procs
    @select = nil
    @change = nil


  	@x = 0
  	@y = 0

  	@data = []

  	@scroll_idx = 0
  	@page_idx = 0

  	@per_page = 11

  	# Sprites
  	@sprites = []
  	@per_page.times{ |i|
  		@sprites.push(Sprite.new(@vp))
  	}
  	@dynamo = Sprite.new(@vp)

  end

  def dispose
  	@sprites.each{ |s| s.dispose }
  	@dynamo.dispose
  end

  def setup(data)
  	@data = data
    @per_page = @data.count
  	refresh
  end

  def refresh

    @vp.rect = Rect.new(@x,@y,@item_width,@item_space*@per_page)

  	# Rebuild the items from data
  	cy = 0#@y

  	(0..@per_page-1).each{ |i|
  		draw_item(@data[i+@scroll_idx],@sprites[i],i==@page_idx)
      @current = @data[i+@scroll_idx] if i == @page_idx
  		@sprites[i].y = cy
  		@sprites[i].x = 0#@x
      @sprites[i].opacity = 255
  		cy += @item_space
      #@sprites[i].bitmap.height
  	}

  	@cybt = cy

  end

  def scrollbar_down
      if !@dynamo.done?
        refresh
        @page_idx += @pagemod
        @dynamo.opacity = 0
        $tweens.clear_all
      end
      @page_idx += 1;self.refresh; self.scroll_up 
  end

  def scrollbar_up
      if !@dynamo.done?
        refresh
        @page_idx += @pagemod
        @dynamo.opacity = 0
        $tweens.clear_all
      end
      @page_idx -= 1; self.refresh; self.scroll_down
  end

  def draw_item(data,sprite,on)

    # HMMMMMMMMMMMMMMMMMM

  	# DataBox atm
    src = $cache.menu("Common/bartest3")
    src = $cache.menu("Common/bartest4") if on
  	sprite.bitmap = Bitmap.new(src.width,src.height)
    sprite.bitmap.blt(0,0,src,src.rect)
    #Bitmap.new(item_width,item_height)
    #sprite.bitmap.skin($cache.menu("Common/list_inner"))
  	#sprite.bitmap.fill(Color.new(123,123,219)) if on

    sprite.bitmap.font = @font
    return if data.nil?
  	sprite.bitmap.draw_text(0,0,src.width,src.height,data.text,1)

  end

  def update

  	# Check inputs and that
  	if $keyboard.press?(VK_DOWN) #&& @dynamo.done?
      if !@dynamo.done?
        refresh
        @page_idx += @pagemod
        @dynamo.opacity = 0
        $tweens.clear_all
      end
  		@page_idx += 1
  		if @page_idx > 3
        refresh
  			scroll_up
  		else
  		  refresh
      end
  	end

  	if $keyboard.press?(VK_UP) #&& @dynamo.done?
      if !@dynamo.done?
        refresh
        @page_idx += @pagemod
        @dynamo.opacity = 0
        $tweens.clear_all
      end
  		@page_idx -= 1 if @page_idx > 0
  		if @page_idx < 3 && @scroll_idx > 0
        refresh
  			scroll_down
  		else
  		  refresh
      end
  	end

    pos = $mouse.position

    # Check mouseover
    @sprites.each_index{ |i|
      break
      next if pos[0] < @sprites[i].x
      next if pos[1] < @sprites[i].y
      next if pos[0] > @sprites[i].x + @sprites[i].width
      next if pos[1] > @sprites[i].y + @sprites[i].height
      @page_idx = i
      refresh
      break
    }


    # Selection
    if $input.action?
      @select.call(@current.text) if !@select.nil?
    end

  end

  def scroll_down

    @scroll_idx -= 1    
          @pagemod = 1

    # Create the dynamo
    @dynamo.y = 0 - @item_space
    @dynamo.x = 0#@x
    @dynamo.opacity = 205

    dur = 200
    ease = :quad_in_out

    draw_item(@data[@scroll_idx],@dynamo,@page_idx == -1)

    @dynamo.do(go("y",@item_space,dur,ease))
    @dynamo.do(go("opacity",50,dur,ease))

    @dynamo.do(proc(Proc.new{
      @page_idx += 1

      self.refresh
      @dynamo.opacity = 205
    },dur+30))

    @sprites.each{ |s|
      s.do(go("y",@item_space,dur,ease))
    }

    @sprites[-1].do(go("opacity",-50,dur,ease))

  end

  def scroll_up

    @scroll_idx += 1    
          @pagemod = -1

  	# Create the dynamo
  	@dynamo.y = @cybt
  	@dynamo.x = 0#@x
  	@dynamo.opacity = 205

    dur = 200
    ease = :quad_in_out

  	draw_item(@data[@scroll_idx + @per_page - 1],@dynamo,@page_idx == @per_page)

  	@dynamo.do(go("y",-@item_space,dur,ease))
  	@dynamo.do(go("opacity",50,dur,ease))



  	@dynamo.do(proc(Proc.new{

      @page_idx -= 1
      self.refresh
      @dynamo.opacity = 205
    },dur+30))

  	@sprites.each{ |s|
  		s.do(go("y",-@item_space,dur,ease))
  	}

  	@sprites[0].do(go("opacity",-50,dur,ease))

  end

 end