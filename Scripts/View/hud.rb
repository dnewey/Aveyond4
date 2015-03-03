#==============================================================================
# Game_Interface
#==============================================================================

class Game_Hud
  
  attr_accessor :chatting, :screen, :menu
  attr_accessor :trans
  
  #--------------------------------------------------------------------------
  # Prepare
  #--------------------------------------------------------------------------
  def initialize

    #@winder = Window_Item.new
    
    # Hud
    @screen = nil
    @chatting = nil
    @menu = nil
    
    # Custom transfer system
    @trans = nil
        
  end
  
  #--------------------------------------------------------------------------
  # Good beans
  #--------------------------------------------------------------------------
  def busy?() 
    return false
    return if !@screen
    return true if @screen.busy? || 
                    @chatting.busy? ||
                    @menu.busy? ||
                    @trans.busy?
    return false
  end
  
  #--------------------------------------------------------------------------
  # Update
  #--------------------------------------------------------------------------  
  def update

   # @winder.update
    return
    
    if !@screen
      @screen = Ui_Screen.new 
      @chatting = Ui_Chatting.new 
      @menu = Ui_Menu.new 
      @trans = Ui_Trans.new 
    end

    @screen.update
    @chatting.update
    @menu.update

    @trans.update
    
  end
  
end