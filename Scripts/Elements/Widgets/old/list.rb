#==============================================================================
# Widget_Label
#==============================================================================

class Widget_List < Widget
  
  # accessors
  attr_accessor :align, :font
  attr_accessor :row_height
    
  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def create

    @contents = Layer.new(775)

    @data = []

    @font = Fonts.get("textbox")

    @pointer = Sprite.new()
      
    @rows = 7
    @row_height = 25
    
    @padding = Bounds.new

     @title = @parent.add(Widget_Label.new)
     @title.text = "Items"
     @title.skin = 'skin-red'
     @title.link(self,-22,-22)
     @title.z += 1
     @title.font = Fonts.get('title')
     @title.refresh

     @idx = 0
     @page = 0

     # Cursor needs to be a sibling as does title
     @cursor = @parent.add(Widget.new)
     @cursor.from_menu("cursor")
     @cursor.z = self.z + 1
     @cursor.x = self.x + 5
     @cursor.do(pingpong("x",10,250,:quad_in_out))

  end

  def padding=(padding)
    @padding.left = padding[0]
    @padding.top = padding[1]
    @padding.right = padding[2]
    @padding.bottom = padding[3]
  end

  def update
    super

#    log_append 'update'
    # get rid of?
    @contents.rect.x = self.x 
    @contents.rect.y = self.y  
    @contents.rect.width = self.width
    @contents.rect.height = self.height 

    return if !self.active

    # keys
    if key_down?
      @idx += 1
    end

    if key_up?
      @idx -= 1
    end

    if key_right?
      @contents.sprites.each{ |c| 
        c.do(go("x",-self.width,700,:quad_out))
      }
    end

    if key_left?
      @contents.sprites.each{ |c| 
        c.do(go("x",self.width,700,:quad_out))
      }
    end

    #- @cursor.width
    @cursor.y = self.y + @padding.top + (@idx * @row_height)
    
  end
    
  #--------------------------------------------------------------------------
  # * Redraw
  #--------------------------------------------------------------------------
  def refresh

    @contents.clear

    self.height = (@row_height * @rows) + @padding.top + @padding.bottom
  
    self.from_skin('skin-white',5)

    @data = [1,1,1,1,1,11,1,1,1,1,1,1,1,1,1,1,1,1,1]

    @contents.rect.x = self.x 
    @contents.rect.y = self.y  
    @contents.rect.width = self.width
    @contents.rect.height = self.height


    # Draw offset rows
    (0..@rows).step(2).each{ |r|
      #next if r % 2 == 0
      self.bitmap.fill_rect(0,@padding.top+@row_height*r,self.width,@row_height,Color.random)
      #fill_rect(x, y, width, height, color) 
    }

    # Creating them labels
    row = 0
    col = 0
    @data.each{ |item| 

      lbl = @contents.add(Widget_Label.new)
      lbl.text = "Item " + ((col * @rows)+row).to_s
      lbl.x = 20
      lbl.y = @padding.top + (row * @row_height) - 3
      lbl.width = self.width - @padding.left - @padding.right
      lbl.fix_width = self.width - @padding.left - @padding.right
      lbl.height = self.height - @padding.top - @padding.bottom
      lbl.refresh

      row += 1
      if row > @rows
        row = 0
        col += 1
      end

      lbl.x = 20 + (self.width * col)


    }

    
  end

  def hide
    @contents.sprites.each{ |s| s.hide }
    @cursor.hide
    @title.hide
    super
  end

  def show
    @contents.sprites.each{ |s| s.show }
    @cursor.show
    @title.show
    super
  end
  
end