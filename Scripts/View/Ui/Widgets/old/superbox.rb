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

class Letter < Sprite

  attr_accessor :px, :py, :ox, :oy

  def initialize
    super

    @px = 0
    @py = 0
    @ox = 0
    @oy = 0

  end

  def update
    super
    self.x = @px# + @ox
    self.y = @py# + @oy
  end

end

class Sprite_Superbox < Widget

  attr_accessor :padding_left, :padding_top, :padding_right, :padding_bottom


  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def create

    @state = :closing

    @contents = Layer.new(700)
    #@contents.color = Color.new(255,0,0,120)
    @next = Sprite.new()
    @choice = Sprite.new()

    # text speed
    @normal_speed = 2 #-$settings.value('text_speed')
    @text_delay = @normal_speed
    
    # Internal tracking
    @skip_all = false
    @wait_frames = 0
    @next_char = 0   

    @data = nil # All text
    @word = "" # Remainder of current word

    @title = @parent.add(Widget_Label.new)
     @title.text = "Peter Punkineater"
     @title.skin = 'skin-red'
     @title.link(self,-12,-26)
     @title.z += 1
     @title.font = Fonts.get('title')
     @title.refresh
    
    #@padding = Bounds.new()
    @padding_left = 16
    @padding_top = 14#234
    @padding_right = 10
    @padding_bottom = 20

    @line_spacing = 6

    @cx = @padding_left
    @cy = @padding_top
    
    @font = Fonts.get('textbox')    
    self.bitmap = Cache.menu("chatbox")


    @effects = []

     # # For choices
     # @cursor = @parent.add(Widget.new)
     # @cursor.from_menu("cursor")
     # @cursor.z = self.z + 1
     # @cursor.x = self.x + 5
     # @cursor.do(pingpong("x",10,250,:quad_in_out))

  end

  #--------------------------------------------------------------------------
  # * Frame Update
  #--------------------------------------------------------------------------
  def update
    super

    # Position content viewport
    @contents.rect.x = self.x 
    @contents.rect.y = self.y  
    @contents.rect.width = self.bitmap.width 
    @contents.rect.height = self.bitmap.height

    @contents.update
   
    # Skip to end of this text, line i guess, but maybe don't have this
    
    case @state

      when :closing, :opening
       # log_append("CLOSINGG")

      when :texting
        #if Input.trigger?(Input::C)
          #@skip_all = true
        #end
        return if !$machine.done?(self)
        @next_char -= 1
        if @next_char <= 0
          update_message
          update_message if @text_delay < 0
        end

        # text effects
        @effects.each{ |fx|


        }

      when :scroll_line
        if @contents.sprites.select{ |letter| letter.y > 0 }.empty?
          # removethe sprites
          @contents.clear
          #clear out lines and continue
          @cx = @padding_left
          @cy = @padding_top
          @state = :texting
          @line_idx = -1
        end        

      when :waiting
        update_waiting

      when :pausing
        check_input_next

      when :done
        check_input_done

      when :choice
        check_input_choice

    end

    # skipping
    # while @state == :texting && @skip_all
    #   @next_char > 0 ? @next_char -= 1 : update_message
    # end

  end

  #--------------------------------------------------------------------------
  # * Setup
  #--------------------------------------------------------------------------
  def set_style(back) 
      self.bitmap = Cache.menu("chatbox")
  end

  #--------------------------------------------------------------------------
  # * Setup text
  #--------------------------------------------------------------------------
  def start_text(text)

    @text_delay = @normal_speed
    
    @skip_all = false
    
    # Read the text
    text.lstrip!
    @data = text.split(' ')

    # prep for text
    @word_idx = -1
    @line_idx = -1
    @cx = @padding_left
    @cy = @padding_top #+ @line_spacing

    #next_line
    next_word

    #nano
    @state = :texting

  end  

  #--------------------------------------------------------------------------
  # * Next word
  #--------------------------------------------------------------------------
  def next_word

    @word_idx += 1
    @word = @data.shift
    (@show_next = true;@state = :done; return) if @word == nil
    @wordlength = @word.length

    # CHECK FOR SCRIPT
    if @word[0]=="*"
      # build this script to eval
      # until finding another *
      script = @word
       if @word[-1,1] == "*"
        eval(script.tr('*',''))
        return next_word
      end

      @word = @data.shift

      while !@word.include?("*")
        @word = @data.shift
        script += ' ' + @word
      end

      eval(script.tr('*',''))

      update_waiting while @state == :waiting
      return next_word
    end

    if @word == "@" # Choice
      next_line
    end

    if @word[0] == "%" # Effects
      
      case @word

        when "%"
          # End current effect


        when "%scared"

          fx = {}
          fx[:type] = :scared
          fx[:power] = 10
          fx[:letters] = []

      end

    end


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
          
        when "sp"
          if cmd[1] == 'n' || cmd[1] == 'r'
            @text_delay = @normal_speed
          else
            @text_delay = cmd[1].to_i
          end
          
        when "fl"
          color = cmd.size > 1 ? Colors.get(cmd[1].to_sym) : Colors.get(:black)
          $world.do_flash(color,15)         

        when "f"
          @font = Fonts.get(cmd[1])
          
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

    @cx = @padding_left
    @cy += @line_spacing + @font.height

    @line_idx += 1
    log_append("LINEIDX")
    log_append(@line_idx)

    # If the first character is @ this is a choice!
    if @word == "@"
      @cx += 20
      next_word
    end

    if @cy > @contents.rect.height - @padding_top - @padding_bottom # check if cursor will push below
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
      return if @word == nil

      @cx += @font.letter(" ").width

      # count width of next word
      cx = @cx 
      cx += @font.width(@word)

      next_line if cx > @contents.rect.width - @padding_left - @padding_right
      
    end
        
    # if not texting then don't go
    return unless @state == :texting
    
    @dodotpause = false
    @dodotpause = true if @word == "." || @word == "!" || @word == "?"
        
    # Add the next character to the final word
    #@line_data[@line_data.size-1] += @word.slice!(0,1)

    chr = @word.slice!(0,1)

    # CREATE THE LETTER!
    letter = Letter.new()


    letter.bitmap = @font.letter(chr)
    #letter.color = Color.new(rand(255),rand(255),rand(255))
    #letter.bitmap.font = Fonts.get(@font+"_reg")
    letter.ox = letter.bitmap.width/2

    @cx += letter.ox - @font.outline
    
    letter.px = @cx
    letter.py = @cy
    #letter.update

    letter.opacity = 0
    letter.do(to("opacity",255,20))
    #letter.do(go("y",-400,5000))
    
    #letter.do(sequence(go("zoom_x",1.0,50),go("zoom_x",-1.0,100)))
    
    #letter.do(sequence(go("zoom_y",2.5,1),go("zoom_y",-2.5,300)))
    #letter.do(sequence(go("zoom_x",2.5,1),go("zoom_x",-2.5,300)))
    
    #letter.do(pingpong("y",2,300,:quad_in_out))
    #letter.do(pingpong("x",2,300,:quad_in_out))
    #@letters.push(letter)
    @contents.add(letter)
    @cx += (letter.bitmap.width-letter.ox) + 0 - @font.shadow + @font.outline

    #sound(:text_char) #if $settings.value('text_sound') 

    # Wait before drawing another character
    @next_char = @text_delay
    
    # AUTO PAUSE AFTER SENTENCE HERE
    (@wait_frames = @text_delay * 3; @state = :waiting) if @word.empty? && @dodotpause && @wordlength > 1
    

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
    if Input.trigger?(Input::C)
      #sound(:text_next)
      @contents.sprites.each{ |letter|
        letter.do(go("y",-200,1000))
      }
      @state = :scroll_line
    end
  end

  #--------------------------------------------------------------------------
  # * Wait for input after text is done
  #--------------------------------------------------------------------------
  def check_input_done

    if Input.trigger?(Input::C)
     
      #sound(:text_next)

      log_append("CLOSEIT")
            @contents.sprites.each{ |letter|
        letter.do(go("y",-200,1000))
      }
      @state = :closing
    end

  end

  def check_input_choice

  end

  #--------------------------------------------------------------------------
  # * Read from the automatic namings
  #--------------------------------------------------------------------------
  def busy?() 
    return false if @state == :closing
    return !$machine.done?(self) if @state == :opening || @state == :closing
    return true
  end

end
