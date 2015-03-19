#==============================================================================
# Widget_Clicker
#==============================================================================

# Base display of pics

class Widget_Clicker < Widget
  
  # accessors
    
  #--------------------------------------------------------------------------
  # * Init
  #--------------------------------------------------------------------------
  def initialize()
       
    super()

    @childport = Layer.new(700)

    # handle mouseovers and that and procs and that
    @select = Proc.new{ @btn.do(pingpong("x",-50,500,:quad_in_out)) }
    @deselect = Proc.new{ $machine.clear(@btn); @btn.x = 22; $machine.clear(self) }
    @press = Proc.new{self.do(pingpong("y",-30,300,:quad_in_out)); $player.zoom_x = 10}

    @state = :idle # :over

    @btn = @childport.add(Widget.new())
    @btn.width = 60
    @btn.height = 60
    @btn.from_skin("wskin")
    @btn.x = 22
    @btn.y = 22

    
  end
  
  #--------------------------------------------------------------------------
  # * Update inputs
  #--------------------------------------------------------------------------
  def update

    @childport.update
    @childport.rect.x = self.x
    @childport.rect.y = self.y
    @childport.rect.width = self.width
    @childport.rect.height = self.height
    #@childport.opacity = self.opacity

    # Check mouseover

    # Check inputs if active?
    if @state == :idle
      if Input.method == :mouse
        check_hover(Mouse.position)
      end
      # check mouse hover?
    end

    if @state == :active
      check_nhover(Mouse.position)
      if @state == :active
        if Mouse.trigger?
          @press.call()
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
    log_append("PROC")
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
    @deselect.call() if @select
    log_append("UNPROC")
  end

end