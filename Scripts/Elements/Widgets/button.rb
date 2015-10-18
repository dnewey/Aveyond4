#==============================================================================
# Button
#==============================================================================

class Button < Sprite
  
  # accessors
  attr_accessor :select, :deselect, :press
  attr_accessor :bmp_up, :bmp_over, :bmp_disable

  attr_accessor :shrink
    
  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def initialize(vp=nil)
       
    super(vp)

    @bmp_up = nil
    @bmp_over = nil

    # handle mouseovers and that and procs and that
    @select = nil#Proc.new{ self.do(pingpong("x",-50,500,:quad_in_out)) }
    @deselect = nil#Proc.new{ $tweens.clear(self); self.x = 22; $tweens.clear(self) }
    @press = nil#Proc.new{self.do(pingpong("y",-30,300,:quad_in_out));}

    @state = :idle # :over
    @disabled = false

    @shrink = 0
    
  end

  def disabled=(v)
    @disabled = v
    self.bitmap = @bmp_disable if @disabled
  end
  
  #--------------------------------------------------------------------------
  # * Update inputs
  #--------------------------------------------------------------------------
  def update

    return if @disabled

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

  end

  # check from mouse or pressing leftright
  def check_hover(pos)
    #log_append "CHECKHOVER"
    #log_append pos
    #log_append [self.x,self.y]
    return if pos[0] < self.x + @shrink
    return if pos[1] < self.y + @shrink
    return if pos[0] > self.x + self.width - @shrink
    return if pos[1] > self.y + self.height - @shrink
    @state = :active
    self.bitmap = @bmp_over if @bmp_over
    @select.call() if @select
  end

  def check_nhover(pos)
    #log_append "CHECKHOVER"
    #log_append pos
    #log_append [self.x,self.y]
    w = false
    w = true if pos[0] < self.x + @shrink
    w = true if pos[1] < self.y + @shrink
    w = true if pos[0] > self.x + self.width - @shrink
    w = true if pos[1] > self.y + self.height - @shrink
    return if w == false
    @state = :idle
    self.bitmap = @bmp_up if @bmp_up
    @deselect.call() if @deselect
  end

end