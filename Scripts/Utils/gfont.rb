#==============================================================================
# ** Gradient Font Color
#------------------------------------------------------------------------------
#   Original code by poccil
#   Rewritten by Dargor, 2008
#   05/07/08
#   Version 1.0
#------------------------------------------------------------------------------
#   VERSION HISTORY:
#    - 1.0 (05/07/08), Initial release
#------------------------------------------------------------------------------
#   INSTRUCTIONS:
#    - Paste this above main
#    - Edit the font's gradient parameters in a window like that:
#            self.contents.font.gradient = true/false
#            self.contents.font.gradient_color1 = color
#            self.contents.font.gradient_color2 = color
#            self.contents.font.gradient_mode = mode
#                  Modes: (0 : Vertical, 1: Horizontal, 2: Diagonal)
#    - By default, the gradient effect is on. You can turn it off by
#       setting the @gradient flag in the Font class to false. (*line 47)
#------------------------------------------------------------------------------
#   NOTES:
#       This script is compatible with both XP and VX
#==============================================================================
 
#==============================================================================
# ** Font
#==============================================================================
 
class Font
  #--------------------------------------------------------------------------
  # * Public Instance Variables
  #--------------------------------------------------------------------------
  attr_accessor :gradient
  attr_accessor :gradient_color1
  attr_accessor :gradient_color2
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias dargor_vx_font_gradient_initialize initialize
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize(*args)
     dargor_vx_font_gradient_initialize(*args)
     @gradient = false
     @gradient_color1 = Color.new(255,255,255)
     @gradient_color2 = Color.new(255,255,255)
  end
end
 
#==============================================================================
# ** Bitmap
#==============================================================================
 
class Bitmap
  #--------------------------------------------------------------------------
  # * Alias Listing
  #--------------------------------------------------------------------------
  alias dargor_vx_bitmap_gradient_draw_text draw_text
  #--------------------------------------------------------------------------
  # * Draw Text
  #--------------------------------------------------------------------------
  def draw_text(*args)

     # Original font color
     if self.font.gradient
        
        # Get text variables
        if args[0].is_a?(Rect)
           x = args[0].x
           y = args[0].y
           width = args[0].width
           height = args[0].height
           text = args[1]
           align = args[2].nil? ? 0 : args[2]
        else
           x = args[0]
           y = args[1]
           width = args[2]
           height = args[3]
           text = args[4]
           align = args[5].nil? ? 0 : args[5]
        end

        original_color = self.font.color
        alpha = original_color.alpha.to_f if alpha.nil?
        # Create temporary text bitmap
        text1=Bitmap.new(width, height)
        text2=Bitmap.new(width, height)
        text1.font.size = self.font.size
        text1.font.name = self.font.name
        text1.font.color = self.font.gradient_color2
        text_height = text1.text_size(text).height
        text_width = text1.text_size(text).width
        return if text_width < 1 or text_height < 1

        # Temporary remove the gradient effect
        self.font.gradient = false
        text1.dargor_vx_bitmap_gradient_draw_text(0, 0, width, height, text, align)
        self.font.gradient = true

        # What in the world .....
           text_position = (height / 2) - (text_height / 2)
           for i in 0...height
              if i < text_position
                 opacity = 0
              elsif i > text_position + text_height
                 opacity = 255
              else
                 ratio = ((i - text_position) * 1.0 / text_height)
                 ratio -=(0.5 - ratio) * 0.5
                 opacity = ratio * 255.0
                 opacity = 255.0 if opacity > 255.0
                 opacity = 0.0 if opacity < 0.0
              end
              text2.blt(0, i, text1, Rect.new(0,i,width,1), opacity)
           end


        # Draw gradient text
        self.font.color = Color.new(255,0,0)#self.font.gradient_color1
        self.font.color.alpha = alpha
        # Temporary remove the gradient effect
        self.font.gradient = false
        dargor_vx_bitmap_gradient_draw_text(*args)
        # Temporary remove the gradient effect
        self.font.gradient = true
        self.font.color = original_color
        self.font.color.alpha = 255#alpha
        self.blt(x, y, text2, text2.rect, alpha)
        # Dispose gradient text bitmap
        text1.dispose
        text2.dispose
     else
        # The usual
        dargor_vx_bitmap_gradient_draw_text(*args)
     end

    def draw_special

    end

  end
end