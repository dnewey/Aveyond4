#==============================================================================
# Widget_Bugbox
#==============================================================================

class Widget_Bugbox < Widget

  attr_accessor :name
    
  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def create

    @name = "Bugbox"
    @color = Color.new(255,255,255)
    
    refresh

  end
      
  #--------------------------------------------------------------------------
  # * Redraw
  #--------------------------------------------------------------------------
  def refresh

    self.bitmap = Bitmap.new(self.width,self.height)
    self.bitmap.fill_rect(0,0,self.width,self.height,Color.random)

    txt = self.x.to_s + ", " + self.y.to_s + ", "
    txt += self.width.to_s + ", " + self.height.to_s

    self.bitmap.font.size = 18
    self.bitmap.draw_text(5,5,self.width,20,@name+" "+txt)
    
  end
  
end