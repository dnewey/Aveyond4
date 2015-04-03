#==============================================================================
# ** Scene_Map
#==============================================================================

# Phases

# :none

# :introduction - introduction seq

# :enemy_cmd
# :party_cmd
# :actor_cmd - choose actions

# :main - perform actions

# :victory - player wins
# :defeat - enemy wins

class Scene_Battle
  
  #--------------------------------------------------------------------------
  # * Set up the scene
  #--------------------------------------------------------------------------
  def initialize

    Graphics.freeze

    @vp = Viewport.new(0, 0, $game.width, $game.height)
    @vp_hud = Viewport.new(0, 0, $game.width, $game.height)

    @vp.z = 6000  
    @vp_hud.z = 75000

    @bg = Sprite.new(@vp)
    @bg.z = -100
    @bg.bitmap = Cache.menu("tempback")

    @map = Game_Map.new()
    @map.setup($battle.map)

    @player = Game_Player.new
    $player = @player # Get rid of this
    @player.moveto(5,5)

    #@map.target = @player

    @tilemap = MapWrap.new(@vp) 
    @tilemap.refresh(@map)

    @character_sprites = []
    @map.events.keys.sort.each{ |i|
      sprite = Sprite_Character.new(@vp, @map.events[i])
      @character_sprites.push(sprite)
    }

    @hud = BattleHud.new(@vp_hud)
    @actor_cmd = ActorCmd.new(@vp_hud)
    #@skill_cmd = SkillCmd.new()
    #@target_cmd = TargetCmd.new()

    # Prepare characters
    (1..4).each{ |c|
      @map.events[c].direction = 4
    }

    @map.update
    @character_sprites.each{ |s| s.update }

    @actor_chars = [1,2,3,4].map{ |i| @map.event_by_name("A.#{i}") }
    @enemy_chars = [1,2,3,4,5].map{ |i| @map.event_by_name("E.#{i}") }

    @props = []

    Graphics.transition(50,'Graphics/System/trans')  

    @phase = :introduction
            
  end
  
  def terminate
    @map.dispose
    @character_sprites.each{ |s| s.dispose }    
  end

  def busy?
    return false
  end

  #--------------------------------------------------------------------------
  # * Update the map contents and processes input from the player
  #--------------------------------------------------------------------------
  def update

    @map.update
    @character_sprites.each{ |s| s.update }

    update_phase

  end

  def update_phase
    case @phase
      when :introduction
        update_phase_introduction
      when :enemy_cmd
        update_phase_enemy_cmd
      when :party_cmd
        update_phase_party_cmd
      when :actor_cmd
        update_phase_actor_cmd
      when :target
        update_phase_actor_cmd
      when :map
        update_phase_main
      when :victory
        update_phase_victory
      when :defeat
        update_phase_defeat
    end
  end

  def update_phase_introduction
    @phase = :enemy_cmd
  end

  def update_phase_enemy_cmd
    @phase = :party_cmd
  end

  def update_phase_party_cmd
    @actor_idx = -1    
    next_actor
  end

  def next_actor
    @actor_idx += 1
    @actor = $party.actor_by_index(@actor_idx)
    @actor_cmd.setup(@actor,@actor_chars[@actor_idx])
    @phase = :actor_cmd
  end

  def prev_actor
    @actor_idx -= 1
    @actor = $party.actor_by_index(@actor_idx)
    @actor_cmd.setup(@actor,@actor_chars[@actor_idx])
    @phase = :actor_cmd
  end

  def update_phase_actor_cmd

    @actor_cmd.update

    if $input.cancel?
      return prev_actor
    end

    # Player command inputs section
    if $input.action?

      action = @actor_cmd.get_action
      @actor_cmd.close

      if action == "items"

      else
        skills = @actor.skills_for(action)
      end

      # If a multi-skill open the menu
      if skills.count > 1

        # Open skill_cmd

      else

        start_skill(skills[0])        

      end

    end    

  end

  def start_action(id)

  end

  def start_skill(id)

    @actor.skill_id = id

    # If single, targetable?
    if ["one"].include?(skill.scope)
      #targets = [[battler,char],...]
      @target_cmd.setup(targets)
      @phase = :target      
    else
      next_actor
    end

  end

  def update_phase_skill_cmd
    @skill_cmd.update

    if $input.cancel?
      @actor_idx -= 1
      next_actor
    end

    if $input.action?

    end

  end

  def update_phase_target

    @target_cmd.update

    if $input.cancel?
      start_action(@battler.action)
    end

    if $input.action?
      @battler.target = @target_cmd.target
    end

  end  

  def update_phase_main

    # Act out the skills

  end

  def update_phase_victory

  end

  def update_phase_defeat

  end

end