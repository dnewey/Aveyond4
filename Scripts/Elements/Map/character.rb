#==============================================================================
# ** Sprite_Character
#==============================================================================

class Sprite_Character < Sprite

  attr_accessor :character     

  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(viewport, character = nil)
    super(viewport)
    @vp = viewport
    @character = character
    @iconmode = false
    @pulse_delay = 0
    @pulse_idx = 0
    @fx_delay = 0
    @icons = [] # Sprites
    update
  end

  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super

    # Windmill hack
    if @character.character_name.include?('mill')

      if @character.pattern < 4
        @character.pattern += 1
      else

        @character.pattern = 0

        # Get num, next pic thanks
        num = @character.character_name.split("-")[1].to_i
        num+=1
        num = 1 if num > 6
        @character.character_name = 'Props/mill-'+num.to_s

      end

    end

    # If tile ID, file name, or hue are different from current ones
    if @character_name != @character.character_name
     
      @character_name = @character.character_name

      if @character_name.include?("Icons")
        self.bitmap = $cache.get(@character.character_name)
        @cw = bitmap.width
        @ch = bitmap.height
        self.ox = @cw/2
        self.oy = @ch
        @iconmode = true
        return
      end

      @iconmode = false

      self.bitmap = $cache.character(@character.character_name)

      @cw = bitmap.width / 4
      @ch = bitmap.height / 4
      self.ox = @cw / 2
      self.oy = @ch

      if @character_name.include?("Prop")
        @cw = bitmap.width
        @ch = bitmap.height
        self.ox = @cw / 2
        self.oy = @ch
        @iconmode = true
      end

    end

    # Clear the helper graphics
    if !$settings.debug_draw_helpers
      if @character_name == "!!!" || @character_name == 'Block'
        self.bitmap.clear
      end
    end

    # Set visible situation
    self.visible = !@character.transparent
    self.zoom_x = @character.zoom
    self.zoom_y = @character.zoom
    

    if !@iconmode
      if @character.force_pattern
        sx = @character.force_pattern * @cw
      else
        sx = @character.pattern * @cw
      end
      sy = (@character.showdir - 2) / 2 * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
    end

    # Set sprite coordinates
    self.x = @character.screen_x
    self.y = @character.screen_y - 8
    self.z = @character.screen_z(@ch)

    # TODO auto name the helper icons

    
    # Set opacity level, blend method, and bush depth
    self.opacity = @character.opacity
    #log_info(@character.opacity) if @character.opacity < 255

    #if @character.bush_depth > 0
      self.bush_depth = @character.bush_depth 

     # bmp = self.bitmap
      #self.bitmap = Bitmap.new(bmp.width,bmp.height)

      #self.bitmap.blt(0,0,bmp,Rect.new(0,0,bmp.width,16))

    #end

    # Flash effect
    if @character.flash_dur != nil
      self.flash(Color.new(255,255,255,160),@character.flash_dur)
      @character.flash_dur = nil
    end

    # Pulse effect
    if !@character.pulse_colors.empty?
      @pulse_delay -= 1
      if @pulse_delay <= 0
        @pulse_delay = 75
        self.flash(@character.pulse_colors[@pulse_idx],75)
        @pulse_idx += 1
        if @pulse_idx >= @character.pulse_colors.count
          @pulse_idx = 0
        end
      end
    end

    # Spark trail
    if @character.fxtrail != nil && @character.moving?
      @fx_delay -= 1
      if @fx_delay <= 0
        @fx_delay = 8
        spark(@character.id,@character.fxtrail,0,5)
      end
    end

    # Icons
    if @icons.count != @character.icons.count
      
      # If higher, pop the last one
      #num_new = @character.icons.count - @icons.count        

      # Rebuild icons
      @icons.each{ |i| i.dispose }
      @icons.clear

      total = (@icons.count-1) * (24+2)
      total -= 2
      cx = total/2

      @character.icons.each{ |i|

        spr = Sprite.new(@vp)
        spr.bitmap = $cache.icon("states/#{i}")
        spr.ox = 12
        spr.oy = 12
        spr.x = self.x - cx
        spr.y = self.y - @ch
        @icons.push(spr)

        cx += 26

        # Pop
        spr.zoom_x = 0.8
        spr.zoom_y = 0.8
        spr.do(seq(go("zoom_x",0.5,200,:qio),go("zoom_x",-0.3,100,:qio)))
        spr.do(seq(go("zoom_y",0.5,200,:qio),go("zoom_y",-0.3,100,:qio)))

      }


    end

  end


end
