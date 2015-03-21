 #==============================================================================
# ** Dan Message Box
#==============================================================================

# States
#
# :closed - hidden and inactive
# :opening - fading in, leads to :texting
# :closing - fading out, leads to :closed
# :texting - showing text, letter by letter
# :done - done showing text, wait for input to continue
# :waiting - waiting a set time, @. @| etc

class Sprite_Textbox < Widget

  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def create

    @state = :closed
    @side = 'a'      

    # text speed
    @normal_speed = 4 #-$settings.value('text_speed')
    @text_delay = @normal_speed
    
    # Internal tracking
    @skip_all = false
    @wait_frames = 0
    @next_char = 0   
    @top_line_fade = 255
    @line_y_offset = 0
    @indent=25
    @width=425  
    @data = nil # All text
    @line_data = [''] # Text on current line
    @word = "" # Remainder of current word
    @line_images = nil
    @line_indx = 0
    @word_idx = 0

    # show next icon
    @show_next = false
    @next_opacity = 0

    # Setup height for zooming
    self.set_height(64)
    #self.set_zy(0.0)    
    
    @style = 'white'
    @font = 'white'
    
    self.bitmap = @bg_gfx = Cache.menu("chatbox")
    #Cache.menu("Text\\chat_box_white_"+@side)

  end

  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    
#~     if Input.press?(:SHIFT)
#~       @state = :closing
#~       @show_next = false
#~     end
      

    @next_opacity += 10 if @show_next && @next_opacity < 250
    @next_opacity -= 10 if !@show_next && @next_opacity > 0
    
    # Skip to end of this text, line i guess, but maybe don't have this
    #if Input.trigger?(Input::C) && @state = :texting
    #  @skip_all = true
    #end

    case @state

      when :closed
        #nothing
      when :opening
        @state = :texting if self.zoom_y == 1.0
      when :closing
        if self.zoom_y == 0.0
          @state = :closed
          @line_images = [Bitmap.new(500,40)]
          @line_images[0].font = Fonts.get(@font+"_reg")
          draw_lines
        end
      when :texting
        @next_char -= 1
        if @next_char <= 0
          update_message
          update_message if @text_delay < 0
        end
        draw_lines
      when :fade_line
        @top_line_fade -= 5#(5 * $settings.value('text_speed'))
        if @top_line_fade < 10
          @top_line_fade = 0
          @state = :scroll_line
        end
        draw_lines
      when :scroll_line
        @line_y_offset += 5#$settings.value('text_speed')
        @line_y_offset = 23.0 if @line_y_offset >= 23.0
        draw_lines
        if @line_y_offset >= 23
          @line_y_offset = 0
          @top_line_fade = 255
          @line_images[0].dispose
          @line_images.delete_at(0)
          @line_idx-=1
          @state = :texting
        end
        
      when :waiting
        update_waiting
      when :pausing
        check_input_next
        draw_lines
      when :done
        check_input_done
        draw_lines
    end

    # skipping
    while @state == :texting && @skip_all
      @next_char > 0 ? @next_char -= 1 : update_message
    end

  end

  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  def set_side(side) 
    @side = side 
    self.bitmap = @bg_gfx = Cache.menu("chatbox")
    #Cache.menu("Text\\chat_box_white_"+@side)
    #@indent = 25 if @side == 'a'
    #@indent = 13 if @side == 'b'
  end
  def set_style(back) 
    @style = back
    case back
    when 'white'
      self.ox=0
      self.bitmap = @bg_gfx = Cache.menu("chatbox")
      #Cache.menu("Text\\chat_box_white_"+@side)
      #@indent = 25 if @side == 'a'
      #indent = 13 if @side == 'b'
      @font='white'
    when 'black'
      self.ox=0
      self.bitmap = @bg_gfx = Cache.menu("Text\\chat_box_black_"+@side)
      @indent = 25 if @side == 'a'
      @indent = 13 if @side == 'b'
      @font = 'black'
    when 'lines'
      self.ox=-12
      self.bitmap = @bg_gfx = Cache.menu("Text\\chat_box_lines")
      @indent = 25 if @side == 'a'
      @indent = 13 if @side == 'b'
      @font = 'lines'
    when 'yellow'
      self.ox=-12
      self.bitmap = @bg_gfx = Cache.menu("Text\\chat_box_yellow")
      @indent = 25 if @side == 'a'
      @indent = 13 if @side == 'b'
      @font = 'white'
    when 'brwn'
      self.ox=-12
      self.bitmap = @bg_gfx = Cache.menu("Text\\chat_box_brwn")
      @indent = 35 if @side == 'a'
      @indent = 13 if @side == 'b'
      @font = 'white'
    end
  end

  #--------------------------------------------------------------------------
  # * Setup text
  #--------------------------------------------------------------------------
  def start_text(text)

    @text_delay = @normal_speed
    
    @skip_all = false
    
    # Read the text
    #p text
    text.lstrip!
    @data = text.split(' ')
    replace_words

    # reset things
    @show_next = false    
    @line_images = []

    # prep for text
    @word_idx = -1
    @line_idx = -1
    next_line
    next_word
    
    # Prepare to open

    #nano
    #self.slide_zy(1.0)
    @state = :opening

  end  

  #--------------------------------------------------------------------------
  # * Next word
  #--------------------------------------------------------------------------
  def next_word

    @word_idx += 1
    (@show_next = true;@state = :done; return) if @word_idx >= @data.size
    @word = @data[@word_idx]
    @wordlength = @word.length

    # CHECK FOR COMMANDS
    if @word[0]=='#' || @word[0] == ';' || @word[0] == '/'
      cmd = @word.split(".")
      wrd = cmd[0]
      wrd.slice!(0)

      # check for command words
      case wrd
      
        when "nl" # New line
          next_line
          
        when "w" # wait quarter second or custom
          @wait_frames = cmd.size > 1 ? cmd[1].to_i : 15
          @state = :waiting
          
        when "ww"
          @wait_frames = 30; @state = :waiting
        when "www"
          @wait_frames = 45; @state = :waiting
        when "wwww"
          @wait_frames = 60; @state = :waiting
        when "wwwww"
          @wait_frames = 75; @state = :waiting
        when "wwwwww"
          @wait_frames = 90; @state = :waiting
        when "wwwwwww"
          @wait_frames = 105; @state = :waiting
        when "wwwwwwww"
          @wait_frames = 120; @state = :waiting
          
        when "sp"
          if cmd[1] == 'n' || cmd[1] == 'r'
            @text_delay = @normal_speed
          else
            @text_delay = cmd[1].to_i
          end
          
        when "fl"
          color = cmd.size > 1 ? Colors.get(cmd[1].to_sym) : Colors.get(:black)
          $world.do_flash(color,15)         
          
        when "s" # play sound
          Audio.se_play("Audio/SE/"+cmd[1]) 
          
        when "m","music"
          
          case cmd[1]
            when 'stop'
              @bkp = RPG::BGM.last
              Audio.bgm_stop            
            when 'fade'
              @bkp = RPG::BGM.last
              Audio.bgm_fade(750)          
            when 'resume'
              Audio.bgm_play("Audio/BGM/"+@bkp.name,@bkp.volume,@bkp.pitch,@bkp.pos)            
            else
              Audio.bgm_play("Audio/BGM/"+cmd[1])            
          end
          
        when "nw" # @^ (No wait for input)
          @state = :closing
          @show_next = false
          
        when "end"
          @state = :closing
          @show_next = false
          
      end
        
      update_waiting while @state == :waiting
      next_word

    end

  end

  #--------------------------------------------------------------------------
  # * Pop down a line
  #--------------------------------------------------------------------------
  def next_line
    @line_idx += 1
    @line_images.push(Bitmap.new(500,40))
    @line_images[@line_images.size-1].font = Fonts.get(@font+"_reg")
    @line_data = ['']
    if @line_idx > 1     
      @show_next = true     
      @state = :pausing
    end
  end

  #--------------------------------------------------------------------------
  # * Update Message
  #--------------------------------------------------------------------------
  def update_message
    
    # if the current word is empty, get the next one and see if it fits
    if @word.empty?

      next_word
      
      # Check if width will be too much, maybe add new line
      total = 0
      @line_data.each{ |w| 
        if w[0] == "%"
          total+=24+@line_images[0].text_size(' ').width 
        else
          total += @line_images[0].text_size(w+' ').width 
        end
      }      
      total += @line_images[0].text_size(@word).width
      total > @width ? next_line : @line_data.push('')      
      
    end
        
    # if not texting then don't go
    return unless @state == :texting
    
    @dodotpause = false
    @dodotpause = true if @word == "." || @word == "!" || @word == "?"
        
    # Add the next character to the final word
    @line_data[@line_data.size-1] += @word.slice!(0,1)
    #sound(:text_char) #if $settings.value('text_sound') 
    
    
    # Redraw this line of text
    cursor = 0
    @line_images[@line_idx].clear   
    @line_images[@line_idx].font = Fonts.get(@font+"_reg")
    @line_data.each{ |w|
      aw = w.dup
      if aw[0] == '^'
        aw.slice!(0)
        @line_images[@line_idx].font = Fonts.get(@font+"_bold")
      end
      if aw[0] == '~'
        aw.slice!(0)
        @line_images[@line_idx].font = Fonts.get(@font+"_talic")
      end
      if aw[0] == "%"
        aw.slice!(0)
        i = aw.to_i
        @line_images[@line_idx].blt(cursor,12,Cache.icon(i),Rect.new(0,0,24,24))
        cursor += 24+@line_images[@line_idx].text_size(' ').width
      else
        @line_images[@line_idx].draw_text(cursor,0,500,50,aw,255)
        cursor += @line_images[@line_idx].text_size(aw+' ').width
      end
      @line_images[@line_idx].font = Fonts.get(@font+"_reg")
    }

    # Wait before drawing another character
    @next_char = @text_delay
    
    # AUTO PAUSE AFTER SENTENCE HERE
    (@wait_frames = @text_delay * 5; @state = :waiting) if @word.empty? && @dodotpause && @wordlength > 1
    

  end
  
  #--------------------------------------------------------------------------
  # * Draw Lines to final image
  #--------------------------------------------------------------------------
  def draw_lines()
    
    # redraw the current line
    self.bitmap = @bg_gfx.dup

    # Draw lines    
    self.bitmap.blt(@indent,-7-@line_y_offset,@line_images[0],Rect.new(0,0,500,40),@top_line_fade)
    if @line_images.size > 1
      self.bitmap.blt(@indent,16-@line_y_offset,@line_images[1],Rect.new(0,0,500,40))
    end   

    # draw next
    snext = @style == 'black' ? Cache.menu("dots_blue") : Cache.menu("dots_gray")
    if @side == 'a'
      self.bitmap.blt(430,45,snext,Rect.new(0,0,22,6),@next_opacity)    
    else
      self.bitmap.blt(418,45,snext,Rect.new(0,0,22,6),@next_opacity)
    end
  
  end

  #--------------------------------------------------------------------------
  # * Word Replacer
  #--------------------------------------------------------------------------
  def replace_words

    idx = 0
    while(idx<@data.size) do
      word = @data[idx]

      case word
      
        when "&...", "#..."
          @data.delete_at(idx)
          @data.insert(idx,'#w.15')
          @data.insert(idx,'.')
          @data.insert(idx,'#w.15')
          @data.insert(idx,'.')
          @data.insert(idx,'#w.15')
          @data.insert(idx,'.')
          @data.insert(idx,'#w.15')
          
        when "@"
          
          @data.delete_at(idx)
          
        end
        
        idx +=1

    end

  end

  #--------------------------------------------------------------------------
  # * Update waiting
  #--------------------------------------------------------------------------
  def update_waiting
    @wait_frames -= 1
    @wait_frames = 0 if @skip_all || Graphics.frame_rate == 120
    @state = :texting if (@wait_frames < 1)
    Graphics.update
    Input.update
  end

  #--------------------------------------------------------------------------
  # * Wait for input after text is done
  #--------------------------------------------------------------------------
  def check_input_next
    if Input.trigger?(Input::B) || Input.trigger?(Input::C)
      #sound(:text_next)
      @state = :fade_line
      @show_next = false
    end
  end

  #--------------------------------------------------------------------------
  # * Wait for input after text is done
  #--------------------------------------------------------------------------
  def check_input_done
    if Input.trigger?(Input::B) || Input.trigger?(Input::C)
      #sound(:text_next)
      #self.slide_zy(0.0)
      @state = :closing
      @show_next = false
    end
  end

  #--------------------------------------------------------------------------
  # * Read from the automatic namings
  #--------------------------------------------------------------------------
  def busy?() return (@state != :closed && @state != :closing) end
  def visible?() return @state != :closed end

end
