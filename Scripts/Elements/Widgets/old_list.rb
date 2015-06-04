#==============================================================================
# The magical list
#==============================================================================

class OLDList
      
  attr_accessor :x, :y
  attr_accessor :per_page
  attr_accessor :item_width, :item_height
  attr_accessor :item_ox, :item_space

  attr_accessor :select, :cancel, :change

  attr_accessor :active

  attr_reader :page_idx

  attr_accessor :type

  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def initialize() 

    # Make own viewport
    @vp = Viewport.new(0,0,1000,1000)
    @vp.z = 4500

    @font = Font.new
    @font.name = "Verdana"
    @font.size = 20 #was 26
    @font.color = Color.new(245,223,200)


    @item_width = 0
    @item_height = 0

    @item_ox = 0
    @item_space = 0

    # Procs
    @select = nil
    @cancel = nil
    @change = nil

  	@x = 0
  	@y = 0

    @type = :item
  	@data = []

  	@scroll_idx = 0
  	@page_idx = 0

  	@per_page = 8

  	# Sprites

    @dynamo = Sprite.new(@vp)
    
  	@sprites = []
  	@per_page.times{ |i|
  		@sprites.push(Sprite.new(@vp))
  	}

  	

    @active = true

  end

  def move(x,y)
    @x = x
    @y = y
  end

  def opacity=(o)
    @sprites.each{ |s|
      s.opacity = o
    }
    @dynamo.opacity = o
  end

  def dispose
  	@sprites.each{ |s| s.dispose }
  	@dynamo.dispose
  end

  def setup(data)
    log_sys(data)
  	@data = data
    # Need an original per page in case less items are given
    # And then aditional items are given
    #@per_page = @data.count if @data.count < @per_page
    @per_page = 1 if @per_page == 0
  	refresh
  end

  def idx
    return @scroll_idx + @page_idx
  end

  def refresh
    return if @dynamo.disposed?

    @vp.rect = Rect.new(@x,@y,@item_width,@item_space*@per_page)

  	# Rebuild the items from data
  	cy = 0#@y

    if !@data.empty?
    	(0..@per_page-1).each{ |i|
        next if @sprites[i] == nil
    		draw(@data[i+@scroll_idx],@sprites[i],i==@page_idx)
        @current = @data[i+@scroll_idx] if i == @page_idx
    		@sprites[i].y = cy
    		@sprites[i].x = 0#@x
        @sprites[i].opacity = 255
    		cy += @item_space
        #@sprites[i].bitmap.height
    	}
    end

  	@cybt = cy


    # If empty, draw dynamo as "Nothing here"
    if @data.empty?
      @dynamo.bitmap = Bitmap.new(@item_width,@item_height)
      @dynamo.bitmap.font = @font
      @dynamo.bitmap.draw_text(0,0,@item_width,@item_height,"Sorry, no items",1)
      #@dynamo.bitmap.draw_text(0,0,100,40,"Nothing",2)
      @dynamo.x = 0
      @dynamo.y = 0
      @dynamo.opacity = 150
    end

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

  def current
    return @current[0] if @type == :misc
    return @current
  end

  def draw(data,sprite,on)

    return if sprite == nil
    sprite.bitmap.clear if sprite.bitmap != nil

  	# Draw the base
    src = $cache.menu("Common/bartest3")
    src = $cache.menu("Common/bartest4") if on
  	sprite.bitmap = Bitmap.new(src.width,src.height)
    sprite.bitmap.blt(0,0,src,src.rect)

    #return if data == nil

    # Drw the contents
    case @type
      when :item
        draw_item(data,sprite,on)
      when :equip
        draw_equip(data,sprite,on)
      when :skill
        draw_skill(data,sprite,on)
      when :quest
        draw_quest(data,sprite,on)
      when :misc
        draw_misc(data,sprite,on)
    end

  end

  def draw_item(data,sprite,on)

    #return if $data.items.has_key?(data)

    return if data == nil

    item = $data.items[data]

    ico = $cache.icon(item.icon)
    
    sprite.bitmap.blt(8,5,ico,ico.rect)
    sprite.bitmap.font = @font 
    sprite.bitmap.draw_text(18+21,-1,@item_width,@item_height,item.name,0)

  end

  def draw_equip(data,sprite,on)

    if data == nil
      icon =  $cache.icon("misc/unknown")
      name = "Nothing"
      slot = "NONE"
    else
      item = $data.items[data]
      name = item.name
      icon =  $cache.icon(item.icon)
      slot = item.slot
    end
    
    sprite.bitmap.blt(8,5,icon,icon.rect)
    sprite.bitmap.font = @font 
    sprite.bitmap.draw_text(18+21,-1,@item_width,@item_height,name,0)

    sprite.bitmap.font = @font 
    sprite.bitmap.draw_text(-10,-1,@item_width,@item_height,slot,2)

  end

  def draw_skill(data,sprite,on)

    return if data == nil

    #log_info(data)

    item = $data.skills[data]

    ico = $cache.icon(item.icon)
    
    sprite.bitmap.blt(8,5,ico,ico.rect)
    sprite.bitmap.font = @font 
    sprite.bitmap.draw_text(18+21,-1,@item_width,@item_height,item.name,0)

  end

  def draw_quest(data,sprite,on)

    item = $data.quests[data]

    ico = $cache.icon('items/map')
    
    sprite.bitmap.blt(8,5,ico,ico.rect)
    sprite.bitmap.font = @font 
    sprite.bitmap.draw_text(18+21,-1,@item_width,@item_height,item.name,0)

  end

  def draw_misc(data,sprite,on)

    ico = $cache.icon(data[1])
    
    sprite.bitmap.blt(8,5,ico,ico.rect)
    sprite.bitmap.font = @font 
    sprite.bitmap.draw_text(18+21,-1,@item_width,@item_height,data[0],0)

  end

  def update

    @vp.rect.x = @x
    @vp.rect.y = @y

    return if !@active

  	# Check inputs and that
  	if $keyboard.press?(VK_DOWN) #&& @dynamo.done?

      return if @page_idx + @scroll_idx >= @data.count - 1

      sys('select')

      if !@dynamo.done?
        refresh
        @page_idx += @pagemod
        @dynamo.opacity = 0
        $tweens.clear_all
      end
  		@page_idx += 1
  		if @data.count > @per_page && @page_idx > 3
        refresh
  			scroll_up
  		else
  		  refresh
      end
      @change.call(current) if !@change.nil?
  	end

  	if $keyboard.press?(VK_UP) #&& @dynamo.done?

      sys('select')
      
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
      @change.call(current) if !@change.nil?
  	end

    pos = $mouse.position
    pos[0] -= @x
    pos[1] -= @y

    # Check mouseover
    @sprites.each_index{ |i|
      next if @page_idx == i
      next if @sprites[i] == nil
      next if @sprites[i].bitmap == nil
      next if pos[0] < @sprites[i].x
      next if pos[1] < @sprites[i].y
      next if pos[0] > @sprites[i].x + @sprites[i].width
      next if pos[1] > @sprites[i].y + @sprites[i].height
      sys('select')
      @page_idx = i
      refresh
      break
    }


    # Selection
    if !@select.nil? && ($input.action? || $input.click?)
      @select.call(current)
    end

    # Cancel
    if !@cancel.nil? && ($input.cancel? || $input.rclick?)
      sys('cancel')
      @cancel.call(current)
    end

  end

  def scroll_down

    @dynamo.bitmap.clear

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

    @dynamo.bitmap.clear

    @scroll_idx += 1    
          @pagemod = -1

  	# Create the dynamo
  	@dynamo.y = @cybt
  	@dynamo.x = 0#@x
  	@dynamo.opacity = 205

    dur = 200
    ease = :quad_in_out

  	draw_item(@data[@scroll_idx + @per_page-1],@dynamo,@page_idx == @per_page)

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
