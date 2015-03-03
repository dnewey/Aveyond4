#==============================================================================
# Ui_Chat
#==============================================================================

class Ui_Chatting #< Layer

  attr_accessor :rh
  
  #--------------------------------------------------------------------------
  # Prepare
  #--------------------------------------------------------------------------
  def initialize
    #super(500)

    #self.rect.height -= 210
    #@rh = self.rect.height
    #self.do(pingpong("rh",-200,1000))

    # Create the pieces but do nothing besides

    @state = :idle

    # Hold on to the convo
    @convo = nil

    # This line data
    @name = ''

    # Setup sprites
    #@plane = add(Plane.new)
    #@plane.bitmap = Cache.menu("wallpaper")
    #@plane.do(repeat(go("ox",2000,500,:circ_in)))
    #@plane.do(repeat(go("oy",20,500)))
    #@plane.do(pingpong("zoom_x",0.1,500,:quad_in_out))
    #@plane.do(pingpong("zoom_y",0.1,500,:quad_in_out))

    #@btn = add(Widget_Clicker.new())
    #@btn.width = 150
    #@btn.height = 150
    
    #@btn.x = 272
    #@btn.y = 208

    # @label = add(Widget_SuperLabel.new)
    
    # @label.x = 272
    # @label.y = 208
    # @label.text = "TESTERLAEL"

    #btn.opacity = 0
    #@btn.do(pingpong("width",200,500,:quad_in_out))
    #@btn.do(pingpong("height",100,1500,:linear))

    #@btn.tone = Tone.new(0,255,0)

    @box = add(Sprite_Superbox.new)
    @box.x = 16
    @box.y = 490#290
    #@box.opacity = 0
    
  end
  
  #--------------------------------------------------------------------------
  # Show Convo
  #--------------------------------------------------------------------------
  def start_convo(data)

    log_append(data)
        
    # TRASH THE CONVO HERE
    @convo = []
    data.each{ |line| 
    
      if line.include?(":")

        line_data = line.split(':')               
        speaker = line_data[0]
        @convo.push([speaker,line_data[1]])

      end
    
    }

    # slide in
    @box.do(go("y",-200,500,:quad_in_out))
    @state = :convo
    #start_line

  end
  
  #--------------------------------------------------------------------------
  # Show Convo
  #--------------------------------------------------------------------------
  def start_line

    log_append("STARTLINE")
      
    # Get next line
    line = @convo.shift
    return start_conclude if line == nil
    @name = line[0]    
    @text = line[1]

    #change_sprite = false

      #@active = :b
      #@active_box = @box
      #@active_sprite = @sprite_b

      # Get event
      # if @name.to_i.to_s == @name
      #   ev = getev(@name.to_i)
      # elsif @name == 'this'
      #   ev = getev(eid)
      # elsif @presets.include?(@name)
      #   ev=nil
      #   change_sprite = true
      #   @talker_b = @presets[@name][0]
      #   @index_b = @presets[@name][1]
      # else
      #   ev = event_by_name(@name)
      # end

      # if ev != nil && (@talker_b != ev)
      #   change_sprite = true
      #   @talker_b = ev#.character_name
      #   #@index_b = ev.character_index
      # end


    #@active_box.set_style(back) if back != nil

    # Slide previous character out
    # Only slide out if necessary
    #if change_sprite
    #  start_prep_out  
    #else
     @box.start_text(@text) 
    #end  
        
  end

  #--------------------------------------------------------------------------
  # Show Convo
  #--------------------------------------------------------------------------
  def start_prep_out        
    if @active == :a
      return start_prep_in if @sprite_a.x < -90
      @active_sprite.quad_x(-95)
    else
      return start_prep_in if @sprite_b.x > 500
      @active_sprite.quad_x(580)
    end
    @state = :prep_out    
  end

  #--------------------------------------------------------------------------
  # Show Convo
  #--------------------------------------------------------------------------
  def start_prep_in
    # if @active == :a
    #   spr = $world.sprite_for(@talker_a)
    #   @sprite_a.from_spr(spr)
    #   #@sprite_a.from_char(@talker_a,@index_a,2,true)
    #   @sprite_a.quad_x(5)
    # else
      #spr = $world.sprite_for(@talker_b)
      #@sprite_b.from_spr(spr) if @name != 'rovert'
      #@sprite_b.from_char(@talker_b,@index_b,2,true) if @name == 'rovert'
      #@sprite_b.quad_x(480)
    # end
    @state = :prep_in   
  end


  #--------------------------------------------------------------------------
  # Show Convo
  #--------------------------------------------------------------------------
  def start_conclude
    #@sprite_a.quad_x(-95)
    #@sprite_b.quad_x(580)
    @box.do(go("y",200,500,:quad_in_out))
    log_append("CONCLUDE!")
    @state = :conclude
  end
    
  #--------------------------------------------------------------------------
  # Update
  #--------------------------------------------------------------------------
  def update  
    super

    #@btn.from_skin("wskin")

    #self.rect.height = @rh
    
    case @state

      when :idle
        return

      when :prep_out        
        start_prep_in if @active_sprite.quad_done?

      when :prep_in
        start_talk if @active_sprite.quad_done?

      when :convo
        
        if !@box.busy?          
          start_line
          @box.do(sequence(go("y",-20,100,:quad_in_out),go("y",20,100,:quad_in_out)))
        end

      when :conclude
        #if @active_sprite.quad_done?
        log_append("IDLE")
          @state = :idle
        #end

    end
    
  end

  #--------------------------------------------------------------------------
  # Misc
  #--------------------------------------------------------------------------
  def clear() end
  def busy?() return @state != :idle end

end