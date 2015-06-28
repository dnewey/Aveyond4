#==============================================================================
# Button
#==============================================================================

class Button < Sprite
  
  # accessors
  attr_accessor :select, :deselect, :press
    
  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def initialize(vp=nil)
       
    super(vp)

    # handle mouseovers and that and procs and that
    @select = nil#Proc.new{ self.do(pingpong("x",-50,500,:quad_in_out)) }
    @deselect = nil#Proc.new{ $tweens.clear(self); self.x = 22; $tweens.clear(self) }
    @press = nil#Proc.new{self.do(pingpong("y",-30,300,:quad_in_out));}

    @state = :idle # :over
    
  end
  
  #--------------------------------------------------------------------------
  # * Update inputs
  #--------------------------------------------------------------------------
  def update

    # Check inputs if active?
    if @state == :idle
      #if Input.method == :mouse
        check_hover($mouse.position)
      #end
      # check mouse hover?
    end

    if @state == :active
      check_nhover($mouse.position)
      if @state == :active
        if $input.click?
          @press.call() if @press
        end
      end
    end

    if @state == :active
      # check key presses to change to another
      #if Input.trigger?(Input.right)
        # check hover of all neighbours
      #  self.viewport.sprites.each{ |s| s.check_hover(x+100)}
      #end
    end

  end

  # check from mouse or pressing leftright
  def check_hover(pos)
    #log_append "CHECKHOVER"
    #log_append pos
    #log_append [self.x,self.y]
    return if pos[0] < self.x
    return if pos[1] < self.y
    return if pos[0] > self.x + self.width
    return if pos[1] > self.y + self.height
    @state = :active
    @select.call() if @select
  end

  def check_nhover(pos)
    #log_append "CHECKHOVER"
    #log_append pos
    #log_append [self.x,self.y]
    w = false
    w = true if pos[0] < self.x
    w = true if pos[1] < self.y
    w = true if pos[0] > self.x + self.width
    w = true if pos[1] > self.y + self.height
    return if w == false
    @state = :idle
    @deselect.call() if @deselect
  end

end