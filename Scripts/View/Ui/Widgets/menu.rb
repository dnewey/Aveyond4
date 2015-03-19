#==============================================================================
# Widget_Menu
#==============================================================================

class Widget_Menu < Widget
  
  # accessors
  attr_accessor :align, :font
  attr_accessor :row_height

  attr_accessor :idx

  attr_accessor :on_select
  attr_accessor :on_press
    
  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def create

    @contents = Layer.new(775)

    # Handle input with active or not active, only this and list can have mousing? nothing else shall be made active

     @cursor = @parent.add(Widget.new)
     @cursor.from_menu("cursor")
     @cursor.z = 776#self.z + 1
     @cursor.x = self.x + 50
     @cursor.y = self.y + 44
     #@cursor.do(pingpong("x",10,250,:quad_in_out))

     @idx = 0

     @on_select = nil
     @on_press = nil

  end

  def add(button)
    return @contents.add(button)
  end

  def layout_horiz(x,y,spacing=5)
    cx = x
    @contents.sprites.each{ |s|
      s.x = cx
      s.y = y
      cx += s.width + spacing
    }
  end

  def layout_vert(x,y)
    cy = y
    @contents.sprites.each{ |s|
      s.x = x
      s.y = cy
      cy += s.height + spacing
    }
  end

  def layout_grid(x,y,w)

  end

  def select(idx)
    return if idx < 0
    return if idx > @contents.sprites.count - 1
    @idx = idx
    @cursor.x = @contents.sprites[@idx].x
    @cursor.y = @contents.sprites[@idx].y+40
    @on_select.call if @on_select != nil
  end

  def press()
    @on_press.call
  end

  def update
    super

    @contents.rect.x = self.x 
    @contents.rect.y = self.y  
    #@contents.rect.width = self.width
    #@contents.rect.height = self.height 

    return if !self.active



    # keys
    if key_right?
      select(@idx+1)
    end

    if key_left?
      select(@idx-1)
    end

    if key_enter?
      press
    end

    # Check mouse inputs
    @contents.sprites.each{ |s|
      pos = Mouse.position
      pos[0] -= self.x
      pos[1] -= self.y
      #log_append(pos)
      if s.inside?(pos)
       # log_append("DOIT")
        select(@contents.sprites.index(s))
      end
    }

    # if key_right?
    #   @contents.sprites.each{ |c| 
    #     c.do(go("x",-self.width,700,:quad_out))
    #   }
    # end

    # if key_left?
    #   @contents.sprites.each{ |c| 
    #     c.do(go("x",self.width,700,:quad_out))
    #   }
    # end

  end
    
  def hide
    @contents.sprites.each{ |s| s.hide }
    @cursor.hide
    super
  end

  def show
    @contents.sprites.each{ |s| s.show }
    @cursor.show
    super
  end
  
end