#==============================================================================
# Sprite_Pop
#==============================================================================

class Sprite_Pop < Widget
  
  attr_accessor :life,:vx,:vy,:fy
  attr_accessor :base_type
  attr_accessor :type
    
  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def initialize(vp)
    super(vp)
    
    @state = :in
        
    # Defaults
    @life = 45
    @fy = 0.4
    @vx = rand*2.0-1.0
    @vy = rand*-5.0-10.0
    @base_type = :normal
    @type = :fall
    
  end
  
  #--------------------------------------------------------------------------
  # * Prepare icon popper
  #--------------------------------------------------------------------------
  def pop_icon(ic,double=false)
    prep_sprite(Cache.stroke_icon(ic,double)) 
  end
  
  def pop_gfx(gfx)
    prep_sprite(Cache.menu('Drops/'+gfx))
  end
  
  def pop_hit(gfx)
    prep_sprite(Cache.menu(gfx))
  end
  
  #--------------------------------------------------------------------------
  # * Prepare damage popper
  #--------------------------------------------------------------------------
  def pop_dmg(dmg,size,color)

    # prepare number data
    anums = dmg.to_i.to_s.split(//)
    nums = []
    anums.each{ |n| nums.push(n.to_i) }

    # build the gfx of this number
    src = Cache.system('pop_'+size.to_s)
    cw = src.width/10
    ch = src.height/7

    # Colors
    colors = [:yellow,:orange,:blue,:green,:red,:gray,:white]
    ic = colors.find_index(color)
    
    # prepare the final image
    width = 0
    nums.each{ |n| width+=cw }
    bmp = Bitmap.new(width,ch)
    c = 0

    nums.each{ |n|

      s = n * cw

      bmp.blt(c,0,src,Rect.new(s,ic*ch,cw,ch))
      c += cw*0.65

    }
    
    prep_sprite(bmp)    
    
  end
  
  #--------------------------------------------------------------------------
  # * Prepare damage popper
  #--------------------------------------------------------------------------
  def pop_xp(dmg,size,color)

    # prepare number data
    anums = dmg.to_i.to_s.split(//)
    nums = []
    anums.each{ |n| nums.push(n.to_i) }

    # build the gfx of this number
    src = Cache.system('pop_'+size.to_s)
    cw = src.width/10
    ch = src.height/7

    # Colors
    colors = [:yellow,:orange,:blue,:green,:red,:gray,:white]
    ic = colors.find_index(color)
    
    # prepare the final image
    width = 0
    nums.each{ |n| width+=cw }
    bmp = Bitmap.new(width+20,ch)
    c = 0

    nums.each{ |n|

      s = n * cw

      bmp.blt(c,0,src,Rect.new(s,ic*ch,cw,ch))
      c += cw*0.65

    }
    
    src = Cache.menu('xp')
    bmp.blt(c+2,9,src,src.rect)
    
    prep_sprite(bmp)    
    
  end
  
  #--------------------------------------------------------------------------
  # * Prepare sharp popper
  #--------------------------------------------------------------------------
  def pop_sharp(dmg,size,color)

    # prepare number data
    anums = dmg.to_i.to_s.split(//)
    nums = []
    anums.each{ |n| nums.push(n.to_i) }

    # build the gfx of this number
    src = Cache.system('pop_'+size.to_s)
    cw = src.width/10
    ch = src.height/7

    # Colors
    colors = [:yellow,:orange,:blue,:green,:red,:gray,:white]
    ic = colors.find_index(color)

    # prepare the final image
    width = 0
    nums.each{ |n| width+=cw }
    bmp = Bitmap.new(width+38,ch+3)
    c = 0
    
    

    nums.each{ |n|

      s = n * cw

      bmp.blt(c,0,src,Rect.new(s,ic*ch,cw,ch))
      c += cw*0.65

    }

    
    src = Cache.menu('dmg')
    bmp.blt(c+1,4,src,src.rect)
    
    prep_sprite(bmp)    

  end
  
  #--------------------------------------------------------------------------
  # * Prepare sharp popper
  #--------------------------------------------------------------------------
  def pop_block(dmg,size,color)

    # prepare number data
    anums = dmg.to_i.to_s.split(//)
    nums = []
    anums.each{ |n| nums.push(n.to_i) }

    # build the gfx of this number
    src = Cache.system('pop_'+size.to_s)
    cw = src.width/10
    ch = src.height/7

    # Colors
    colors = [:yellow,:orange,:blue,:green,:red,:gray,:white]
    ic = colors.find_index(color)
    
    # prepare the final image
    width = 0
    nums.each{ |n| width+=cw }
    bmp = Bitmap.new(width+40,ch)
    c = 0

    nums.each{ |n|

      s = n * cw

      bmp.blt(c,0,src,Rect.new(s,ic*ch,cw,ch))
      c += cw*0.65

    }
    
    src = Cache.menu('block')
    bmp.blt(c+1,5,src,src.rect)
    
    prep_sprite(bmp)    
    
  end
  
  #--------------------------------------------------------------------------
  # * Prepare damage popper
  #--------------------------------------------------------------------------
  def pop_hp(dmg,size,color)

    # prepare number data
    anums = dmg.to_i.to_s.split(//)
    nums = []
    anums.each{ |n| nums.push(n.to_i) }

    # build the gfx of this number
    src = Cache.system('pop_'+size.to_s)
    cw = src.width/10
    ch = src.height/7

    # Colors
    colors = [:yellow,:orange,:blue,:green,:red,:gray,:white]
    ic = colors.find_index(color)
    
    # prepare the final image
    width = 0
    nums.each{ |n| width+=cw }
    bmp = Bitmap.new(width+20,ch+15)
    c = 0

    nums.each{ |n|

      s = n * cw

      bmp.blt(c,0,src,Rect.new(s,ic*ch,cw,ch))
      c += cw*0.65

    }
    
    src = Cache.menu('hp')
    bmp.blt(c+2,9,src,src.rect)
    
    prep_sprite(bmp)    
    
  end
  
  #--------------------------------------------------------------------------
  # * Prepare sprite
  #--------------------------------------------------------------------------
  def prep_sprite(bmp)
    
    # setup sprite
    self.opacity = 0
    self.bitmap = bmp
    self.auto_size
    @loc_y = y.to_f-bmp.height/2
    @loc_x = self.x
    @base_y = @base_type == :normal ? @loc_y - (bmp.height/2)+10 : 400
    
  end  
  
  #--------------------------------------------------------------------------
  # * Dispose
  #--------------------------------------------------------------------------
  def dispose

    self.bitmap.dispose if self.bitmap != nil
    super

  end

  #--------------------------------------------------------------------------
  # * Update
  #--------------------------------------------------------------------------
  def update
    super
    
    @vy += @fy if @type == :fall

    @loc_y += @vy
    @loc_x += @vx
    
    if @type == :fall
      if @vy > 0 && @loc_y >= @base_y
        @vy > 2.0 ? @vy *= -0.5 : @vy = 0
        @loc_y = @base_y
      end
    else
      @vy *= 0.9
      @vx *= 0.8
    end

    # Positioning
    self.y = @loc_y
    self.x = @loc_x

    if @state == :in
      self.opacity += 20
      @state = :up if self.opacity >= 255
    elsif @state == :up
      @life -= 1
      @state = :out if @life <= 0
    elsif @state == :out
      self.opacity -= 20
      @state = :done if self.opacity <= 0
    end
    
    #p @state

  end

  #--------------------------------------------------------------------------
  # * Mischecks
  #--------------------------------------------------------------------------
  def dead?() return self.opacity <= 0 end

end