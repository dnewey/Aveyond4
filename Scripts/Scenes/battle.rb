#==============================================================================
# ** Scene_Map
#==============================================================================

class Scene_Battle < Scene_Base

  attr_accessor :phase

  def initialize
    super

    Graphics.freeze

    @phase = :intro_init
    @wait_frames = 0
    @active_battler = nil

    @map.setup($battle.map)
    @tilemap.refresh(@map)

    # Could put the scrolling into battle in with this
    # Char screenx comes from this, perhaps $scene.map
   
    @player.moveto(0,0)
    @player.static
    @map.camera_to(@player)
    #@map.camera_xy(5,15)
    #@map.cam_oy = 150
    #@map.do(go("cam_oy",-250,2500,:quad_in_out))    


    # Create Hud Elements
    @hud = BattleHud.new(@vp_ui)
    @actor_cmd = ActorCmd.new(@vp_ui)
    @skill_cmd = SkillCmd.new(@vp_ui)
    @item_cmd = ItemCmd.new(@vp_ui)
    @target_cmd = TargetCmd.new(@vp_ui)

    #$map = @map
    #$player = @player

    # Find battler events
    [0,1,2,3].each{ |i| 
      ev = @map.event_by_evname("A.#{i}")
      next if ev == nil
      act = $party.actor_by_index(i).id
      ev.character_name = "Player/#{act}-idle"
      ev.pattern = rand(4)
      ev.direction = 2
      ev.step_anime = true
      if $party.active.count > i
        $party.actor_by_index(i).ev = ev
      end
    }
    [0,1,2,3,4].each{ |i| 
      ev = @map.event_by_evname("E.#{i}") 
      next if ev == nil
      if $battle.enemies.count > i
        $battle.enemies[i].ev = ev
        ev.character_name = "Monsters/#{$battle.enemy_list[i]}"
      end
    }

    reload_map

    sys('battlestart')
    music("rivals",0.6)
        
    Graphics.transition(20,'Graphics/Transitions/trans') 
            
  end
  
  def terminate
    super  
  end

  def busy?
    return false
  end

  def wait(w)
    @wait_frames = w
  end

  #--------------------------------------------------------------------------
  # * Update the map contents and processes input from the player
  #--------------------------------------------------------------------------

  def update

    super

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

    case @phase

      # Introduction Phase
      when :intro_init
        phase_intro_init

      # Actor Phase
      when :actor_init
        phase_actor_init
      when :actor_action
        phase_actor_action
      when :actor_skill
        phase_actor_skill
      when :actor_item
        phase_actor_item
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
      when :main_attack
        phase_main_attack
      when :main_defend
        phase_main_defend
      when :main_hit
        phase_main_hit
      when :main_crit
        phase_main_crit
      when :main_state
        phase_main_state
      when :main_next
        phase_main_next

      # Victory Phase
      when :victory_init
        phase_victory_init

    end

  end

end