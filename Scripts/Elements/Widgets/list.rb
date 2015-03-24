#==============================================================================
# The magical list
#==============================================================================

# Draw item depends on type, ItemData, WeaponData etc
# All action external to the list

# Scrollbar is part of list?
# Made up of multiple sprites

# All items are predrawn to sprites, for scrollings?
# But what of a really big list?

# Ok hmmmm, draw the sprites when wanted

class List
      
  attr_accessor :x, :y

  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def initialize(vp)

  	@parent = nil

  	@x = 0
  	@y = 0

  	@data = []

  	@scroll_idx = 0
  	@page_idx = 0

  	@per_page = 7

  	# Sprites
  	@sprites = []
  	@per_page.times{ |i|
  		@sprites.push(Sprite.new(vp))
  	}
  	@dynamo = Sprite.new(vp)

  	@scroll_base = Sprite.new(vp)

  	@scroll_up = Button.new(vp)

  	@scroll_down = Button.new(vp)

  	@scroll_btn = Sprite.new(vp)

  end

  def dispose
  	@sprites.each{ |s| s.dispose }
  	@dynamo.dispose
  	@scroll_base.dispose
  	@scroll_up.dispose
  	@scroll_down.dispose
  	@scroll_btn.dispose
  end

  def setup(data)
  	@data = data
  	refresh
  end

  def refresh

  	# Rebuild the items from data
  	cy = @y

  	(0..@per_page-1).each{ |i|
  		draw_item(@data[i+@scroll_idx],@sprites[i],i==@page_idx)
  		@sprites[i].y = cy
  		@sprites[i].x = @x
      @sprites[i].opacity = 255
  		cy += @sprites[i].bitmap.height
  	}

  	@cybt = cy

  	# The scrollbar
  	@scroll_base.bitmap = Bitmap.new(14,300)
  	@scroll_base.bitmap.vert(Cache.menu("scrollbar"))

  	@scroll_up.bitmap = Cache.menu("scrollup")
  	@scroll_down.bitmap = Cache.menu("scrolldown")

    @scroll_up.press = Proc.new{ 

    if !@dynamo.done?
        refresh
        @page_idx += @pagemod
        @dynamo.opacity = 0
        $tweens.clear_all
      end
      @page_idx -= 1; self.refresh; self.scroll_down }
    @scroll_down.press = Proc.new{ 
      if !@dynamo.done?
        refresh
        @page_idx += @pagemod
        @dynamo.opacity = 0
        $tweens.clear_all
      end
      @page_idx += 1;self.refresh; self.scroll_up 
    }

  	@scroll_btn.bitmap = Cache.menu("scrollbtn")

  	# POSITION THOSE ^^^^^^^^^

        @scroll_base.x = @x - 20
    @scroll_base.y = @y + 10

        @scroll_up.x = @x-30
    @scroll_up.y = @y - 15

        @scroll_down.x = @x-30
    @scroll_down.y = @y +300

  	# Show selected, a sprite behind hmmmm, 

  end

  def draw_item(data,sprite,on)

  	# DataBox atm
  	sprite.bitmap = Bitmap.new(300,30)
  	sprite.bitmap.fill(Color.new(123,123,219)) if on
  	sprite.bitmap.draw_text(0,0,300,30,data.name)

  end

  def update

    @scroll_up.update
    @scroll_down.update

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
      next if pos[0] < @sprites[i].x
      next if pos[1] < @sprites[i].y
      next if pos[0] > @sprites[i].x + @sprites[i].width
      next if pos[1] > @sprites[i].y + @sprites[i].height
      @page_idx = i
      refresh
      break
    }

  end

  def scroll_down

    @scroll_idx -= 1    
          @pagemod = 1

    # Create the dynamo
    @dynamo.y = @y - 30
    @dynamo.x = @x
    @dynamo.opacity = 0

    dur = 200
    ease = :quad_in_out

    draw_item(@data[@scroll_idx],@dynamo,@page_idx == -1)

    @dynamo.do(go("y",30,dur,ease))
    @dynamo.do(go("opacity",255,dur,ease))

    @dynamo.do(proc(Proc.new{
      @page_idx += 1

      self.refresh
      @dynamo.opacity = 0
    },dur+30))

    @sprites.each{ |s|
      s.do(go("y",30,dur,ease))
    }

    @sprites[-1].do(go("opacity",-255,dur,ease))

  end

  def scroll_up

    @scroll_idx += 1    
          @pagemod = -1

  	# Create the dynamo
  	@dynamo.y = @cybt
  	@dynamo.x = @x
  	@dynamo.opacity = 0

    dur = 200
    ease = :quad_in_out

  	draw_item(@data[@scroll_idx + @per_page - 1],@dynamo,@page_idx == @per_page)

  	@dynamo.do(go("y",-30,dur,ease))
  	@dynamo.do(go("opacity",255,dur,ease))



  	@dynamo.do(proc(Proc.new{

      @page_idx -= 1
      self.refresh
      @dynamo.opacity = 0
    },dur+30))

  	@sprites.each{ |s|
  		s.do(go("y",-30,dur,ease))
  	}

  	@sprites[0].do(go("opacity",-255,dur,ease))

  end

 end