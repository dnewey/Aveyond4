

#--------------------------------------------------------------------------
#--------------------------------------------------------------------------
# CCOA'S UNIVERSAL MESSAGE SYSTEM (UMS) CONSTANTS
#--------------------------------------------------------------------------
#--------------------------------------------------------------------------

# modes
NORMAL_MODE        = 0
FIT_WINDOW_TO_TEXT = 1

#text modes
ONE_LETTER_AT_A_TIME = 0
ALL_AT_ONCE          = 1

# skip modes
WRITE_FASTER = 0
WRITE_ALL    = 1

# justifications
RIGHT  = 0
CENTER = 1
LEFT   = 2

# positions for extra objects (face graphics, choice box, etc)
ABOVE  = 0  # place the object above the top of the message box
CENTER = 1  # center the object vertically inside the message box
BOTTOM = 2  # place the bottom of the object on the bottom of the message box
SIDE   = 3  # to the side of the message box (which side depends on justification)

# comic type
TALK1   = 0
TALK2   = 1
THOUGHT = 2

class Message

  
  # for Ccoa's UMS
  attr_accessor :ums_mode # what mode the UMS is in
  attr_accessor :text_skip # whether or not text skip is activated
  attr_accessor :skip_mode # write the text faster while C is pressed, or just skip to the end
  attr_accessor :write_speed # frame delay between characters
  
  attr_accessor :text_mode # write one letter at a time, or all at once?
  
  attr_accessor :window_height # default height of message window
  attr_accessor :window_width # default width of message window
  attr_accessor :window_justification # default justification of window
  
  attr_accessor :face_graphic # current face graphic
  attr_accessor :face_graphic_justification # justification of face graphic
  attr_accessor :face_graphic_position # position of face graphic
  
  attr_accessor :shadowed_text # whether or not to draw a shadow behind the text
  attr_accessor :shadow_color # the shadow color
  
  attr_accessor :choice_justification # where the choice window is located
  attr_accessor :choice_position # prefered position of choice window
  
  attr_accessor :message_event # what event to center the text over (0 player, -1 to not)
  
  attr_accessor :comic_enabled # using "talk" icons?
  attr_accessor :comic_style   # what type of comic image to use
  
  attr_accessor :name # the text for the name window
  attr_accessor :name_window # should the name window be visible?
  
  attr_accessor :font # the name of the font
  attr_accessor :font_color # the name of the (permanent) font color
  
  attr_accessor :text_justification # the justification of the window text
  
  attr_accessor :show_pause # whether or not to show the pause icon
  
  attr_accessor :shake # the amount of shake for the window
  
  attr_accessor :sound_effect # SE to play with each letter
  
  attr_accessor :slave_windows # hash of slave windows
  attr_accessor :indy_windows  # hash of independent windows
  
  attr_accessor :animated_faces # are the faces animated?
  attr_accessor :animation_pause # how long do I wait between animation loops?
  attr_accessor :face_frame_width # how many pixels wide is each face frame
  attr_accessor :resting_face  # postext for waiting face graphic
  attr_accessor :resting_animation_pause # how long to wait for resting graphic
  
  attr_accessor :windowskin # what windowskin to use for messages
  attr_accessor :back_opacity # back opacity of windowskin
  attr_accessor :opacity # opacity of windowskin
  
  attr_accessor :window_image # image used behind window
  
  attr_reader :shortcuts  # user-defined shortcuts
      
  # for Ccoa's UMS
  attr_accessor :num_choices
  attr_accessor :skip_next_choices


  attr_accessor :message_text             # message text
  attr_accessor :message_proc             # message callback (Proc)
  attr_accessor :message_event            # event triggering message
  
  attr_accessor :choice_start             # show choices: opening line
  attr_accessor :choice_max               # show choices: number of items
  attr_accessor :choice_cancel_type       # show choices: cancel
  attr_accessor :choice_proc              # show choices: callback (Proc)  
  
  attr_accessor :message_window_showing   # message window showing



  # Somewhere to put these
  attr_accessor :message_position         # text option: positioning
  attr_accessor :message_frame            # text option: window frame




  def initialize


    
    # Set up Ccoa's UMS
    @ums_mode = FIT_WINDOW_TO_TEXT #NORMAL_MODE
    
    @skip_mode = WRITE_ALL
    @text_skip = true
    @write_speed = 1
    
    @text_mode = ONE_LETTER_AT_A_TIME
    
    @window_height = 128
    @window_width = 480
    @window_justification = CENTER
    
    @face_graphic = ""
    @face_graphic_justification = LEFT
    @face_graphic_position = CENTER
    
    @shadowed_text = true
    @shadow_color = Color.new(0, 0, 0, 100)
    
    @choice_justification = RIGHT
    @choice_position = SIDE
    
    @message_event = -1
    
    @comic_enabled = true
    @comic_style = TALK1
    
    @name = ""
    @name_window = true
    
    @font = "Verdana"
    @font_color = nil
    
    @text_justification = LEFT
    
    @show_pause = true
    
    @shake = 0
    
    @sound_effect = ""
    
    @slave_windows = {}
    @indy_windows  = {}
    
    @animated_faces = false
    @animation_pause = 80
    @face_frame_width = 100
    @resting_face = ""
    @resting_animation_pause = 80
    
    @windowskin = ""
    @opacity = 255
    @back_opacity = 160
    
    @window_image = nil
    
    @used_codes = ['\v', '\n', '\c', '\g', '\skip', '\m', '\height', '\width', 
                   '\jr', '\jc', '\jl', '\face', '\fl', '\fr', '\b', '\i', '\s',
                   '\e', '\t1', '\t2', '\th', '\nm', '\font', '\p', '\w', '\ws',
                   '\oa', '\oi', '\os', '\ow', '\tl', '\tr', '\tc', '\ignr', 
                   '\shk', '\slv', '\ind', '\inc']
                   
    @shortcuts = {}
    
         
    @skip_next_choices = 0
    @num_choices = 1




        @message_text = nil
    @message_proc = nil
    @message_event = -1
    @choice_start = 99
    @choice_max = 0
    @choice_cancel_type = 0
    @choice_proc = nil
    @message_window_showing = false
    

  end

end
