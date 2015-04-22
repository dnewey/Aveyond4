#==============================================================================
# Extended Sprite Class
#==============================================================================

class Widget < Sprite
    
  attr_accessor :width, :height, :parent, :active
  
  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def initialize()
    super()
    
    @width = 150
    @height = 100

    @parent = nil

    @dead = false

    @active = false

    @link_target = nil
    @link_ox = 0
    @link_oy = 0

  end

  def create
    # TO OVERWRITE!!!!!!!!
  end

  def activate
    @active = true
  end

  def deactivate
    @active = false
  end

  def resize(w,h)
    @width = w
    @height = h
  end

  def link(target,ox,oy)
    @link_target = target
    @link_ox = ox
    @link_oy = oy
  end

  def autosize
    self.width = self.bitmap.width
    self.height = self.bitmap.height
  end

  def snap_bottom
    self.y = 416 - self.height
  end

  def update
    super
    if @link_target != nil
      self.x = @link_target.x + @link_ox
      self.y = @link_target.y + @link_oy
    end
  end


  def inside?(pos)
    return false if pos[0] < self.x
    return false if pos[1] < self.y
    return false if pos[0] > self.x + self.width
    return false if pos[1] > self.y + self.height
    return true
  end

  #--------------------------------------------------------------------------
  # * Manage
  #--------------------------------------------------------------------------

  # visible or not
  def hide() self.visible = false end
  def show() self.visible = true end
    
  #--------------------------------------------------------------------------
  # * Ready to remove
  #--------------------------------------------------------------------------
  def kill() @dead = true end
  def dead?() return @dead end

    #--------------------------------------------------------------------------
  # * Manage
  #--------------------------------------------------------------------------
  def from_menu(src) self.bitmap = $cache.menu(src) end
  def from_menu_frame(src,frame) self.bitmap = $cache.menu_frame(src,frame) end
  def from_bitmap(bmp) self.bitmap = bmp end  
  def from_icon(idx,double=false) self.bitmap = $cache.icon(idx,double) end  
  def from_stroke_icon(idx,double=false) self.bitmap = $cache.stroke_icon(idx,double) end
    
  # Stretch out
  def from_menu_stretch(src,width,height)
    self.bitmap = Bitmap.new(width,height)
    img = $cache.menu(src)
    self.bitmap.stretch_blt(Rect.new(0,0,width,height),img,img.rect)
  end
  
  def from_skin(src,shadow=5)

    #    shadow = self.get_skin('skin-shadow')
    #white = self.get_skin('skin-white')

    #self.bitmap = Bitmap.new(self.width + 5,self.height+5)
    #self.bitmap.blt(5,5,shadow,shadow.rect,120)
    #self.bitmap.blt(0,0,white,white.rect)

    width = @width
    height = @height

    self.bitmap = Bitmap.new(width+shadow,height+shadow)
    src = $cache.menu(src)

    ssrc = $cache.menu('skin-shadow')

    w = src.width/3
    h = src.height/3

    sx = 0
    sy = 0
    o = 140


    # shadowwwwwww
    self.bitmap.blt(0+shadow,height-h+shadow,ssrc,Rect.new(sx,sy+40,w,h),o) # bottom left
    self.bitmap.blt(width-w+shadow,0+shadow,ssrc,Rect.new(sx+40,sy,w,h),o) # top right
    self.bitmap.blt(width-w+shadow,height-h+shadow,ssrc,Rect.new(sx+40,sy+40,w,h),o) # bottom right
     self.bitmap.stretch_blt(Rect.new(width-w+shadow,h+shadow,w,height-40),ssrc,Rect.new(w*2,h,w,h),o)
    self.bitmap.stretch_blt(Rect.new(w+shadow,height-h+shadow,width-40,h),ssrc,Rect.new(w,h*2,w,h),o)

  o = 255

    # CORNERS
    self.bitmap.blt(0,0,src,Rect.new(sx,sy,w,h),o) # top left
    self.bitmap.blt(width-w,0,src,Rect.new(sx+40,sy,w,h),o) # top right
    self.bitmap.blt(0,height-h,src,Rect.new(sx,sy+40,w,h),o) # bottom left
    self.bitmap.blt(width-w,height-h,src,Rect.new(sx+40,sy+40,w,h),o) # bottom right
    
    #dest_rect, bmp, src_rect

    # Middle
    self.bitmap.stretch_blt(Rect.new(w,h,width-40,height-40),src,Rect.new(w,h,w,h),o)

    # left side
    self.bitmap.stretch_blt(Rect.new(0,h,w,height-40),src,Rect.new(0,h,w,h),o)

    # Right
    self.bitmap.stretch_blt(Rect.new(width-w,h,w,height-40),src,Rect.new(w*2,h,w,h),o)

    #top
    self.bitmap.stretch_blt(Rect.new(w,0,width-40,h),src,Rect.new(w,0,w,h),o)

   #bottom
    self.bitmap.stretch_blt(Rect.new(w,height-h,width-40,h),src,Rect.new(w,h*2,w,h),o)


    #self.bitmap.stretch_blt(Rect.new(0,w,width,height-40),src,Rect.new(sx+w,sy+h,w,h),o)
    #self.bitmap.stretch_blt(Rect.new(w,0,width-40,h),src,Rect.new(sx+w,sy+h,w,h),o)
    #self.bitmap.stretch_blt(Rect.new(w,height-h,width-40,h),src,Rect.new(sx+w,sy+h,w,h),o)
    
  end

  # Character img
  def from_char(img,idx,dir,zoom=1.0,p=1)
    #p img,idx
    zoom = 2.0 if zoom == true
    zoom = 1.0 if zoom == false
    self.bitmap = $cache.char_frame(img,idx,dir,zoom,p)
  end
  
  def from_spr(src)

    dir = 2
    
    if src.bitmap.width < 100
      cw = src.bitmap.width / 3
      ch = src.bitmap.height / 4
    else
      cw = src.bitmap.width / 12
      ch = src.bitmap.height / 8
    end
    #n = idx
    n = src.character.character_index
    p=1
    src_rect = Rect.new((n%4*3+p)*cw, (n/4*4+((dir/2)-1))*ch, cw, ch)
    #if double
      dest_rect = Rect.new(0,0,cw*2,ch*2)
    #else
    #  dest_rect = Rect.new(0,0,cw,ch)
   #end
    bmp = Bitmap.new(dest_rect.width,dest_rect.height)
    bmp.stretch_blt(dest_rect,src.bitmap,src_rect)
        
    self.bitmap = bmp
    #self.src_rect = src.src_rect
  end
  
  # Color box
  def from_color(c)
    self.bitmap = Bitmap.new(self.width,self.height)
    self.bitmap.fill_rect(0,0,self.width,self.height,c)
  end  
  
  # From numbers for bottom bar etc
  def from_numbers(num,color,percent=false)
    
    # Auto coloring depending on number out of 100
    if color == :auto
      
      color = :red
      color = :orange if num > 20
      color = :yellow if num > 40
      color = :green if num > 60
      
    end
    
    # prepare number data
    anums = num.to_i.to_s.split(//)
    nums = []
    anums.each{ |n| nums.push(n.to_i) }

    # build the gfx of this number
    src = $cache.menu('Bar/numbers.12.7')
    cw = src.width/12
    ch = src.height/7

    # Colors
    colors = [:red,:blue,:yellow,:green,:white,:purple,:orange]
    ic = colors.find_index(color)
    
    # prepare the final image
    width = 0
    nums.each{ |n| width+=cw }
    bmp = Bitmap.new(width+20,ch)
    c = 0

    nums.each{ |n|

      s = n * cw

      bmp.blt(c,0,src,Rect.new(s,ic*ch,cw,ch))
      c += cw*0.45

    }
    if percent
      
      c+=cw*0.2
      n=10
      s = n * cw
      bmp.blt(c,0,src,Rect.new(s,ic*ch,cw,ch))
      
    end
    
    
    self.bitmap = bmp
    
  end
  
  def from_numbers_right(num,color,percent=false)
    
    # Auto coloring depending on number out of 100
    if color == :auto
      
      color = :red
      color = :orange if num > 20
      color = :yellow if num > 40
      color = :green if num > 60
      
    end
    
    # prepare number data
    anums = num.to_i.to_s.split(//)
    nums = []
    anums.each{ |n| nums.push(n.to_i) }

    # build the gfx of this number
    src = $cache.menu('Bar/numbers.12.7')
    cw = src.width/12
    ch = src.height/7

    # Colors
    colors = [:red,:blue,:yellow,:green,:white,:purple,:orange]
    ic = colors.find_index(color)
    
    # prepare the final image
    width = 0
    nums.each{ |n| width+=cw }
    bmp = Bitmap.new(width+20,ch)
    c = 0

    nums.each{ |n|

      s = n * cw

      bmp.blt(c,0,src,Rect.new(s,ic*ch,cw,ch))
      c += cw*0.45

    }    
    
    #copy to new bitmap
    c+=8
    final = Bitmap.new(c,ch)
    final.blt(0,0,bmp,bmp.rect)
    
    self.bitmap = final
    
  end
  
  # From Big Numbers
  def from_big_numbers(num)
    
    # prepare number data
    anums = num.to_i.to_s.split(//)
    nums = []
    anums.each{ |n| nums.push(n.to_i) }

    # build the gfx of this number
    src = $cache.menu('level_nums.10.1')
    cw = src.width/10
    ch = src.height
    
    # prepare the final image
    width = 0
    nums.each{ |n| width+=cw }
    bmp = Bitmap.new(width+10,ch)
    c = 0

    nums.each{ |n|

      s = n * cw

      bmp.blt(c,0,src,Rect.new(s,0,cw,ch))
      c += cw*0.8

    }  
    
    self.bitmap = bmp
    
  end
  
    # From numbers for bottom bar etc
  def from_meganums(num)
    
    # prepare number data
    anums = num.to_i.to_s.split(//)
    nums = []
    anums.each{ |n| nums.push(n.to_i) }

    # build the gfx of this number
    
    
    # prepare the final image
    width = 0
    nums.each{ |n| 
      width += 50 if n == 1
      width+=100 if n != 1
    }
    bmp = Bitmap.new(width,117)
    c = 0

    nums.each{ |n|

      src = $cache.menu('Lvls/'+n.to_s)
      bmp.blt(c,0,src,src.rect)
      c += src.width

    }   
    
    self.bitmap = bmp
    
  end
  
  def from_pop35(num)
    
    # prepare number data
    anums = num.to_i.to_s.split(//)
    nums = []
    anums.each{ |n| nums.push(n.to_i) }
    
    size = 35
    color = :white

    # build the gfx of this number
    src = $cache.system('pop_'+size.to_s)
    cw = src.width/10
    ch = src.height/7

    # Colors
    colors = [:yellow,:orange,:blue,:green,:red,:gray,:white]
    ic = colors.find_index(color)
    
    # prepare the final image
    if nums.size == 1
      width = cw
    else
      width = nums.size * cw*0.78
    end
    #nums.each{ |n| width+=cw }
    bmp = Bitmap.new(width,ch)
    c = 0

    nums.each{ |n|

      s = n * cw

      bmp.blt(c,0,src,Rect.new(s,ic*ch,cw,ch))
      c += cw*0.7

    }
    
    self.bitmap=bmp
    
  end
  
  
end
