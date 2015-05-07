#==============================================================================
# Ui_Message
#==============================================================================

class Ui_Message

  # Consts
  MIN_WIDTH = 200
  MAX_WIDTH = 350
  TAB_WIDTH = 35

  MIN_HEIGHT_FACE = 80

  SPACING = 7
  LINE_HEIGHT = 27
  PADDING_X = 21
  PADDING_Y = 16

  SPEED_1 = 0
  SPEED_2 = 1
  SPEED_3 = 2
  SPEED_4 = 3
  SPEED_5 = 4
  
  #--------------------------------------------------------------------------
  # Prepare
  #--------------------------------------------------------------------------
  def initialize(vp)

    @vp = vp

    # Create the pieces but do nothing besides
    @state = :idle

    # Hold on to the convo
    @text = ""

    @scratch = Bitmap.new(400,50)

    @lines = []

    # Settings
    @color = nil

    # Text display
    @text_delay = SPEED_4
    @wait_frames = 0
    @next_char = 0

    @cx = 0
    @cy = 0
    
    @line_idx = nil
    @word_idx = nil
    @char_idx = nil

    @width = 0
    @height = 0

    @mode = :speaker # speaker, system or vn
    @speaker = nil

    @sprites = SpriteGroup.new

    @box = Box.new(vp)
    @box.skin = $cache.menu_common("skin")
    @box.wallpaper = $cache.menu_wallpaper("diamonds")

    # Setup sprites    
    @textbox = Sprite.new(vp)
    @textbox.z += 50

    @lastchar = Sprite.new(vp)
    @lastchar.z += 50

    @namebox = Sprite.new(vp)
    @namebox.bitmap = Bitmap.new(220,40)
    @namebox.bitmap.hskin($cache.menu("Common/namebox"))

    @nametext = Sprite.new(vp)
    @nametext.bitmap = Bitmap.new(220,40)
    @nametext.bitmap.font = $fonts.namebox
    @nametext.bitmap.draw_text(0,0,220,40,"texter")

    #@next = Sprite.new(vp)
    #@next.bitmap = $cache.menu("Common/next")
    
    @face = Sprite.new(vp)
    @face.z += 10
    
    @tail = Sprite.new(vp)
    @tail.bitmap = $cache.menu("Common/tail")


    # Group system
    @sprites.add(@box)
    @sprites.add(@textbox)
    @sprites.add(@lastchar)

    @sprites.add(@namebox)
    @sprites.add(@nametext)

    #@sprites.add(@next)
    @sprites.add(@face)
    @sprites.add(@tail)

    @sprites.opacity = 0

    @sparks = []

    # Draw to textbox
    @text_bmp = nil

  end
  
  #--------------------------------------------------------------------------
  # Frame Update
  #--------------------------------------------------------------------------
  def update

    if @mode == :speaker

      @speaker = plr if !@speaker

      # Put over speaker
      x = @speaker.screen_x - @width/2 - 10
      y = @speaker.screen_y - @height - 70

      # Hiding the tail?
      h = false

      # LIMIT TO BE ON SCREEN
      if x < 7
        x = 7 
        h = true
      end
      if y < 46
        y = 46
        h = true
      end
      @tail.hide if h == true
      @tail.show if h == false

      @sprites.move(x,y)

    elsif @mode == :vn

      # put at bottom
      @sprites.move(40,320)

    end

    @box.update
    @sparks.each{ |s| s.update }
    
#~     if Input.press?(:SHIFT)
#~       @state = :closing
#~       @show_next = false
#~     end      
    
    # Skip to end of this text
    # if $input.action?
    #   @skip_all = true
    # end

    case @state

      when :closed
        #nothing

      when :opening
        @state = :texting if self.zoom_y == 1.0

      when :closing
        @state = :idle

      when :texting
        @next_char -= 1
        if @next_char <= 0 || $keyboard.state?(VK_ENTER)
          #log_err "DOING"
          update_message
        end
        redraw
        
      when :waiting
        update_waiting

        # Choices in here too

      when :pausing
        check_input_next
      when :done
        check_input_done
        
    end

    # skipping
    # while @state == :texting && $input.action?
    #   @next_char > 0 ? @next_char -= 1 : update_message
    # end

  end
  
  #--------------------------------------------------------------------------
  # Show Convo
  #--------------------------------------------------------------------------
  def start(text, choices = nil)

    @mode = :speaker

    @scratch.font = $fonts.message

    # Clear out the previous word
    @word = nil

    text_data = text.split(":")

    # Find speaker name, use to get face / event
    if text_data.count > 1
      speaker = text_data[0]
      content = text_data[1]
    else
      speaker = ""
      content = text_data[0]
    end

    # Find the speaker event
    @speaker = plr if speaker == 'boy'
    @speaker = gev(7) if speaker == 'hib'

    # TODO - add actor name to this check
    # Get face if exists
    if $data.actors.keys.include?(speaker[0..2])
      @face.bitmap = $cache.menu_face(speaker)
    else
      @face.bitmap = nil
    end

    @nametext.bitmap.clear
    @namebox.bitmap.clear

    if speaker != ""
      speaker2 = "Boyle" if speaker == 'boy'
      speaker2 = "Hi'beru" if speaker == 'hib'
      size = $fonts.size(speaker2,@nametext.bitmap.font)
      @namebox.bitmap = Bitmap.new(size.width+40,40)
      @namebox.bitmap.hskin($cache.menu("Common/namebox"))
      @nametext.bitmap.draw_gtext(0,0,220,35,speaker2,1)
    end

    # Prepare the words to be written
    @lines = split_text(content)    

    # Now of the height? How many lines are there?
    @width = max_width
    @height = @lines.count * (LINE_HEIGHT)

    @height = MIN_HEIGHT_FACE if @face.bitmap

    # Add padding
    @width += PADDING_X * 2
    @height += PADDING_Y * 2

    if @face.bitmap
      @width += @face.width 
      fx = -10 + max_width + PADDING_X + PADDING_X
      fy = 7 + @height - @face.height - PADDING_Y
      @sprites.change(@face,fx,fy)
    end

    # Prepare the sprites  
    @box.resize(@width,@height)

    #@textbox.move(@box.x,@box.y)
    @textbox.bitmap = Bitmap.new(@width,@height)

    # Can this be cut?
    @text_bmp = Bitmap.new(@width,@height)

    @scratch.font = $fonts.message
    @text_bmp.font = $fonts.message
    @textbox.bitmap.font = $fonts.message

    # COMBINE FONT AND SIZE
    @sprites.change(@tail,@width/2-2,@height)
    #@sprites.change(@next,@width/2,@height-20)

    @sprites.change(@namebox,20,-@namebox.height)
    @sprites.change(@nametext,40,-@namebox.height+5)



    @sprites.do(go("opacity",255,500,:quad_in_out))
    #@sprites.do(go("y",-25,500,:quad_in_out))

    @line_idx = 0
    @word_idx = -1

    @cx = PADDING_X
    @cy = PADDING_Y

    # Start text
    @state = :texting

        
  end

  # **************************************************

  # VN MODE

  # **************************************************


  def start_vn(text)

    # VN MODE!
    @mode = :vn
    @tail.hide

    @scratch.font = $fonts.message

    # Clear out the previous word
    @word = nil

    text_data = text.split(":")

    # Find speaker name, use to get face / event
    if text_data.count > 1
      speaker = text_data[0]
      content = text_data[1]
    else
      speaker = ""
      content = text_data[0]
    end

    # TODO - add actor name to this check
    # Get face if exists
    @face.bitmap = nil


    @nametext.bitmap.clear
    @namebox.bitmap.clear

    if speaker != ""
      speaker2 = "Boyle" if speaker == 'boy'
      speaker2 = "Hi'beru" if speaker == 'hib'
      size = $fonts.size(speaker2,@nametext.bitmap.font)
      @namebox.bitmap = Bitmap.new(size.width+40,40)
      @namebox.bitmap.hskin($cache.menu("Common/namebox"))
      @nametext.bitmap.draw_gtext(0,0,220,35,speaker2,1)
    end

    # Prepare the words to be written
    @lines = split_text(content)    

    # Now of the height? How many lines are there?
    @width = 520#MAX_WIDTH
    @height = 3 * LINE_HEIGHT

    #@height = MIN_HEIGHT_FACE if @face.bitmap

    # Add padding
    @width += PADDING_X * 2
    @height += PADDING_Y * 2

    # Prepare the sprites  
    @box.resize(@width,@height)

    #@textbox.move(@box.x,@box.y)
    @textbox.bitmap = Bitmap.new(@width,@height)

    # Can this be cut?
    @text_bmp = Bitmap.new(@width,@height)

    @scratch.font = $fonts.message
    @text_bmp.font = $fonts.message
    @textbox.bitmap.font = $fonts.message

    # COMBINE FONT AND SIZE
    @sprites.change(@tail,@width/2-2,@height)
    #@sprites.change(@next,@width/2,@height-20)

    @sprites.change(@namebox,20,-@namebox.height)
    @sprites.change(@nametext,40,-@namebox.height+5)



    @sprites.do(go("opacity",255,500,:quad_in_out))
    #@sprites.do(go("y",-25,500,:quad_in_out))

    @line_idx = 0
    @word_idx = -1

    @cx = PADDING_X
    @cy = PADDING_Y

    # Start text
    @state = :texting

  end

  #--------------------------------------------------------------------------
  # * Update Message
  #--------------------------------------------------------------------------
  def update_message
    
    # if the current word is empty, get the next one and see if it fits
    next_word if @word == nil || @char_idx > @word.length
        
    # if not texting then don't go
    return unless @state == :texting
            
    # Add the next character to the final word
    @char_idx += 1

    # Play a lovely character sound
    #sound(:text_char) if $settings.value('text_sound') 
    
    # Wait before drawing another character
    @next_char = @text_delay

    # Show the behind char anim
        # Spawn spark
    sprk = Spark.new("message.28",@vp)

    txt = @word.delete('*^')[0..@char_idx-1]
    size = @scratch.text_size(txt)

    #return if size.width < 10
    
    x = @sprites.x + @cx+size.width
    y = @sprites.y + @cy
    sprk.center(x+4,y+16)
    #sprk.blend_type = 1
    @sparks.push(sprk)
    
    # AUTO PAUSE AFTER SENTENCE HERE
    #(@wait_frames = @text_delay * 5; @state = :waiting) if @word.empty? && @dodotpause && @wordlength > 1
    

  end

  def redraw

    @textbox.bitmap.clear    
    @textbox.bitmap.blt(0,0,@text_bmp,@text_bmp.rect)

    return if @word == nil

    @scratch.font.bold = @word.include?("*")
    @scratch.font.italic = @word.include?("^")

    @textbox.bitmap.font.bold = @word.include?("*")
    @textbox.bitmap.font.italic = @word.include?("^")

    #txt = @word[0..@char_idx-1]
    txt = @word.delete('*^')[0..@char_idx-1]
    txt2 = @word.delete('*^')[@char_idx..@char_idx]

    size = @scratch.text_size(txt)

    # SHADOW HERE FOR THE WORD IN PROGRESS

    @textbox.bitmap.draw_gtext(@cx,@cy,300,LINE_HEIGHT,txt)

    # Half draw the final
    return if @char_idx >= @word.length

    # Offset the y here to animate
    #r = rand(4)
    r = 0
    op = 220 - @next_char * 50

    @textbox.bitmap.font = $fonts.message_shadow
    @textbox.bitmap.font.color.alpha = op
    @textbox.bitmap.draw_text(@cx+r+size.width+2,@cy+r+2,100,LINE_HEIGHT,txt2)

    @textbox.bitmap.font.color.alpha = 255


    @textbox.bitmap.font = $fonts.message
    @textbox.bitmap.font.color.alpha = op
    @textbox.bitmap.draw_gtext(@cx+r+size.width,@cy+r,100,LINE_HEIGHT,txt2)

    @textbox.bitmap.font.color.alpha = 255


    # Maybe last char so this can redraw fast, maybe don't even need


  end

  def redraw_last


  end

  #--------------------------------------------------------------------------
  # * Pop down a line
  #--------------------------------------------------------------------------
  def next_line
    @line_idx += 1
    @word = nil
    if @line_idx >= @lines.count
      @state = :done
      @box.skin = $cache.menu_common("skin-gold")
    else
      @word_idx = 0
      @cy += LINE_HEIGHT
      @cx = PADDING_X
    end
  end

    #--------------------------------------------------------------------------
  # * Next word
  #--------------------------------------------------------------------------
  def next_word

    # blit last word onto the main bmp
    if @word != nil

      @text_bmp.font.bold = @word.include?('*')
      @text_bmp.font.italic = @word.include?('^')

      txt = @word.delete('*^')[0..@char_idx]

      @text_bmp.font = $fonts.message_shadow
      @text_bmp.font.bold = @word.include?('*')
      @text_bmp.font.italic = @word.include?('^')
      @text_bmp.draw_text(@cx+2,@cy+2,300,LINE_HEIGHT,txt)

      @text_bmp.font = $fonts.message
      @text_bmp.font.bold = @word.include?('*')
      @text_bmp.font.italic = @word.include?('^')
      @text_bmp.draw_gtext(@cx,@cy,300,LINE_HEIGHT,txt)

      # Step cursor
      @cx += word_width(@word)

    end

    @word_idx += 1
    @char_idx = 0
    
    if @word_idx >= @lines[@line_idx].count
      next_line
      return if @line_idx >= @lines.count
    end

    @word = @lines[@line_idx][@word_idx]

    return if @word == nil

    # CHECK FOR COMMANDS
    if @word.include?('$')
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
                    
        when "$s" # play sound
          #log_err("TRYPLAYIT")
          #Audio.se_play("Audio/SE/"+cmd[1]) 
          
        when "$m"
          
          case cmd[1]
            when 'stop'
              Audio.bgm_stop            
            when 'fade'
              Audio.bgm_fade(750)                   
            else
              Audio.bgm_play(cmd[1])            
          end
          
        when "$nw" # @^ (No wait for input)
          @state = :closing
          @show_next = false
          
        when "$end"
          @state = :closing
          @show_next = false
          
      end
        
      update_waiting while @state == :waiting
      @word = nil
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
    if $input.action? || $input.click?
      #sound(:text_next)
      #self.slide_zy(0.0)
      @state = :closing
      @textbox.bitmap.clear
      @sprites.opacity = 0
      @box.skin = $cache.menu_common("skin")
      #@sprites.do(go("opacity",-255,300,:quad_in_out))
    end
  end

  #--------------------------------------------------------------------------
  # Calculate size
  #--------------------------------------------------------------------------
  def word_width(word)
      return TAB_WIDTH if word == "$t"
      return 0 if word.include?("$")
      @scratch.font.bold = word.include?('*')
      @scratch.font.italic = word.include?('^')
      return @scratch.text_size(word.delete('*^')).width + SPACING
  end

  def max_width
    max = 0
    @lines.each{ |line|
      width = line.inject(0) { |t,w| t + word_width(w) }
      max = width if width > max
    }
    return max - SPACING
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
      return [text.split(" ")]
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
