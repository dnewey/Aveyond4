#==============================================================================
# Ui_Message
#==============================================================================

class Ui_Message

  # Consts
  MIN_WIDTH = 200
  MAX_WIDTH = 400
  MAX_WIDTH_VN = 480
  TAB_WIDTH = 35

  VN_WIDTH = 520

  MIN_HEIGHT_FACE = 80

  SPACING = 7
  LINE_HEIGHT = 27
  LINE_HEIGHT_BIG = 33
  PADDING_X = 21
  PADDING_Y = 16

  CHOICE_DELAY = 30

  SPEED_1 = 9
  SPEED_2 = 7
  SPEED_3 = 5
  SPEED_4 = 3
  SPEED_5 = 2

  attr_reader :last_choice
  attr_accessor :force_name
  attr_accessor :force_vn

  attr_reader :mode
  
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
    @line_height = LINE_HEIGHT

    # Settings
    @color = nil
    @font = $fonts.message
    @font_shadow = $fonts.message_shadow

    # Text display
    @text_delay = SPEED_4
    @normal_speed = SPEED_4
    @wait_frames = 0
    @next_char = 0

    @choice_delay = CHOICE_DELAY # Make choice wait before allowing click

    @cx = 0
    @cy = 0
    
    @line_idx = nil
    @word_idx = nil
    @char_idx = nil

    @width = 0
    @height = 0

    @mode = :speaker # speaker, system or vn
    @speaker = nil
    @force_name = nil
    @force_vn = false

    @vn_port = Sprite.new(vp)
    @vn_port.opacity = 0

    @sprites = SpriteGroup.new

    @box = Box.new(vp)
    @box.skin = $cache.menu_common("skin")
    @box.wallpaper = $cache.menu_wallpaper("diamonds")
    #@box.wallpaper = $cache.menu_wallpaper("fangder")
    @box.scroll(0.1,0.1)

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

    @sprites.add(@namebox,20,-@namebox.height+16)
    @sprites.add(@nametext,40,-@namebox.height+19)

    #@sprites.add(@next)
    @sprites.add(@face)
   # @sprites.add(@tail)

    @sprites.opacity = 0

    @sparks = []

    # Draw to textbox
    @text_bmp = nil

    @grid = nil
    @choices = []
    @last_choice = ''

  end

  def dispose
    @box.dispose
    @textbox.dispose
    @lastchar.dispose
    @namebox.dispose
    @nametext.dispose
    @face.dispose
    @tail.dispose
    @sparks.each{ |s| s.dispose }
  end

  def wallpaper=(w)
    @box.wallpaper = $cache.menu_wallpaper(w)
    if w == 'fangder'
      @box.alpha = 255
    else
      @box.alpha = 230
    end
  end
  
  #--------------------------------------------------------------------------
  # Frame Update
  #--------------------------------------------------------------------------
  def update

    @grid.update if @grid

    if @mode == :message

      @speaker = plr if !@speaker

      # Put over speaker
      x = @speaker.screen_x - @width/2 - 10
      y = @speaker.screen_y - @height - @speaker.gfx_height - 22 + @speaker.faceoff

      # Hiding the tail?
      h = false

      # LIMIT TO BE ON SCREEN
      if x < 7
        x = 7 
        #h = true
      end
      if y < 46
        #y = 290
        #h = true
      end
      if x > 640-@width-10
        x = 640-@width-10
        #h = true
      end
      if y > 480-@height-10
        y = 480-@height-10
        h = true
      end
      # @tail.bitmap = $cache.menu("Common/tail2") if h == true
      # @tail.bitmap = $cache.menu("Common/tail") if h == false

      @sprites.move(x,y)

      x = @speaker.screen_x - 12# - @width/2
      y = @speaker.screen_y - @speaker.gfx_height - 22  + @speaker.faceoff # - @height

      @tail.move(x,y)      

    end

    @tail.opacity = @sprites.opacity

    @box.update
    @sparks.delete_if { |s| s.done? }
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
        if @next_char <= 0
          #log_err "DOING"
          update_message
        end
        redraw

        if $input.action? || $input.click?
      
          @super_skipping = true
          while @state == :texting

            update_message           
          end
          @super_skipping = false
          redraw
          
        end
        
      when :waiting
        update_waiting

        # Choices in here too

      #when :pausing
      #  check_input_next
      when :choice
        @choice_delay -= 1
        check_input_choice
      when :done
        check_input_done
        
    end

    # skipping
    # while @state == :texting && $input.action?
    #   @next_char > 0 ? @next_char -= 1 : update_message
    # end

  end

  def add_choice(choice)
    @choices.push(choice)
    @choice_delay = CHOICE_DELAY
  end

  #--------------------------------------------------------------------------
  # Show Convo
  #--------------------------------------------------------------------------
  def start(text, choices = nil)

    $tweens.clear(@sprites)

    # Clear previous sparks
    @sparks.each { |s| s.dispose }
    @sparks = []

    @mode = :message

    # Reset
    @face.bitmap = nil
    #@vn_port.bitmap = nil
    @vn_port.do(to("opacity",0,-11))
    @speaker = nil
    @line_idx = 0
    @word_idx = -1
    @cx = PADDING_X
    @cy = PADDING_Y
    @text_delay = @normal_speed

    @tail.show

    return log_err "Must specify speaker" if !text.include?(':')
    text_data = text.split(":")

    # Read data to get name and text
    speaker = text_data[0]
    
    if speaker.include?("x-")
      @tail.hide
      @mode = :x
      speaker = speaker.sub("x-",'')
    end

    if speaker.include?("z-")
      @font = $fonts.message_big
      @font_shadow = $fonts.message_big_shadow
      @line_height = LINE_HEIGHT_BIG
      speaker = speaker.sub("z-",'')
    elsif speaker.include?("t-")
      @font = $fonts.message_tiny
      @font_shadow = $fonts.message_tiny_shadow
      speaker = speaker.sub("t-",'')
    else
      @font = $fonts.message
      @font_shadow = $fonts.message_shadow
      @line_height = LINE_HEIGHT
    end

    # Figure things out from speaker
    #speaker = gev(speaker.to_i).name if speaker.numeric? # This is cut so you can just do 25: Text, instead of npc2, npc3
    from_this = false
    if ['this','me','This'].include?(speaker)
      from_this = true
      speaker = this.name
    end
    name = speaker.gsub(/\A[\d_\W]+|[\d_\W]+\Z/, '') # Remove numbers

    # Special allowance for names of ???
    name = "???" if speaker.include?("???")

    # Check the mode
    if speaker.include?("vn-") || @force_vn
      speaker = speaker.sub("vn-",'')
      name = name.sub("vn-",'')
      @mode = :vn

      @tail.hide

      # Hack to hide vn face on gameover
      if !$scene.is_a?(Scene_GameOver)

        # Set vn face
        @vn_port.bitmap = $cache.face_vn(speaker)
        @vn_port.x = ($game.width - @vn_port.width)/2
        @vn_port.y = $game.height - @vn_port.height
        #@vn_port.opacity = 0
        $tweens.clear(@vn_port)
        @vn_port.do(go("opacity",255,400,:quad_in_out))
        #speaker = nil

      end

    end

    # System message
    if speaker.split("-")[0] == 'sys' || speaker.split("-")[0] == 'top'
      @mode = speaker.split("-")[0].to_sym
      if speaker.split("-").count > 1
        @box.wallpaper = $cache.menu_wallpaper(speaker.split("-")[1])
      end
      speaker = nil
      name = ''      
      @tail.hide
    end
    
    # If in party, show as player and change player graphic
    if @mode != :vn
      if speaker != nil && $party.all.include?(speaker.split('-')[0]) && (@mode == :message || @mode==:x)
        @speaker = $player
        $player.looklike(name.split('-')[0])
      elsif speaker != nil
        if from_this
          @speaker = this
        else
          @speaker = gev(speaker.split("-")[0])
        end
        @mode = :sys if @speaker == nil
      end
    end

    # Force name to not have the number
    name.delete!('123456789')

    # Get face and name of player characters
    if $data.actors.has_key?(name.split('-')[0])
      @face.bitmap = $cache.face(name) if @mode == :message || @mode == :x
      name = $data.actors[name.split('-')[0]].name
    end

    # If forcing to speak from a number, switch to name now
    if speaker != nil && speaker.numeric?
      name = gev(speaker.to_i).name
      name = name.gsub(/\A[\d_\W]+|[\d_\W]+\Z/, '') # Remove numbers
    end

    build_namebox(name.split("-")[0])

    # Chance wallpaper as needed
    build_wallpaper(name.split("-")[0])   

    # Force split the lines
    @lines = split_text(text_data[1]) 

    # Textbox size
    @width = max_width + PADDING_X * 2
    if (@namebox.width + 44) > @width
      @width = @namebox.width + 44 
    end
    @height = (@lines.count * @line_height) + PADDING_Y * 2

    # Position the face
    if @face.bitmap
      @width += @face.width 
      @height = MIN_HEIGHT_FACE  + PADDING_Y * 2
      #fx = -10 + max_width + PADDING_X + PADDING_X # OLD, NOT SURE WHAT IT WAS TRYING TO DO
      fx = -10 + @width - @face.width
      fy = 7 + @height - @face.height - PADDING_Y
      @sprites.change(@face,fx,fy)
      @face.ox = 15
      @face.do(go("ox",-15,500,:qio))
    end

    if @mode == :vn
      @width = VN_WIDTH
      @height = (3 * @line_height) + PADDING_Y * 2
    end

    # Prepare the sprites  
    @box.resize(@width,@height)
    @textbox.bitmap = Bitmap.new(@width,@height)
    @text_bmp = Bitmap.new(@width,@height)
    
    @text_bmp.font = @font
    @textbox.bitmap.font = @font

    # Point tale x at speaker and y under box
    # Would need to be put in update
    @sprites.change(@tail,@width/2-2,@height)
    #@sprites.change(@next,@width/2,@height-20)
    $tweens.clear(@sprites)
    @sprites.do(go("opacity",255,500,:quad_in_out))
    $tweens.clear(@tail)
    @tail.do(go("opacity",255,500,:quad_in_out))
    
    #@sprites.do(go("y",-25,500,:quad_in_out))

    # Start writing    
    @state = :texting

    # Position for system messages
    if @mode == :vn
      @sprites.move(($game.width-@width)/2,320)
    end

    if @mode == :x
      @sprites.move(($game.width-@width)/2,320)
    end

    if @mode == :sys
      @sprites.move(($game.width-@width)/2,220)
    end
        
    if @mode == :top
      @sprites.move(($game.width-@width)/2,50)
    end

  end

  def build_namebox(name)

      name = @force_name if @force_name != nil

      # Create the namebox
      @nametext.bitmap.clear
      @namebox.bitmap.clear

      return if name == 'abc'
      return if name == ''
      return if name == nil

      size = $fonts.size(name,@nametext.bitmap.font)
      @namebox.bitmap = Bitmap.new(size.width+40,40)
      @namebox.bitmap.hskin($cache.menu("Common/namebox"))
      @nametext.bitmap.draw_gtext(0,0,220,35,name,1)

  end

  def build_wallpaper(name)

    if $scene.is_a?(Scene_Battle)
      #$scene.hud.message.wallpaper = 'diamonds'
      return
    end

    case name

      when '???'
        wallpaper = 'fangder'

      when 'Chester'
        wallpaper = 'wizard'

      else
        wallpaper = 'diamonds'

    end

  end

  #--------------------------------------------------------------------------
  # * Update Message
  #--------------------------------------------------------------------------
  def update_message

    skip_wait_test = false
    
    # if the current word is empty, get the next one and see if it fits
    if @word == nil || @char_idx > @word.length
      next_word
      skip_wait_test = true
    end
        
    # if not texting then don't go
    return unless @state == :texting
            
    # Add the next character to the final word
    @char_idx += 1

    # Play a lovely character sound
    sys('talk2',0.15) if !@super_skipping
    
    # Wait before drawing another character
    @next_char = @text_delay if !skip_wait_test

    # Show the behind char anim
        # Spawn spark
    

    txt = @word.delete('*^')[0..@char_idx-1]
    size = @scratch.text_size(txt)

    #return if size.width < 10
    
    x = @sprites.x + @cx+size.width
    y = @sprites.y + @cy

    return if @super_skipping #|| (@char_idx >= @word.length-1 && @char_idx > 0)

    sprk = Spark.new("message.28",x-4,y+16,@vp) # Faster with higher opacity perhaps
    #sprk.center()
    #sprk.blend_type = 1
    sprk.opacity = 30
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

    @textbox.bitmap.draw_gtext(@cx,@cy,300,@line_height,txt)

    # Half draw the final
    return if @char_idx >= @word.length
    return

    # Offset the y here to animate
    #r = rand(4)
    r = 0
    op = 220 - @next_char * 50

    @textbox.bitmap.font = @font_shadow
    @textbox.bitmap.font.color.alpha = op
    @textbox.bitmap.draw_text(@cx+r+size.width+2,@cy+r+2,100,@line_height,txt2)

    @textbox.bitmap.font.color.alpha = 255


    @textbox.bitmap.font = @font
    @textbox.bitmap.font.color.alpha = op
    @textbox.bitmap.draw_gtext(@cx+r+size.width,@cy+r,100,@line_height,txt2)

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
      # If choices, open them now
      if !@choices.empty?
        open_choices
      else
        @state = :done
        #@box.skin = $cache.menu_common("skin-gold")
      end
    else
      @word_idx = 0
      @cy += @line_height
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

      @text_bmp.font = @font_shadow
      @text_bmp.font.bold = @word.include?('*')
      @text_bmp.font.italic = @word.include?('^')
      @text_bmp.draw_text(@cx+2,@cy+2,300,@line_height,txt)

      @text_bmp.font = @font
      @text_bmp.font.bold = @word.include?('*')
      @text_bmp.font.italic = @word.include?('^')
      @text_bmp.draw_gtext(@cx,@cy,300,@line_height,txt)

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

    #Check for vars
    if @word.include?("&")
      @word.sub!("&","")
      if @word == 'forth-lvl'
        case $state.varval(@word)
          when 2; @word = 'two.'
          when 3; @word = 'three.'
          when 4; @word = 'four.'
          when 5; @word = 'five.'
          when 6; @word = 'six.'
          when 7; @word = 'seven.'
          when 8; @word = 'eight.'
          when 9; @word = 'nine.'
          when 10; @word = 'ten.'
        end
      else
        @word = $state.varval(@word).to_s
      end
    end 

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
                    
        when "$s"
          if cmd[1] == 'n' || cmd[1] == 'r'
            @text_delay = @normal_speed
          else
            @text_delay = SPEED_1 if cmd[1] == '1'
            @text_delay = SPEED_2 if cmd[1] == '2'
            @text_delay = SPEED_3 if cmd[1] == '3'
            @text_delay = SPEED_4 if cmd[1] == '4'
            @text_delay = SPEED_5 if cmd[1] == '5'          
          end
                    
        when "$sfx" # play sound
          sfx(cmd[1])
          
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
          @word = nil
          @show_next = false
          return force_close
          
      end
        
      @word = nil
      next_word if @state != :waiting        

    end

  end  

  def open_choices
    @state = :choice
    @grid = Ui_Grid.new(@vp)
    @grid.move(@box.x,@box.y+@box.height+72)
    @grid.move(@box.x,@box.y+@box.height+112) if @mode == :top
    @choices.each{ |c|
      data = c.split(": ")
      @grid.add_choice(data[0],data[1],@box.width)
    }
  end

  #--------------------------------------------------------------------------
  # * Update waiting
  #--------------------------------------------------------------------------
  def update_waiting
    @wait_frames -= 1
    # @wait_frames = 0 if @skip_all #|| Graphics.frame_rate == 120
    @state = :texting if (@wait_frames < 1)
  end

  #--------------------------------------------------------------------------
  # * Wait for input after text is done
  #--------------------------------------------------------------------------
  def check_input_done
    if $input.action? || $input.click?
      sys('next')
      #self.slide_zy(0.0)
      @state = :closing
      @textbox.bitmap.clear
      $tweens.clear(@sprites)
      @sprites.opacity = 0
      @box.skin = $cache.menu_common("skin")
      $tweens.clear(@vn_port)
      @vn_port.do(to("opacity",0,-11))
      @tail.opacity = 0
      @tail.hide
      #@sprites.do(go("opacity",-255,100,:quad_in_out))

      @sparks.each { |s| s.dispose }
      @sparks = []

    end
  end

  def force_close

    @state = :closing
      @textbox.bitmap.clear
      $tweens.clear(@sprites)
      @sprites.opacity = 0
      @box.skin = $cache.menu_common("skin")
      $tweens.clear(@vn_port)
      @vn_port.do(to("opacity",0,-11))
      @tail.opacity = 0
      @tail.hide

      @sparks.each { |s| s.dispose }
      @sparks = []

    end

  #--------------------------------------------------------------------------
  # * Wait for input or choice
  #--------------------------------------------------------------------------
  def check_input_choice
    return if @choice_delay > 0
    if $input.action? || $input.click?
#      sys('next')
      #self.slide_zy(0.0)

      @last_choice = @choices[@grid.idx].split(":")[0]
      @choices = []

      @grid.dispose
      @grid = nil
      @state = :closing
      @textbox.bitmap.clear
      @sprites.opacity = 0
      @tail.opacity = 0
      @tail.hide
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
      @scratch.font = @font
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
    if total_width < MIN_WIDTH #&& total_width < @namebox.width + 44
      return [text.split(" ")]
    end


    # figure max widths for the mode
    if @mode == :vn
      max_limit = MAX_WIDTH_VN
    else
      max_limit = MAX_WIDTH
    end
    
    # If width is less than max * 2, we are splitting at the first word after half point
    if @mode != :vn && total_width < (max_limit * 1.8) - 40
      limit = (total_width / 2) + 40
      # If long namebox, allow the text to go wider
      limit = @namebox.width + 44 if @namebox.width + 44 > limit
      cursor = 0
      lines = [[]]
      text.split(" ").each{ |word|
        if !lines[-1].empty? && cursor + word_width(word) >= limit 
          lines.push([])
          cursor = 0
        end
        cursor += word_width(word)
        lines[-1].push(word)
      }
      return lines
    end


    # Else we are autosizing max width
    lines = [[]]
    limit = max_limit
    # If long namebox, allow the text to go wider
    limit = @namebox.width + 44 if @namebox.width + 44 > limit
    cursor = 0
    text.split(" ").each{ |word|
      if !lines[-1].empty? && cursor + word_width(word) > limit
        # Don't go beyond first line
        if lines.count == 1
          limit = cursor
        end
        cursor = 0
        lines.push([])
      end
      cursor += word_width(word)
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

