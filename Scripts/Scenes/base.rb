#==============================================================================
# ** Scene_Base
#------------------------------------------------------------------------------
#  This is a super class of all scenes within the game.
#==============================================================================

MENU_TRANSPARENCY = 200

class Scene_Base
  
  #--------------------------------------------------------------------------
  # * Main
  #--------------------------------------------------------------------------
  def initialize    
    Graphics.transition#(transtime)
    Input.update
    start
  end

  def start
    #overriide
  end
    
  def terminate
    Graphics.freeze    
  end

  #--------------------------------------------------------------------------
  # * Fade Out All Sounds and Graphics
  #--------------------------------------------------------------------------
  def fadeout_all(time = 1000)
    RPG::BGM.fade(time)
    RPG::BGS.fade(time)
    RPG::ME.fade(time)
    Graphics.fadeout(time * Graphics.frame_rate / 1000)
    RPG::BGM.stop
    RPG::BGS.stop
    RPG::ME.stop
  end

end
