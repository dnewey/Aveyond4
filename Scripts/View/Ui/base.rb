#==============================================================================
# Ui_Base
#==============================================================================

class Ui_Base
  
  #--------------------------------------------------------------------------
  # Everything
  #--------------------------------------------------------------------------
  def initialize(z) 
  	@all = [] 
  	#@viewport = Viewport.new()
  	#@viewport.z = z
  end  

  def add(elements) 
  	[*elements].each{ |e| @all.push(e) } 
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
  
end
