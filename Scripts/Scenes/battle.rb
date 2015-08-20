#==============================================================================
# ** Scene_Map
#==============================================================================

class Scene_Battle < Scene_Base

  attr_accessor :phase, :message

  def initialize
    super

    @phase = :intro_init
    @wait_frames = 0
    @active_battler = nil

    @map.setup($battle.map)
    @tilemap.refresh(@map)

    # Init player and camera 
    @player.moveto(0,0)
    @player.static
    @map.camera_to(@player)

    # Slide camera up
    @map.cam_oy = 80
    @map.do(
      seq(
        delay(40),
        #go("cam_oy",-110,1000,:quad_out)
        go("cam_oy",-80,700,:quad_out)
      )
    )    

    # Create Hud Elements
    @hud = BattleHud.new(@vp_ui)
    @actor_cmd = ActorCmd.new(@vp_ui)
    @skill_cmd = SkillCmd.new(@vp_ui)
    @item_cmd = ItemCmd.new(@vp_ui)
    @target_cmd = TargetCmd.new(@vp_ui)
    @message = Ui_Message.new(@vp_ui)


    # Find battler events
    [0,1,2,3].each{ |i| 
      ev = @map.event_by_evname("A.#{i}")
      next if ev == nil
      act = $party.actor_by_index(i).id
      #ev.character_name = "Player/#{act}-idle"
      ev.character_name = "Player/#{act}"
      #ev.x -= 1
      #ev.move_left
      ev.off_x = 32
      ev.do(go("off_x",-32,800))
      #ev.pattern = rand(4)
      #ev.direction = 2
      ev.step_anime = true
      if $party.active.count > i
        $party.actor_by_index(i).ev = ev
        if $party.get(act).down?
          $party.get(act).fall
          $party.get(act).view.down if $party.get(act).view
        end
      end

    }

    [0,1,2,3,4].each{ |i| 
      ev = @map.event_by_evname("E.#{i}") 
      next if ev == nil
      if $battle.enemies.count > i
        $battle.enemies[i].ev = ev
        log_sys("HP")
        log_sys($battle.enemies[i].stat('hp'))
        ev.character_name = "Monsters/#{$battle.enemy_list[i]}"
      end
    }

    #$battle.add_prop('money')

    # And the minion
    if $battle.minion != nil
      @minion = $battle.minion
      @minion.ev = @map.event_by_evname("MINION")
      @minion.ev.character_name = "Player/#{@minion.id}"
    else
      hide("MINION")
    end
    #hide(@minion)

    reload_map
            
  end
  
  def terminate
    super  
  end

  def busy?
    return false
  end

  def wait(w)
    @wait_frames += w
  end

  #--------------------------------------------------------------------------
  # * Update the map contents and processes input from the player
  #--------------------------------------------------------------------------

  def update

    super

    @hud.update
    @message.update

    # Draw phase
    #@dbg_phase.bitmap.fill(Color.new(0,0,0))
    #@dbg_phase.bitmap.draw_text(10,0,150,30,@phase.to_s,0)

    update_phase

  end

  def update_phase

    $debug.track(self,"phase")

    # Wait count here
    if @wait_frames > 0
      @wait_frames -= 1
      return
    end

    if @message.busy?
      return
    end

    if @map.interpreter.running?
      return
    end

    case @phase

      # Introduction Phase
      when :intro_init
        phase_intro_init
      when :intro_prep
        phase_intro_prep
      when :intro_action
        phase_intro_action
      when :intro_minion
        phase_intro_minion

      # Actor Phase
      when :actor_init
        phase_actor_init
      when :actor_action
        phase_actor_action
      when :actor_skill
        phase_actor_skill
      when :actor_item
        phase_actor_item
      when :actor_transform
        phase_actor_transform
      when :actor_re_action
        phase_actor_re_action
      when :actor_strategize
        phase_actor_strategize
      when :actor_target
        phase_actor_target
      when :actor_next
        phase_actor_next

      # Battle phase
      when :main_init
        phase_main_init
      when :main_prep
        phase_main_prep
      when :main_start
        phase_main_start
      when :main_text
        phase_main_text
      when :main_anim
        phase_main_anim
      when :main_cost
        phase_main_cost
      when :main_transform
        phase_main_transform
      when :main_hit
        phase_main_hit
      when :main_crit
        phase_main_crit
      when :main_gain
        phase_main_gain
      when :main_state
        phase_main_state
      when :main_fall
        phase_main_fall
      when :main_next
        phase_main_next
      when :main_end
        phase_main_end

      # Victory Phase
      when :victory_init
        phase_victory_init
      when :victory_xp
        phase_victory_xp
      when :victory_level
        phase_victory_level
      when :victory_end
        phase_victory_end

    end

  end

end