#==============================================================================
# Ui_Base
#==============================================================================

class Ui_Base
  
  #--------------------------------------------------------------------------
  # Everything
  #--------------------------------------------------------------------------
  def initialize(z) 
  	@all = [] 
  	@viewport = Viewport.new(0,0,$game.width,$game.height)
  	@viewport.z = z
  end  

  def add_sprite 
  	spr = Sprite.new(@viewport)
  	@all.push(spr)
  	return spr
  end

  def elements() 
  	return @all 
  end

  def clear() 
    @all.each{ |e| e.dispose  } 
    @all = []
  end  

  def hide() @all.each{ |e| e.hide } end
  def show() @all.each{ |e| e.show } end
  def update() end

  def busy?
  	false
  end
  
end
