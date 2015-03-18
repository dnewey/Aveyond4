#==============================================================================
# ** Interpreter (part 6)
#------------------------------------------------------------------------------
#  This interpreter runs event commands. This class is used within the
#  Game_System class and the Game_Event class.
#==============================================================================

class Interpreter

  #--------------------------------------------------------------------------
  # * Shop Processing
  #--------------------------------------------------------------------------
  def command_302
    # Set battle abort flag
    $game_temp.battle_abort = true
    # Set shop calling flag
    $game_temp.shop_calling = true
    # Set goods list on new item
    $game_temp.shop_goods = [@parameters]
    # Loop
    loop do
      # Advance index
      @index += 1
      # If next event command has shop on second line or after
      if @list[@index].code == 605
        # Add goods list to new item
        $game_temp.shop_goods.push(@list[@index].parameters)
      # If event command does not have shop on second line or after
      else
        # End
        return false
      end
    end
  end

end
