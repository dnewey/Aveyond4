#==============================================================================
# The magical list REDUX
#==============================================================================

class List
      
  attr_accessor :x, :y
  attr_accessor :per_page
  attr_accessor :item_width, :item_height
  attr_accessor :item_ox, :item_space

  attr_accessor :select, :cancel, :change

  attr_accessor :active

  attr_reader :page_idx

  attr_accessor :type

  attr_reader :scroll_idx

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

  	@max_per_page = 8

  	# Sprites
    @back_sprite = Sprite.new(@vp)
    @select_sprite = Sprite.new(@vp)    
    @content_sprite = Sprite.new(@vp)

    # Setup
    @select_sprite.bitmap = $cache.menu_common('list-bar-on')
    

    @active = true

    $debug.track(self,"scroll_idx")

  end

  def move(x,y)
    @x = x
    @y = y
  end

  def opacity=(o)
    @back_sprite.opacity = o
    @content_sprite.opacity = o
    @select_sprite.opacity = o
  end

  def dispose
  	@back_sprite.dispose
    @select_sprite.dispose
    @content_sprite.dispose
  end

  def setup(data)
    log_sys(data)
  	@data = data
    # Need an original per page in case less items are given
    # And then aditional items are given
    #@per_page = @data.count if @data.count < @per_page
    #@per_page = 1 if @per_page == 0
  	refresh
  end

  def idx
    return @scroll_idx + @page_idx
  end

  def row_height
    @item_height + @item_space
  end

  def can_scroll?
    @data.count > @max_per_page
  end

  # When data changes
  def refresh

    @vp.rect = Rect.new(@x,@y,@item_width,row_height*@max_per_page)

    # Draw the background sprite and position it
    rows = [@max_per_page,@data.count].min
    rows += 2 if can_scroll?
    rows = 1 if rows == 0
    height = row_height * rows

    @back_sprite.bitmap = Bitmap.new(@item_width,height)
    @content_sprite.bitmap = Bitmap.new(@item_width,height)

    @back_sprite.y = -row_height if can_scroll?
    @content_sprite.y = -row_height if can_scroll?

    src = $cache.menu_common('list-bar')

    i = 0
    rows.times{ 
      @back_sprite.bitmap.blt(0,i*row_height,src,src.rect)
      # Draw each row
      draw(@data[@scroll_idx + i],i)
      i += 1
    }

  end

  # ADD THIS MOUSE CONTROL
  # def scrollbar_down
  #     if !@dynamo.done?
  #       refresh
  #       @page_idx += @pagemod
  #       @dynamo.opacity = 0
  #       $tweens.clear_all
  #     end
  #     @page_idx += 1;self.refresh; self.scroll_up 
  # end

  # def scrollbar_up
  #     if !@dynamo.done?
  #       refresh
  #       @page_idx += @pagemod
  #       @dynamo.opacity = 0
  #       $tweens.clear_all
  #     end
  #     @page_idx -= 1; self.refresh; self.scroll_down
  # end

  def current
    return @current[0] if @type == :misc
    return @current
  end

  def draw(data,row)

    return if data == nil # For above or below accessible

    # Drw the contents
    case @type
      when :item
        draw_item(data,row)
      when :equip
        draw_equip(data,row)
      when :skill
        draw_skill(data,row)
      when :quest
        draw_quest(data,row)
      when :misc
        draw_misc(data,row)
    end

  end

  def draw_item(data,row)

    item = $data.items[data]

    ico = $cache.icon(item.icon)
    
    @content_sprite.bitmap.blt(8,(row*row_height)+5,ico,ico.rect)
    @content_sprite.bitmap.font = @font 
    @content_sprite.bitmap.draw_text(18+21,row*row_height,@item_width,@item_height,item.name,0)

  end

  def draw_equip(data,row)

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
    
    @content_sprite.bitmap.blt(8,(row*row_height)+5,icon,icon.rect)
    @content_sprite.bitmap.font = @font 
    @content_sprite.bitmap.draw_text(18+21,row*row_height,@item_width,@item_height,item.name,0)

    #sprite.bitmap.font = @font 
    #sprite.bitmap.draw_text(-10,-1,@item_width,@item_height,slot,2)

  end

  def draw_skill(data,row)

    item = $data.skills[data]

    ico = $cache.icon(item.icon)
    
    @content_sprite.bitmap.blt(8,(row*row_height)+5,ico,ico.rect)
    @content_sprite.bitmap.font = @font 
    @content_sprite.bitmap.draw_text(18+21,row*row_height,@item_width,@item_height,item.name,0)

  end

  def draw_quest(data,row)

    item = $data.quests[data]

    ico = $cache.icon('items/map')
    
    sprite.bitmap.blt(8,5,ico,ico.rect)
    sprite.bitmap.font = @font 
    sprite.bitmap.draw_text(18+21,-1,@item_width,@item_height,item.name,0)

  end

  def draw_misc(data,row)

    ico = $cache.icon(data[1])
    
    sprite.bitmap.blt(8,5,ico,ico.rect)
    sprite.bitmap.font = @font 
    sprite.bitmap.draw_text(18+21,-1,@item_width,@item_height,data[0],0)

  end







  def update

    @vp.rect.x = @x
    @vp.rect.y = @y

    return if !@active

    return if !$tweens.done?(@back_sprite)

  	# Check inputs and that
  	if $keyboard.press?(VK_DOWN)

      return if idx >= @data.count - 2

      # If the tweens are going, skip to done
      $tweens.resolve(@back_sprite)
      $tweens.resolve(@content_sprite)
      $tweens.resolve(@select_sprite)

      sys('select')

      # Move the sprite down
      @select_sprite.y += row_height
  		
      @page_idx += 1
  		
      #if @data.count > @max_per_page

      if can_scroll? && @page_idx == 5 && @scroll_idx < (@data.count - @max_per_page) -1
        scroll_up
  		#else
  		 # refresh
      end
      
      #@change.call(current) if !@change.nil?

  	end

  	if $keyboard.press?(VK_UP) #&& @dynamo.done?

      return if idx <= 0

      # If the tweens are going, skip to done
      $tweens.resolve(@back_sprite)
      $tweens.resolve(@content_sprite)
      $tweens.resolve(@select_sprite)

      sys('select')      
      
      # Move the sprite down
      @select_sprite.y -= row_height

  		@page_idx -= 1

  		if can_scroll? && @scroll_idx > 0 && @page_idx == 3
        scroll_down
      end
      
      #@change.call(current) if !@change.nil?

  	end

    # pos = $mouse.position
    # pos[0] -= @x
    # pos[1] -= @y
    # if pos[0] < @item_width
    #   row = pos[1] / row_height
    #   @select_sprite.y = row * row_height
    #   sys('select')
    # end

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

    
    @scroll_idx -= 1    
    #      @pagemod = 1


    dur = 180
    ease = :quad_in_out

    @back_sprite.do(go("y",row_height,dur,ease))
    @content_sprite.do(go("y",row_height,dur,ease))
    @select_sprite.do(go("y",row_height,dur,ease))

    @back_sprite.do(proc(Proc.new{
      @page_idx += 1
      refresh

    },dur+1))

  end

  def scroll_up

    @scroll_idx += 1    
          #@pagemod = -1

    dur = 180
    ease = :quad_in_out

  	#draw_item(@data[@scroll_idx + @per_page-1],@dynamo,@page_idx == @per_page)

  	@back_sprite.do(go("y",-row_height,dur,ease))
    @content_sprite.do(go("y",-row_height,dur,ease))
    @select_sprite.do(go("y",-row_height,dur,ease))

  	@back_sprite.do(proc(Proc.new{

      @page_idx -= 1
      refresh
      

    },dur+1))

  end

 end
