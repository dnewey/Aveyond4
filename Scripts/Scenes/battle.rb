#==============================================================================
# ** Scene_Map
#==============================================================================

# Phases

# Rename actor to active_battler

class Scene_Battle

  attr_accessor :hud
  
  #--------------------------------------------------------------------------
  # * Set up the scene
  #--------------------------------------------------------------------------
  def initialize

    Graphics.freeze

    @phase = :intro_init
    @wait_frames = 0
    @active_battler = nil

    # Auto viewports to fullscreen and set z in init
    @vp = Viewport.new(0, 0, $game.width, $game.height)
    @vp_hud = Viewport.new(0, 0, $game.width, $game.height)
    @vp.z = 6000  
    @vp_hud.z = 75000

    @dbg_phase = Sprite.new(@vp_hud)
    @dbg_phase.bitmap = Bitmap.new(150,30)

    #@panorama = Sprite.new(@vp)
    #@panorama.z = -100

    @map = Game_Map.new
    @map.setup($battle.map)

    @player = Game_Player.new
    
    # Get rid of this after figuring out camera pos as pos instead of event
    $player = @player 
    @player.moveto(5,5)
    @map.target = @player

    #@map.point_camera_at()

    @tilemap = MapWrap.new(@vp) 
    @tilemap.refresh(@map)

    @character_sprites = []
    @map.events.keys.sort.each{ |i|
      sprite = Sprite_Character.new(@vp, @map.events[i])
      @character_sprites.push(sprite)
    }

    # Create Hud Elements
    @hud = BattleHud.new(@vp_hud)
    @actor_cmd = ActorCmd.new(@vp_hud)
    @skill_cmd = SkillCmd.new(@vp_hud)
    @target_cmd = TargetCmd.new(@vp_hud)

    # Prepare battler events
    [0,1,2,3].each{ |i| 
      ev = @map.event_by_name("A.#{i}")
      act = $party.actor_by_index(i).id
      ev.character_name = "Player/#{act}-idle"
      ev.pattern = rand(4)
      ev.step_anime = true
      if $party.active.count > i
        $party.actor_by_index(i).ev = ev
      end
    }
    [0,1,2,3,4].each{ |i| 
      ev = @map.event_by_name("E.#{i}") 
      if $battle.enemies.count > i
        $battle.enemies[i].ev = ev
      end
    }

    Graphics.transition(50,'Graphics/System/trans')  
            
  end
  
  def terminate
    @map.dispose
    @character_sprites.each{ |s| s.dispose }    
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

    @hud.update
    @map.update    
    @character_sprites.each{ |s| s.update }

    # Draw phase
    @dbg_phase.bitmap.fill(Color.new(0,0,0))
    @dbg_phase.bitmap.draw_text(10,0,150,30,@phase.to_s,0)

    update_phase

  end

  def update_phase

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
      when :actor_target
        phase_actor_target
      when :actor_next
        phase_actor_next

      # Battle phase
      when :main_init
        phase_main_init
      when :main_prep
        phase_main_prep
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