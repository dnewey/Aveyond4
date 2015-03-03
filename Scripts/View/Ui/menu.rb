#==============================================================================
# Ui_Menu
#==============================================================================

class Ui_Menu #< Layer
  
  #--------------------------------------------------------------------------
  # Prepare
  #--------------------------------------------------------------------------
  def initialize
    #super

    # Create the pieces but do nothing besides

    @state = :idle

    # Pages
    @pages = []
    @pages.push Page_Party.new
    @pages.push Page_Gossip.new
    @pages.push Page_Items.new
    @pages.push Page_Quests.new
    @pages.push Page_Status.new
    @pages.push Page_System.new

    @pages.each{ |v| v.close }

    @current = @pages[0]

    # Background
    @plane = add(Plane.new)
    @plane.bitmap = Cache.menu("wallpaper")
    @plane.do(pingpong("zoom_x",1.0,5000,:quad_in_out))
    @plane.visible = false
    
    # Tabs
    @tabs = add(Widget_Menu.new)
    (0..4).each{ |b|
      btn = @tabs.add(Widget_Label.new)
      log_append(btn.inspect)
      btn.skin = 'skin-red'
      btn.text = "Btn " + b.to_s
      btn.font = Fonts.get('title')
      btn.refresh
    }
    @tabs.layout_horiz(5,5)

    @tabs.on_select = Proc.new{ self.show_page(@tabs.idx) }

    @bar = add(Widget_Bugbox.new)
    @bar.from_menu("bottom-bar")
    @bar.name = "bottom-bar"
    @bar.autosize
    @bar.snap_bottom
    #@bar.refresh
    @bar.hide

    @bartext = add(Widget_Label.new)
    @bartext.fix_width = 544
    @bartext.text = "THIS IS THE TEXT"
    @bartext.z = @bar.z + 1
    @bartext.x = 0
    @bartext.y = @bar.y + 15
    @bartext.align = :center
    @bartext.refresh
    @bartext.hide

    close

  end

  def show_page(idx)
    @current.close
    @pages[idx].open

    case idx
    when 0
      @bartext.text = "View party and that"
    else
      @bartext.text = "Misc"
    end
    @bartext.refresh
    
  end

  #--------------------------------------------------------------------------
  # Update
  #--------------------------------------------------------------------------
 
  def open
    @state = :open
    @bar.show
    @bartext.show
    @plane.visible = true
    @tabs.show
    @pages.each{ |v| v.open }
    @tabs.activate
  end

  def close
   # log_append "CLOSE"
    @state = :idle
    @bar.hide
    @bartext.hide
    @tabs.hide
    @plane.visible = false
     @pages.each{ |v| v.close }
  end
      
  #--------------------------------------------------------------------------
  # Update
  #--------------------------------------------------------------------------
  def update  
    super

    @pages.each{ |v| v.update }
    #@list.update

    return if @state == :idle    
    close if key_cancel?   
    
    case @state

      when :idle
        return

    end
    
  end

  #--------------------------------------------------------------------------
  # Misc
  #--------------------------------------------------------------------------
  def busy?() return @state != :idle end

end