#==============================================================================
# Game_Interface
#==============================================================================

class Game_Hud
  
  attr_accessor :message, :screen
  attr_accessor :trans
  
  #--------------------------------------------------------------------------
  # Prepare
  #--------------------------------------------------------------------------
  def initialize

    #@winder = Window_Item.new
    
      @screen = Ui_Screen.new
      @message = Ui_Message.new
      @trans = Ui_Trans.new
        
  end
  
  #--------------------------------------------------------------------------
  # Good beans
  #--------------------------------------------------------------------------
  def busy?
    return true if @screen.busy? || 
                    @message.busy? ||
                    @trans.busy?
    return false
  end
  
  #--------------------------------------------------------------------------
  # Update
  #--------------------------------------------------------------------------  
  def update

    @screen.update
    @message.update

    @trans.update
    
  end
  
end