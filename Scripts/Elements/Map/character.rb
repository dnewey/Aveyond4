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


    @windmill = @character.character_name.include?('mill')

    # Clear the helper graphics
    # Maybe move to cache? Or just clear the gfx
    # if !$settings.debug_draw_helpers
    #   if @character_name == "!!!" || @character_name == 'Block'
    #     self.bitmap.clear
    #   end
    # end


    update
  end

  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super

    #update_windmill if @windmill

    # If tile ID, file name, or hue are different from current ones
    update_bitmap if graphic_changed?
    update_src_rect if src_rect_changed?   

    # Set visible situation
    update_position
    update_misc
    update_colors
    update_spark_trail
    update_icons

  end

  # Updates

  def update_bitmap

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

      update_src_rect

  end

  def update_src_rect

    @old_pattern = @character.pattern
    @old_dir     = @character.direction
    @old_showdir     = @character.showdir

        # Src rect
    if !@iconmode
      if @character.force_pattern
        sx = @character.force_pattern * @cw
      else
        sx = @character.pattern * @cw
      end
      sy = (@character.showdir - 2) / 2 * @ch
      self.src_rect.set(sx, sy, @cw, @ch)
    end

  end

  def update_position
    # Set sprite coordinates
    self.x = @character.screen_x
    self.y = @character.screen_y - 8
    self.z = @character.screen_z(@ch)
  end

  def update_colors

    # Color
    if @character.color.is_a?(Color)
      self.color = @character.color
      return
    end

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

  end

  def update_spark_trail

    return if @character == $player

    if @character.fxtrail != nil && @character.moving? && !@character.deleted
      @fx_delay -= 1
      if @fx_delay <= 0
        @fx_delay = 8
        spark(@character.id,@character.fxtrail,@character.off_x,@character.off_y+8)
      end
    end

  end

  def update_icons

    # Icons
    if @icons.count != @character.icons.count
      
      # If higher, pop the last one
      #num_new = @character.icons.count - @icons.count        

      # Rebuild icons
      @icons.each{ |i| i.dispose }
      @icons.clear

      total = (@icons.count-1) * (16+2)
      #total -= 2
      cx = 0#-total/2

      @character.icons.each{ |i|

        spr = Sprite.new(@vp)
        spr.bitmap = $cache.icon("states/#{i}")
        spr.ox = 8
        spr.oy = 8
        spr.x = self.x - cx
        spr.y = self.y - @ch
        spr.z += 1000
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

  def update_misc

    self.visible = !@character.transparent
    self.zoom_x = @character.zoom
    self.zoom_y = @character.zoom

    self.opacity = @character.opacity
    self.bush_depth = @character.bush_depth 

  end

  def update_windmill
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
  end


  # Misc
  def graphic_changed?
    @character_name != @character.character_name
  end

  def src_rect_changed?
    @character.pattern != @old_pattern ||
      @character.direction != @old_dir ||
        @character.showdir != @old_showdir
  end

end
