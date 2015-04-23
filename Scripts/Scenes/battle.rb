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



# Rename actor to active_battler

class Scene_Battle

  attr_accessor :hud
  
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
    #@bg.bitmap = $cache.menu("tempback")

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
    @skill_cmd = SkillCmd.new(@vp_hud)
    @target_cmd = TargetCmd.new(@vp_hud)

    # Prepare characters
    # (1..4).each{ |c|
    #   @map.events[c].direction = 4
    # }

    @map.update
    @character_sprites.each{ |s| s.update }

    [0,1,2,3].each{ |i| 
      ev = @map.event_by_name("A.#{i}") 
      act = $party.actor_by_index(i).id
      ev.character_name = "Player/#{act}-idle"
      ev.pattern = rand(4)
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

    # Save char to battler for easy access

    @props = []

    #@map.target = $player

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

    @hud.update

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
        update_phase_target
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
    @actor_cmd.setup(@actor)
    @phase = :actor_cmd
  end

  def prev_actor
    @actor_idx -= 1
    @actor = $party.actor_by_index(@actor_idx)
    @actor_cmd.setup(@actor)
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

      start_action(action)

       end 

  end

  def start_action(id)

    # HMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMMM
      if id == "items"

      else
        skills = @actor.skills_for(id)
      end

      # If a multi-skill open the menu
      if skills.count > 1

        # Open skill_cmd

      else

        start_skill(skills[0])        

      end



  end

  def start_skill(id)

    @actor.skill_id = id

    # If single, targetable?
    if ["one","ally"].include?($data.skills[id].scope)
      targets = $battle.enemies
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
      @target_cmd.close
      @actor_idx -= 1
      next_actor
    end

    if $input.action?
      @actor.target = @target_cmd.active
      @target_cmd.close
      next_actor
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