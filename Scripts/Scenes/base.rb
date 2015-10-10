#==============================================================================
# ** Scene_Base
#==============================================================================

class Scene_Base

  attr_reader :map, :player

  attr_reader :panorama, :tilemap
  attr_reader :weather, :fog
  attr_reader :overlay, :black

  attr_reader :hud

  attr_reader :debug

  #--------------------------------------------------------------------------
  # * Set up the scene
  #--------------------------------------------------------------------------
  def initialize

    $scene = self

    # Prep model
    @map = Game_Map.new
    @player = Game_Player.new

    # Make viewports - Also in the scene
    @vp_under = Viewport.new(0,0,$game.width,$game.height)
    @vp_under.z = 0
    @vp_main = Viewport.new(0,0,$game.width,$game.height)   
    @vp_main.z = 1000
    @vp_weather = Viewport.new(0,0,$game.width,$game.height)
    @vp_weather.z = 1999
    @vp_over = Viewport.new(0,0,$game.width,$game.height)
    @vp_over.z = 2000
    @vp_ui = Viewport.new(0,0,$game.width,$game.height)
    @vp_ui.z = 3000
   
    # Make tilemap
    @panoramas = []
    @tilemap = MapWrap.new(@vp_main)
    
    @characters = []  
    @sparks = []
    @pops = []

    # weather in map data
    @weather = nil#Weather.new(@vp_over)
    @fogs = []

    # Misc Overlay
    @overlay = Sprite.new(@vp_over)
    @overlay.bitmap = Bitmap.new($game.width,$game.height)
    @overlay.bitmap.fill(Color.new(0,0,0))
    @overlay.opacity = 0
    @overlay.z = 999

    # Fadeout
    @black = Sprite.new(@vp_over)
    @black.bitmap = Bitmap.new($game.width,$game.height)
    @black.bitmap.fill(Color.new(0,0,0))
    @black.opacity = 0
    @black.z = 1000
    
    # UI
    @hud = nil # Define in sub
            
  end

  def inviz
    @tilemap.visible= false
    @map.hide
  end

  def viz
    @tilemap.visible= true
    @map.show
  end
  
  def terminate

    # Dispose of things
    @panoramas.each{ |s| s.dispose }
    @panoramas = nil
    @tilemap.dispose
    @characters.each{ |s| s.dispose }
    @characters = nil
    @sparks.each{ |s| s.dispose }
    @pops.each{ |s| s.dispose }
    @weather.dispose if @weather
    @fogs.each{ |s| s.dispose }
    @overlay.dispose
    @black.dispose
    @hud.dispose
    
    # Dispose of viewports
    @vp_under.dispose
    @vp_main.dispose   
    @vp_over.dispose
    @vp_ui.dispose

    #@map.dispose
    #@player.dispose

  end

  #--------------------------------------------------------------------------
  # * Update the map contents and processes input from the player
  #--------------------------------------------------------------------------
  def update

    return if $scene.is_a?(Scene_Menu)
    return if $scene.is_a?(Scene_GameOver)

    # Model update
    @map.update      
    return if $scene.is_a?(Scene_Menu)
    return if $scene.is_a?(Scene_GameOver)
    @player.update

    # Elements update
    @panoramas.each{ |p| p.update } # With animated position
    @tilemap.ox = @map.display_x / 4
    @tilemap.oy = @map.display_y / 4
    @tilemap.update
    @characters.each{ |s| s.update }
    @sparks.each{ |s| 
      # Mouse click needs to follow, others do not
      # Maybe just do all
      s.ox = @map.display_x/4
      s.oy = @map.display_y/4
      s.update 
    }
    @pops.each{ |s| 
      #s.ox = @map.display_x/4
      #s.oy = @map.display_y/4
      s.update 
    }
    @fogs.each{ |p| p.update }
    @weather.update if @weather
    #@fog.update
    #@overlay.update
    @hud.update

    # Try to delete anything
    @sparks.delete_if{ |s| s.done? }
    @pops.delete_if{ |s| s.done? }

    # Could delete erased characters here

    @vp_weather.ox = $map.display_x / 4
    @vp_weather.oy = $map.display_y / 4


    # Rebuild the map
    reload_map if @map.id != @tilemap.map_id
    
  end

  def clear_sparks(e=nil)

      if e == nil
        # Clear sparks
        @sparks.each{ |s| s.dispose }
        @sparks.clear
      else

        @sparks.each{ |s| s.dispose if s.ev == e }
        @sparks.delete_if{ |s| s.disposed? }

       end

  end

  def reload_map
    
    @tilemap.refresh(@map)

    @characters.each{ |s| s.dispose }
    @characters = []

    @map.events.keys.sort.each{ |i|
      sprite = Sprite_Character.new(@vp_main, @map.events[i])
      @characters.push(sprite)
    }

    @characters.push(Sprite_Character.new(@vp_main, @player))

  end

  def change_overlay(overlay)
    
    # Nightwatch hack
    overlay = 'night' if flag?('night-time')

    if overlay == '' || overlay == nil
      $scene.overlay.opacity = 0
    else
      $scene.overlay.bitmap = $cache.overlay(overlay)
      $scene.overlay.opacity = 255
    end
  end

  def change_weather(weather)
    @weather.dispose if @weather
    @weather = nil
    case weather
      when 'dark-dots'
        @weather = Weather_DarkDots.new(@vp_weather)
      when 'rain'
        @weather = Weather_Rain.new(@vp_weather)
    end
  end

  def change_fogs(fogs)

    @fogs.each{ |p| p.dispose }
    @fogs.clear   

    data = fogs.split("\n")

    data.each{ |fg|

       fog = Panorama.new(@vp_over)
       fog.blend = 1
       fog.opacity = 120

      # Any extra data
      dta = fg.split(" | ")

      if dta.count > 1
        dta.each_index{ |i|
          next if i == 0
          d = dta[i].split("=>")

          case d[0]
            when 'ax'; fog.att_x = d[1].to_f
            when 'ay'; fog.att_y = d[1].to_f
            when 'sx'; fog.spd_x = d[1].to_f
            when 'sy'; fog.spd_y = d[1].to_f
            when 'ox'; fog.start_x = d[1].to_f
            when 'oy'; fog.start_y = d[1].to_f
            when 'px'; fog.pad_x = d[1].to_f
            when 'py'; fog.pad_y = d[1].to_f
            when 'r'; fog.repeat = d[1].to_b

          end

        }
      end

      
      #pano.z = -1000
      fog.bitmap = $cache.fog(dta[0])
      @fogs.push(fog)

    }


  end

  def change_panoramas(panos)

    @panoramas.each{ |p| p.dispose }
    @panoramas.clear   

    data = panos.split("\n")

    data.each{ |pano|

       panorama = Panorama.new(@vp_under)

      # Any extra data
      dta = pano.split(" | ")

      if dta.count > 1
        dta.each_index{ |i|
          next if i == 0
          d = dta[i].split("=>")

          case d[0]
            when 'ax'; panorama.att_x = d[1].to_f
            when 'ay'; panorama.att_y = d[1].to_f
            when 'sx'; panorama.spd_x = d[1].to_f
            when 'sy'; panorama.spd_y = d[1].to_f
            when 'ox'; panorama.start_x = d[1].to_f
            when 'oy'; panorama.start_y = d[1].to_f
            when 'px'; panorama.pad_x = d[1].to_f
            when 'py'; panorama.pad_y = d[1].to_f
            when 'r'; panorama.repeat = d[1].to_b

          end

        }
      end
      
      #pano.z = -1000
      panorama.bitmap = $cache.panorama(dta[0])
      @panoramas.push(panorama)

    }

  end

  def add_spark(fx,x,y,e=nil,vp=@vp_main) # might want custom vp

    sprk = Spark.new(fx,x,y,@vp_main)
    sprk.ev = e
    @sparks.push(sprk)
    return sprk

  end

  def add_icon(ic,x,y,ein,eout,delay=800)

    ico = Pop.new(ein,eout,@vp_over)
    ico.icon = ic
    ico.move(x,y)
    ico.anim_delay = delay
    ico.start
    @pops.push(ico) # Could combine these with spark

  end

  def add_num(nm,x,y,ein,eout)

    ico = Pop.new(ein,eout,@vp_over)
    ico.number = nm
    ico.move(x,y)
    ico.start
    @pops.push(ico) # Could combine these with spark

  end

  def add_pop(pop)
    @pops.push(pop)
  end

  # def pop_dmg(target,amount)
  #   #ev = gev(target)
  #   pop = Popper.new(@vp_over)
  #   pop.value = amount #- amount/10
  #   pop.x = target.screen_x-200-20
  #   pop.y = target.screen_y-40-12+45
  #   @pops.push(pop)

  #   pop.opacity = 1
  #   pop.do(go("value",amount,700,:quad_in_out))
  #   pop.do(sequence(go("opacity",254,500),go("opacity",0,1500),go("opacity",-255,500)))
  #   pop.do(sequence(go("y",-30,500,:quad_in_out),go("y",-20,1500),go("y",-30,500,:quad_in_out)))


  # end

end
