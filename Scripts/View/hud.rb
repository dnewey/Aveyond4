#==============================================================================
# Game_Interface
#==============================================================================

class Game_Hud
  
  attr_accessor :message, :screen, :menu
  attr_accessor :trans
  
  #--------------------------------------------------------------------------
  # Prepare
  #--------------------------------------------------------------------------
  def initialize

    #@winder = Window_Item.new
    
      @screen = Ui_Screen.new
      @message = Ui_Message.new
      @menu = Ui_Menu.new
      @trans = Ui_Trans.new
        
  end
  
  #--------------------------------------------------------------------------
  # Good beans
  #--------------------------------------------------------------------------
  def busy?() 
    return false
    return if !@screen
    return true if @screen.busy? || 
                    @message.busy? ||
                    @menu.busy? ||
                    @trans.busy?
    return false
  end
  
  #--------------------------------------------------------------------------
  # Update
  #--------------------------------------------------------------------------  
  def update

    @screen.update
    @message.update
    @menu.update

    @trans.update
    
  end
  
end