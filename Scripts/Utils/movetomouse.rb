#==============================================================================
# ** MouseCursor
#==============================================================================

module MouseCursor
    Default_Cursor = 'default'
    Event_Cursor   = 'touch'
    Actor_Cursor   = 'default'
    Enemy_Cursor   = 'fight'
    Item_Cursor    = true
    Skill_Cursor   = true
    Dummy = Bitmap.new(32, 32)
end

#==============================================================================
# ** Sprite_Mouse
#==============================================================================

class Sprite_Mouse < Sprite
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    super
    self.z = 10100
    self.ox = 4
    update
  end
  #--------------------------------------------------------------------------
  # ** Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    
    # Update Visibility
    self.visible = $scene != nil
    
    # If Visible
    if self.visible
      
      # If Non-nil Mouse Position
      if Mouse.position != nil
        
        # Gets Mouse Position
        mx, my = *Mouse.position
        
        # Update POsition
        self.x = mx unless mx.nil?
        self.y = my unless my.nil? # (@_NPCname == nil ? my : my - 25) unless my.nil?        
        
      end
      
      # If Scene changes or Mouse is Triggered
      if @scene != $scene.class || Mouse.trigger?
        
        # Update Scene Instance
        @scene = $scene.class
        
        # Update Bitmap
        set_bitmap(MouseCursor::Default_Cursor)
      end
      
    end
    
  end
  #--------------------------------------------------------------------------
  # ** Set Bitmap
  #--------------------------------------------------------------------------
  def set_bitmap(cursor, xNPCname = nil)
    
    # show fancy cursor only if custom mouse on
    if $game_mouse
             
      # If Cursor Info matches
      if (@_cursor == cursor) && (@_NPCname == xNPCname)
        return
      end
      
      # Reset Cursor Info
      @_cursor      = cursor
      @_NPCname     = xNPCname
      
      # Gets Dummy
      dummy = MouseCursor::Dummy
      
      # Gets Item Cursor Bitmap
      item_cursor = cursor.nil? ? MouseCursor::Default_Cursor : cursor
      
      # Start Cursor Bitmap
      bitmap = RPG::Cache.icon("icon-" + item_cursor) if item_cursor != ''

      # Show NPC name
      if @_NPCname != nil
        # Get name width
        w = dummy.text_size(@_NPCname).width
        h = dummy.font.size
        b = RPG::Cache.icon("icon-" + item_cursor)
        # Create New Bitmap
        bitmap = Bitmap.new((bitmap.nil? ? w : 40 + w), [b.height, h + 2].max)
        bitmap.font.size = dummy.font.size
        # Draw Icon
        #if self.x + bitmap.width > 640
        #  textx = bitmap.width - w - b.width # - 10
        #  bitmap.blt(bitmap.width - b.width, 0, b, b.rect)
        #else
          textx = b.width + 10
          bitmap.blt(0, 0, b, b.rect)
        #end
        #bitmap.blt(12 - b.width / 2, 49 - b.height, b, b.rect)
        #bitmap.blt(0, 0, b, b.rect)
        # Draw NPC Name
        #x = item_cursor == '' ? 0 : 32
        bitmap.font.color = Color.new(0, 0, 0, 255) # black
        bitmap.draw_text(textx - 1, 0, w, h, @_NPCname) # 0
        bitmap.draw_text(textx + 1, 0, w, h, @_NPCname) # 0 
        bitmap.draw_text(textx, -1, w, h, @_NPCname) # -1
        bitmap.draw_text(textx, 1, w, h, @_NPCname) # 1
        bitmap.font.color = Color.new(255, 255, 255, 255) # white
        bitmap.draw_text(textx, 0, w, h, @_NPCname)
      end    

      # Set Bitmap
      self.bitmap = bitmap
      
    elsif self.bitmap
      @_cursor = nil
      self.bitmap = nil
      
    end
    
  end
  #--------------------------------------------------------------------------
  # ** Frame Update : Update Event Cursors
  #--------------------------------------------------------------------------
  def update_event_cursors
    
    # If Nil Grid Position
    if Mouse.grid.nil? 
      # Set Default Cursor
      set_bitmap(MouseCursor::Default_Cursor)
      return
    end
    
    # Gets Mouse Position
    x, y = *Mouse.grid
    
    # Gets Mouse Position
    mx, my = *Mouse.position    
    
    # Gets Mouse Event
    event = $game_map.lowest_event_at(x, y)
    
    # If Non-Nil Event or not over map HUD
    unless event.nil? || my >= 448
      # If Not Erased or Nil List
      if event.list != nil && event.erased == false && event.list[0].code == 108
        # Get the cursor to show
        icon = nil
        event.list[0].parameters.to_s.downcase.gsub!(/icon (.*)/) do
          icon = $1.to_s
        end
        
        if !((icon == "talk") || 
           (icon == "touch") || 
           (icon == "fight") || 
           (icon == "examine") || 
           (icon == "point") ||
           (icon == "exit"))
           icon = MouseCursor::Default_Cursor
        end        
        xNPCname = nil 
        if event.list.size > 1 && event.list[1].code == 108
          text = event.list[1].parameters.to_s
          text.gsub!(/[Nn][Aa][Mm][Ee] (.*)/) do
            xNPCname = $1.to_s
          end
        end
        set_bitmap(icon, xNPCname)  
        #self.x = self.x - self.bitmap.width + 24 if self.x + self.bitmap.width > 640
        if event.name != "BOTTOM" # and ["Arrow2", "Arrow4"].include?(icon)
          self.y -= 8
        end
        return
      end
      return
    end
    
    # Set Default Cursor
    set_bitmap(MouseCursor::Default_Cursor)
    
  end
end


  $mouse_sprite = Sprite_Mouse.new
  $mouse_sprite.visible = true
