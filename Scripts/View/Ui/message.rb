#==============================================================================
# Ui_Message
#==============================================================================

class Ui_Message < Ui_Base

  # Consts
  MIN_WIDTH = 200
  MAX_WIDTH = 500
  TAB_WIDTH = 35

  SPACING = 5
  LINE_HEIGHT = 22

  SPEED_1 = 0
  SPEED_2 = 1
  SPEED_3 = 2
  SPEED_4 = 3
  SPEED_5 = 4
  
  #--------------------------------------------------------------------------
  # Prepare
  #--------------------------------------------------------------------------
  def initialize
    super(500)

    # Create the pieces but do nothing besides
    @state = :idle

    # Hold on to the convo
    @text = ""

    # This line data
    @name = ''

    @scratch = Bitmap.new(400,50)

    # Hold the textbox, 
    #@text_viewport

    @lines = []



    # Settings
    @font = nil
    @bold = true
    @italic = true
    @color = nil

    # Text display
    @text_delay = SPEED_3
    @wait_frames = 0
    @next_char = 0
    
    @line_idx = nil
    @word_idx = nil
    @char_idx = nil

    @width = 0
    @height = 0

    # Setup sprites
    @textbox = Sprite.new
    @namebox = Sprite.new

    @next = Sprite.new
    @face = Sprite.new

    @text_sprite = Sprite.new
    @word_sprite = Sprite.new    
    
  end
  
  #--------------------------------------------------------------------------
  # Frame Update
  #--------------------------------------------------------------------------
  def update
    super
    
#~     if Input.press?(:SHIFT)
#~       @state = :closing
#~       @show_next = false
#~     end      
    
    # Skip to end of this text
    if Input.trigger?(Input::C) && @state = :texting
      @skip_all = true
    end

    case @state

      when :closed
        #nothing

      when :opening
        @state = :texting if self.zoom_y == 1.0

      when :closing


      when :texting
        @next_char -= 1
        if @next_char <= 0
          update_message
        end
        
      when :waiting
        update_waiting

        # Choices in here too

      when :pausing
        check_input_next
      when :done
        check_input_done
        
    end

    # skipping
    while @state == :texting && @skip_all
      @next_char > 0 ? @next_char -= 1 : update_message
    end

  end
  
  #--------------------------------------------------------------------------
  # Show Convo
  #--------------------------------------------------------------------------
  def start(text, choices = nil)

    text_data = text.split(":")

    # Find speaker name, use to get face / event
    speaker = text_data[0]

    # Prepare the words to be written
    @lines = split_text(text_data[1])    

    # Now of the height? How many lines are there?
    @width = max_width
    @height = @lines.count * (LINE_HEIGHT)

    # Prepare the sprites
    @text_sprite.bitmap = Bitmap.new(@width,@height)

    @line_idx = -1
    @word_idx = -1

    @word_sprite.x = -1

    next_line
    next_word



    # Start text
    @state = :texting

        
  end

  #--------------------------------------------------------------------------
  # * Update Message
  #--------------------------------------------------------------------------
  def update_message
    
    # if the current word is empty, get the next one and see if it fits
    next_word if @char_idx == @word.length
        
    # if not texting then don't go
    return unless @state == :texting
            
    # Add the next character to the final word
    @char_idx += 1
    #@line_data[@line_data.size-1] += @word.slice!(0,1)
    
    # Redraw the word, last char small?
    redraw_word

    # Play a lovely character sound
    #sound(:text_char) if $settings.value('text_sound') 
    
    # Wait before drawing another character
    @next_char = @text_delay
    
    # AUTO PAUSE AFTER SENTENCE HERE
    #(@wait_frames = @text_delay * 5; @state = :waiting) if @word.empty? && @dodotpause && @wordlength > 1
    

  end

  def redraw_word
    @word_sprite.bitmap.clear
    txt = @word[0..@char_idx-1]
    size = @scratch.text_size(txt)
    @word_sprite.bitmap.draw_text(0,0,300,LINE_HEIGHT,txt)
    # Half draw the final
    @word_sprite.bitmap.draw_text(size.width,0,100,LINE_HEIGHT,@word[@char_idx])
  end

  #--------------------------------------------------------------------------
  # * Pop down a line
  #--------------------------------------------------------------------------
  def next_line
    @line_idx += 1
    if @line_idx >= @lines.count
      @state = :done
    else
      @word_idx = -1
      @word_sprite.x = 0
      @word_sprite.y += LINE_HEIGHT
      next_word
    end
  end

    #--------------------------------------------------------------------------
  # * Next word
  #--------------------------------------------------------------------------
  def next_word

    # blit last word onto the main bmp


    @word_idx += 1
    @char_idx = 0
    
    if @word_idx >= @lines[@line_idx].count
      return next_line
    end

    @word = @lines[@line_idx][@word_idx]
    @wordlength = @word.length

    # CHECK FOR COMMANDS
    if @word[0]=='$'
      cmd = @word.split(".")
      wrd = cmd[0]

      # check for command words
      case wrd
      
        when "$n" # New line
          next_line
          
        when "$w" # wait quarter second or custom
          @wait_frames = cmd.size > 1 ? cmd[1].to_i : 15
          @state = :waiting
                    
        when "$sp"
          if cmd[1] == 'n' || cmd[1] == 'r'
            @text_delay = @normal_speed
          else
            @text_delay = cmd[1].to_i
          end
          
        when "$fl"
          color = cmd.size > 1 ? Colors.get(cmd[1].to_sym) : Colors.get(:black)
          $world.do_flash(color,15)         
          
        when "$s" # play sound
          Audio.se_play("Audio/SE/"+cmd[1]) 
          
        when "$m"
          
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
          
        when "$nw" # @^ (No wait for input)
          @state = :closing
          @show_next = false
          
        when "$end"
          @state = :closing
          @show_next = false
          
      end
        
      update_waiting while @state == :waiting
      next_word

    end

  end  

  #--------------------------------------------------------------------------
  # * Update waiting
  #--------------------------------------------------------------------------
  def update_waiting
    @wait_frames -= 1
    @wait_frames = 0 if @skip_all #|| Graphics.frame_rate == 120
    @state = :texting if (@wait_frames < 1)
  end

  #--------------------------------------------------------------------------
  # * Wait for input after text is done
  #--------------------------------------------------------------------------
  def check_input_done
    if Input.trigger?(Input::C)
      #sound(:text_next)
      #self.slide_zy(0.0)
      @state = :closing
      @next_sprite.hide
      
      @text_sprite.clear
    end
  end

  #--------------------------------------------------------------------------
  # Calculate size
  #--------------------------------------------------------------------------
  def word_width(word)
      return TAB_WIDTH if word == "$t"
      return 0 if word.include?("$")
      return @scratch.text_size(word).width
  end

  def max_width
    max = 0
    @lines.each{ |line|
      width = line.inject(0) { |t,w| t + word_width(w) }
      max = width if width > max
    }
    return max
  end

  def split_text(text)

    # Split all text into lines
    # Then calc widths and that

    total_width = text.split(" ").inject(0) { |t, w| t + word_width(w) }

    # use total width to split into lines

    # If there is a forced newline, there will be no autosizing
    if text.include?("$n")
      return text.split("$n").map { |i| i = i.split(" ") }  
    end

    # If less than split width, just one line
    if total_width < MIN_WIDTH
      reutrn [text.split(" ")]
    end

    # If width is less than max * 2, we are splitting at the first word after half point
    if total_width < MAX_WIDTH * 2
      limit = total_width / 2
      cursor = 0
      lines = [[]]
      text.split(" ").each{ |word|
        lines[-1].push(word)
        cursor += word_width(word)
        if cursor >= limit
          lines.push([])
          cursor = 0
        end
      }
      return lines
    end

    # Else we are autosizing max width
    lines = [[]]
    limit = MAX_WIDTH
    cursor = 0
    text.split(" ").each{ |word|
      cursor += word_width(word)
      if cursor > limit
        cursor = 0
        lines.push([])
      end
      lines[-1].push(word)
    }
    return lines

  end

  #--------------------------------------------------------------------------
  # Misc
  #--------------------------------------------------------------------------
  def clear() end
  def busy?() return @state != :idle end

end