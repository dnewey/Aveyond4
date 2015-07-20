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



  attr_accessor :type

  attr_accessor :page_idx
  attr_accessor :scroll_idx

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

    @scroll_box = Sprite.new()
    @scroll_box.bitmap = $cache.menu_common('scroll-box')
    @scroll_box.x = 234
    @scroll_box.y = 422
    @scroll_box.z = 5000

    @scroll_down = Button.new()
    @scroll_down.bitmap = $cache.menu_common('scroll-down')
    @scroll_down.x = 239
    @scroll_down.y = 424
    @scroll_down.z = 5000
    @scroll_down.press = Proc.new{ self.scrollbar_down }

    @scroll_up = Button.new()
    @scroll_up.bitmap = $cache.menu_common('scroll-up')
    @scroll_up.x = 262
    @scroll_up.y = 424
    @scroll_up.z = 5000
    @scroll_up.press = Proc.new{ self.scrollbar_up }

    # Setup
    @select_sprite.bitmap = $cache.menu_common('list-bar-on')
    

    @active = true

  end

  def move(x,y)
    @x = x
    @y = y
  end

  def opacity=(o)
    @back_sprite.opacity = o
    @content_sprite.opacity = o
    @select_sprite.opacity = o
    @scroll_box.opacity = 0
    @scroll_down.opacity = 0
    @scroll_up.opacity = 0
  end

  def opacity
    return @back_sprite.opacity
  end

  def dispose
  	@back_sprite.dispose
    @select_sprite.dispose
    @content_sprite.dispose
    @scroll_box.dispose
    @scroll_down.dispose
    @scroll_up.dispose
  end

  def setup(data,idx=0)
    #log_sys(data)
  	@data = data
    # Need an original per page in case less items are given
    # And then aditional items are given
    #@per_page = @data.count if @data.count < @per_page
    #@per_page = 1 if @per_page == 0
    @scroll_idx = 0
    @page_idx = idx
    @select_sprite.y = idx * row_height
    @active = true
  	refresh(false) if !data.empty?
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

  def call_change

        i = idx
        #i -= 1 if !can_scroll?
        @change.call(current) if !@change.nil?

  end

  # When data changes
  def refresh(ch=true)

    @vp.rect = Rect.new(@x,@y,@item_width,row_height*@max_per_page)

    # Draw the background sprite and position it
    rows = [@max_per_page,@data.count].min
    rows += 2 if can_scroll?
    rows = 1 if rows == 0
    height = row_height * rows

    #log_info(rows)

    @back_sprite.bitmap = Bitmap.new(@item_width,height)
    @content_sprite.bitmap = Bitmap.new(@item_width,height)

    @back_sprite.y = can_scroll? ? -row_height : 0
    @content_sprite.y = can_scroll? ? -row_height : 0

    src = $cache.menu_common('list-bar')

    i = 0
    rows.times{ 
      @back_sprite.bitmap.blt(0,i*row_height,src,src.rect)
      # Draw each row
      draw(@data[@scroll_idx + i-1],i) if can_scroll? # -1 makes the first row visible on can scrolls
      draw(@data[@scroll_idx + i],i) if !can_scroll?
      #draw(@data[@scroll_idx + i],i)
      i += 1
    }

    call_change if ch

  end

  # ADD THIS MOUSE CONTROL
  def scrollbar_down
      @page_idx += 1
      scroll_up 
  end

  def scrollbar_up
      @page_idx -= 1
      scroll_down
  end

  def current
    #return @current[0] if @type == :misc
    return @data[idx+1] if can_scroll?
    return @data[idx]
  end

  def draw(data,row)

    #return if data == nil # For above or below accessible

    # Drw the contents
    case @type
      when :item
        draw_item(data,row)
      when :potion
        draw_potion(data,row)
      when :shop
        draw_shop(data,row)
      when :equip
        draw_equip(data,row)
      when :skill
        draw_skill(data,row)
      when :skill_boy
        draw_skill_boy(data,row)
      when :skill_phy
        draw_skill_phy(data,row)
      when :quest
        draw_quest(data,row)
      when :misc
        draw_misc(data,row)
      when :file
        draw_file(data,row)
    end

  end

  def draw_item(data,row)

    item = $data.items[data]

    if item != nil
      name = item.name
      ico = $cache.icon(item.icon)
      number = $party.item_number(data)
    else
      name = "Remove"
      ico = $cache.icon("misc/unknown")
      number = 0
    end
    
    @content_sprite.bitmap.blt(8,(row*row_height)+5,ico,ico.rect)
    @content_sprite.bitmap.font = @font 
    @content_sprite.bitmap.draw_text(18+21,row*row_height,@item_width,@item_height,name,0)
    if number > 0
      @content_sprite.bitmap.draw_text(222+21,row*row_height,@item_width,@item_height,"x"+number.to_s,0)
    end

  end

  def draw_potion(data,row)

    item = $data.potions[data]

    if item != nil
      name = item.name
      ico = $cache.icon("misc/unknown")
      #ico = $cache.icon(item.icon)
    else
      name = "Remove"
      ico = $cache.icon("misc/unknown")
    end
    
    @content_sprite.bitmap.blt(8,(row*row_height)+5,ico,ico.rect)
    @content_sprite.bitmap.font = @font 
    @content_sprite.bitmap.draw_text(18+21,row*row_height,@item_width,@item_height,name,0)

  end

  def draw_shop(data,row)

    item = $data.items[data]

    if item != nil
      name = item.name
      ico = $cache.icon(item.icon)
      price = item.price.to_i
    else
      name = "Remove"
      ico = $cache.icon("misc/unknown")
      price = 0
    end
    
    @content_sprite.bitmap.blt(8,(row*row_height)+5,ico,ico.rect)
    @content_sprite.bitmap.font = @font 
    @content_sprite.bitmap.draw_text(18+21,row*row_height,@item_width,@item_height,name,0)
    if price > 0
      ico = $cache.icon("misc/coins")
      @content_sprite.bitmap.blt(220,(row*row_height)+5,ico,ico.rect)
      @content_sprite.bitmap.draw_text(243,row*row_height,@item_width,@item_height,price.to_s,0)
    end

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

    log_sys(data)

    item = $data.skills[data]

    ico = $cache.icon(item.icon)
    
    @content_sprite.bitmap.blt(8,(row*row_height)+5,ico,ico.rect)
    @content_sprite.bitmap.font = @font 
    @content_sprite.bitmap.draw_text(18+21,row*row_height,@item_width,@item_height,item.name,0)

    # Mana
    ico = $cache.icon("misc/mana")
    @content_sprite.bitmap.blt(220,(row*row_height)+6,ico,ico.rect)
    @content_sprite.bitmap.draw_text(245,row*row_height,@item_width,@item_height,item.cost.to_s,0)

  end

  def draw_skill_boy(data,row)

    item = $data.skills[data]

    ico = $cache.icon(item.icon)
    
    @content_sprite.bitmap.blt(8,(row*row_height)+5,ico,ico.rect)
    @content_sprite.bitmap.font = @font 
    @content_sprite.bitmap.draw_text(18+21,row*row_height,@item_width,@item_height,item.name,0)

    # Mana
    ico = $cache.icon("misc/darkness")
    @content_sprite.bitmap.blt(220,(row*row_height)+6,ico,ico.rect)
    @content_sprite.bitmap.draw_text(245,row*row_height,@item_width,@item_height,item.cost.to_s,0)

  end

  def draw_skill_phy(data,row)

    item = $data.skills[data]

    ico = $cache.icon(item.icon)
    
    @content_sprite.bitmap.blt(8,(row*row_height)+5,ico,ico.rect)
    @content_sprite.bitmap.font = @font 
    @content_sprite.bitmap.draw_text(18+21,row*row_height,@item_width,@item_height,item.name,0)

    # Mana
    ico = $cache.icon("misc/rage")
    @content_sprite.bitmap.blt(220,(row*row_height)+6,ico,ico.rect)
    @content_sprite.bitmap.draw_text(245,row*row_height,@item_width,@item_height,item.cost.to_s,0)

  end

  def draw_quest(data,row)

    item = $data.quests[data]

    ico = $cache.icon('misc/unknown')

    
    @content_sprite.bitmap.blt(8,(row*row_height)+5,ico,ico.rect)
    @content_sprite.bitmap.font = @font 
    @content_sprite.bitmap.draw_text(18+21,row*row_height,@item_width,@item_height,item.name,0)

  end

  def draw_misc(data,row)

    ico = $cache.icon(data[2])
    
    @content_sprite.bitmap.blt(8,(row*row_height)+5,ico,ico.rect)
    @content_sprite.bitmap.font = @font 
    @content_sprite.bitmap.draw_text(18+21,row*row_height,@item_width,@item_height,data[1],0)

  end


  def draw_file(data,row)

    item = $files.headers[data]

    #ico = $cache.icon(item.icon)

    if item == nil
      name = "Save #{data}"
    else
      name = "Save #{item[:progress]}"
    end
    
    #@content_sprite.bitmap.blt(8,(row*row_height)+5,ico,ico.rect)
    @content_sprite.bitmap.font = @font 
    @content_sprite.bitmap.draw_text(18+21,row*row_height,@item_width,@item_height,name,0)

  end


  def update

    @vp.rect.x = @x
    @vp.rect.y = @y

    return if !@active

    @select_sprite.update

    if !$tweens.done?(@back_sprite)

      # Still use up the inputs
      #$input.action? || $input.click? || $input.cancel? || $input.rclick?
      return

    end

    @scroll_down.update
    @scroll_up.update

  	# Check inputs and that
  	if $input.down?

      return if idx >= @data.count - 1

      # If the tweens are going, skip to done
      $tweens.resolve(@back_sprite)
      $tweens.resolve(@content_sprite)
      $tweens.resolve(@select_sprite)

      sys('select')

      # Move the sprite down, but not too far!
      @select_sprite.y += row_height  		
      @page_idx += 1

      if @select_sprite.y > (@per_page-1) * row_height
        @select_sprite.y -= row_height
        @page_idx -= 1
      end

      @select_sprite.flash(Color.new(255,255,255,40),20)
  		
      #if @data.count > @max_per_page

      if can_scroll? && @page_idx >= 6 && @scroll_idx < (@data.count - @max_per_page) #-1 # makes bottom row not visible on can_scroll
        scroll_up
  		else
        i = idx
        #i -= 1 if !can_scroll?
  		  @change.call(current) if !@change.nil?
      end
      

      #@change.call(current) if !@change.nil?

  	end

  	if $input.up? #&& @dynamo.done?

      return if idx <= 0

      # If the tweens are going, skip to done
      $tweens.resolve(@back_sprite)
      $tweens.resolve(@content_sprite)
      $tweens.resolve(@select_sprite)

      sys('select')      
      
      # Move the sprite down
      @select_sprite.y -= row_height
  		@page_idx -= 1

       if @select_sprite.y < 0
        @select_sprite.y += row_height
        @page_idx += 1
      end

      @select_sprite.flash(Color.new(255,255,255,40),20)

  		if can_scroll? && @scroll_idx > 0 && @page_idx <= 1
        scroll_down
      else
        i = idx
        #i -= 1 if !can_scroll?
        @change.call(current) if !@change.nil?
      end
      
      #@change.call(current) if !@change.nil?

  	end

    # Selection


    # Cancel
    if !@cancel.nil? && ($input.cancel? || $input.rclick?)
      @cancel.call(current)
    end

    pos = $mouse.position
    pos[0] -= @x
    pos[1] -= @y

    if !@select.nil? && ($input.action? || ($input.click?&&within?(pos)))
      @select.call(current)
    end

    if within?(pos)
      
      row = pos[1] / row_height
      @select_sprite.y = row * row_height
      @page_idx = row
      @change.call(current) if !@change.nil?
      #sys('select')

    end

  end

  def within?(pos)
    
    return false if pos[0] < 0
    return false if pos[0] > @item_width
    row = pos[1] / row_height
    return false if row < 0
    return false if row >= @per_page
    return false if row >= @data.count
    return false if row == @page_idx
    return true

  end

  def scroll_down
    
    @change.call(current) if !@change.nil?
    
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

     @change.call(current) if !@change.nil?

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
