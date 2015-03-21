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

        self.bitmap = Cache.character(@character.character_name,0)
        if @character == $player
          self.bitmap = Cache.character("Player/boy",0)
        end
        @cw = bitmap.width / 4
        @ch = bitmap.height / 4
        self.ox = @cw / 2
        self.oy = @ch

      end


    # Set visible situation
    self.visible = !@character.transparent
    
    sx = @character.pattern * @cw
    sy = (@character.direction - 2) / 2 * @ch
    self.src_rect.set(sx, sy, @cw, @ch)


    # Set sprite coordinates
    self.x = @character.screen_x
    self.y = @character.screen_y
    self.z = @character.screen_z(@ch)
    
    # Set opacity level, blend method, and bush depth
    self.opacity = @character.opacity
    self.bush_depth = @character.bush_depth
    
    # Animation
    # if @character.animation_id != 0
    #   animation = $data_animations[@character.animation_id]
    #   animation(animation, true)
    #   @character.animation_id = 0
    # end

  end
end