#==============================================================================
# ** Sprite_Character
#------------------------------------------------------------------------------
#  This sprite is used to display the character.It observes the Game_Character
#  class and automatically changes sprite conditions.
#==============================================================================

class Sprite_Character < Sprite

  attr_accessor :character     

  #--------------------------------------------------------------------------
  # * Object Initialization
  #     viewport  : viewport
  #     character : character (Game_Character)
  #--------------------------------------------------------------------------
  def initialize(viewport, character = nil)
    super(viewport)
    @character = character
    update
  end

  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super

    # If tile ID, file name, or hue are different from current ones
    if @character_name != @character.character_name
     
      @character_name = @character.character_name

      self.bitmap = $cache.character(@character.character_name)
      if @character == $player
        self.bitmap = $cache.character("Player/boy")
        
      end
      @cw = bitmap.width / 4
      @ch = bitmap.height / 4
      self.ox = @cw / 2
      self.oy = @ch

    end

    if @character == $player
      self.bitmap = $cache.character("Player/boy")
      self.bitmap = $cache.character("Player/boy_corn") if @character.bush_depth > 0
    end

    # Set visible situation
    self.visible = !@character.transparent
    
    sx = @character.pattern * @cw
    sy = (@character.showdir - 2) / 2 * @ch
    self.src_rect.set(sx, sy, @cw, @ch)

    # Set sprite coordinates
    self.x = @character.screen_x
    self.y = @character.screen_y - 8
    self.z = @character.screen_z(@ch)
    
    # Set opacity level, blend method, and bush depth
    self.opacity = @character.opacity
    #log_info(@character.opacity) if @character.opacity < 255

    #if @character.bush_depth > 0
      #self.bush_depth = 1.2 * @character.bush_depth 

      #bmp = self.bitmap
      # self.bitmap = Bitmap.new(bmp.width,bmp.height)

      # self.bitmap.blt(0,0,bmp,Rect.new(0,0,bmp.width,16))

    #end
    
    # Animation
    # if @character.animation_id != 0
    #   animation = $data_animations[@character.animation_id]
    #   animation(animation, true)
    #   @character.animation_id = 0
    # end

  end
end
