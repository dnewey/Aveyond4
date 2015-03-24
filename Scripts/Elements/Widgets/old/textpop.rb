#==============================================================================
# ** Dan Message Box
#==============================================================================

class Sprite_Textpop < Widget
  
  attr_accessor :event

  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def initialize(text,ev,vp,style)
    super(vp)    
    
    self.set_zy(0.0)
    self.set_zx(0.0)
    
    @event = ev

    @dead = false
    @state = :opening
    @wait_frames = 0
    @counter = 120
    
    # Create the graphic here, then zoom it in? 
    bmp = Bitmap.new(500,68)
    bmp.font = Fonts.get("white_reg")
    width = bmp.text_size(text).width
    
    width = [96,width+33].max
    
    self.set_width(width)
    self.set_height(68)
    
    self.slide_zy(1.0)
    self.slide_zx(1.0)
    
    o = 255
    
    
    # position but fix tail
    x = ev.screen_x+6
    y = ev.screen_y-50
        
    off = 0
    if x + width/2 > 544
      newx = 544 - width/2
      off = x-newx
      x = newx
    end
    if x <width/2
      newx = width/2+4
      off = x-newx
      x = newx
    end
    
    
    # fill with guy!!!!  
    if style == :normal
      src = Cache.menu("poptext")
    else
      src = Cache.menu("poptextsign")
    end
    bmp.blt(0,0,src,Rect.new(0,0,32,46),o) # top left
    bmp.blt(width-32,0,src,Rect.new(64,0,32,46),o) # top right
    
    bmp.stretch_blt(Rect.new(32,0,width-64,46),src,Rect.new(32,0,32,46),o)
    
    if style == :normal
    tail = Cache.menu("poptail")
    bmp.blt(width/2-16+off,33,tail,tail.rect)
    end
    bmp.draw_text(0,1,width,40,text,1)
    

    #self.set_xy(100,50)
    self.set_xy(x,y)

    # prep all gfx
    #@bg_gfx = Cache.menu('Text\chat_box_white_a')
    self.bitmap = bmp

  end
  
  def die() @counter = 0 end
  def dead?() return @dead end

  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose
    super
  end

  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    
    # Update position
    self.set_y(@event.screen_y-50)
    
    # Update state

    case @state

      when :opening
        #@opacity += @open_speed
        (@state = :texting;) if self.zoom_y == 1.0
      when :closing
        if self.zoom_y == 0.0
          @dead = true
        end
      when :texting
        @counter -= 1
        if @counter <= 0
          self.slide_zy(0)
          self.slide_zx(0)
          @state = :closing
        end
    end

    # skipping
    #while @state == :texting && @skip_all
    #  @next_char > 0 ? @next_char -= 1 : update_message
    #end

  end

end
