#==============================================================================
# ** Game_Character (part 4 - Pathfinding)
#------------------------------------------------------------------------------
#  This class deals with characters. It's used as a superclass for the
#  Game_Player and Game_Event classes.
#  These functions are used by the Mouse module for path finding and moving
#==============================================================================

class Game_Character
  #--------------------------------------------------------------------------
  # * Frame Update (run_path)
  #--------------------------------------------------------------------------
  def run_path
    return if moving?
    step = @map[@x,@y]
    if step == 1
      @map = nil
      @runpath = false
      return
    end
      
    dir = rand(2)
    case dir
    when 0
      move_right if @map[@x+1,@y] == step - 1 and step != 0
      move_down if @map[@x,@y+1] == step - 1 and step != 0
      move_left if @map[@x-1,@y] == step -1 and step != 0
      move_up if @map[@x,@y-1] == step - 1 and step != 0
    when 1
      move_up if @map[@x,@y-1] == step - 1 and step != 0
      move_left if @map[@x-1,@y] == step -1 and step != 0
      move_down if @map[@x,@y+1] == step - 1 and step != 0
      move_right if @map[@x+1,@y] == step - 1 and step != 0
    end
  end
  #--------------------------------------------------------------------------
  # * Find Path
  #--------------------------------------------------------------------------
  def find_path(x,y, force = true)
    sx, sy = @x, @y
    result = setup_map(sx,sy,x,y)
    @runpath = result[0]
    @map = result[1]
    @map[sx,sy] = result[2] if result[2] != nil
    $player.ignore_movement = @runpath ? force : false
  end
  #--------------------------------------------------------------------------
  # * Clear Path
  #--------------------------------------------------------------------------
  def clear_path
    @map = nil
    @runpath = false
    @ovrdest = false
    $player.ignore_movement = false
  end
  #--------------------------------------------------------------------------
  # * Setup Map
  #--------------------------------------------------------------------------
  def setup_map(sx,sy,ex,ey)
    map = Table.new($map.width, $map.height)

    # Shaz - does the event override the destination?
    tx = ex
    ty = ey
    event = $map.event_at(ex, ey)
    if !event.nil? && !event.list.nil? && !event.erased && 
      event.list.size > 1 && event.list[1].code == 108
      text = event.list[1].parameters.to_s
      text.gsub!(/[Mm][Oo][Uu][Ss][Ee]\[([-,0-9]+),([-,0-9]+)\]/) do
        tx = ex + $1.to_i
        ty = ey + $2.to_i
        map[ex, ey] = 999
        @ovrdest = true
      end
      tx += 1 if event.y == ey + 1
    elsif !event.nil? && !event.erased && event.x == ex && event.y == ey + 1
      tx = ex
      ty = ey + 1
      map[ex, ey] = 999
      @ovrdest = true
    end
      
    update_counter = 0
    map[tx,ty] = 1
    old_positions = []
    new_positions = []
    old_positions.push([tx, ty])
    depth = 2
    $path_allow = false
    depth.upto(100){|step|
      loop do
        break if old_positions[0] == nil
        x,y = old_positions.shift
        return [true, map, step-1] if x == sx and y == sy
        if map[x,y + 1] == 0 and $player.passable?(x, y, 2, step, tx, ty) 
          map[x,y + 1] = step
          new_positions.push([x,y + 1])
        end
        if map[x - 1,y] == 0 and $player.passable?(x, y, 4, step, tx, ty) 
          map[x - 1,y] = step
          new_positions.push([x - 1,y])
        end
        if map[x + 1,y] == 0 and $player.passable?(x, y, 6, step, tx, ty) 
          map[x + 1,y] = step
          new_positions.push([x + 1,y])
        end
        if map[x,y - 1] == 0 and $player.passable?(x, y, 8, step, tx, ty) 
          map[x,y - 1] = step
          new_positions.push([x,y - 1])
        end
          
        # If we've checked quite a few tiles, allow graphics and input
        # to update - to avoid the 'script hanging' error
        update_counter += 1
        if update_counter > 100
          Graphics.update
          update_counter = 0
        end
      end

      old_positions = new_positions
      new_positions = []
    }
      
    @ovrdest = false
    return [false, nil, nil]        
  end
end
