#==============================================================================
# ** Game_Battle
#==============================================================================

# Hold battle state
# Phases

# :none

# :introduction - introduction seq

# :enemy_cmd
# :party_cmd
# :actor_cmd - choose actions

# :main - perform actions

# :victory - player wins
# :defeat - enemy wins

class Game_Battle

	def initialize
		@phase = :none
		@enemies = []

    @actor_index = 0
	end

  def add(enemy)
    @enemies.push(Game_Enemy.new(enemy))
  end

  def start
    $game.push_scene(Scene_Battle.new) # Set up the visuals and that
    change_phase(:introduction)
  end

  def win?
    return false
  end

  def update
    case @phase
      when :introduction
        update_phase_introduction
      when :enemy_cmd
        update_phase_enemy_cmd
      when :party_cmd
        update_phase_party_cmd
      when :actor_cmd
        update_phase_actor_cmd
      when :map
        update_phase_main
      when :victory
        update_phase_victory
      when :defeat
        update_phase_defeat
    end
  end

  def change_phase(ph)
    @phase = ph
    case @phase
      when :introduction
        start_phase_introduction
      when :enemy_cmd
        start_phase_enemy_cmd
      when :party_cmd
        start_phase_party_cmd
      when :actor_cmd
        start_phase_actor_cmd
      when :map
        start_phase_main
      when :victory
        start_phase_victory
      when :defeat
        start_phase_defeat
    end
  end

  def start_phase_introduction

    # Prepare something

  end

  def update_phase_introduction

    # After some time, move on to enemy_cmd

    change_phase(:enemy_cmd)

  end

  def start_phase_enemy_cmd

    # Select skills for each enemy


    change_phase(:party_cmd)

  end

  def update_phase_enemy_cmd
    # Not used
  end

	def start_phase_party_cmd
    
    # Show the visuals!

    change_phase(:actor_cmd)

  end

  def update_phase_party_cmd
    # Not used
  end

  def start_phase_actor_cmd
    # What is this even for?    
    @actor_idx = 0

    # Open the ui
    $scene.hud.open_actor_cmd($party.actor(@actor_idx))

  end

  def actor_skill_select(cmd)

  end

  def actor_skill_cancel

  end

  def update_phase_actor_cmd

    # Player command inputs section
    
    

    # that's about it?
    # show the ui? how?

    $party.clear_actions

  end

  

  def start_phase_main

    # Prep list of actions

  end

  def update_phase_main

  end




  def start_phase_victory

  end

  def update_phase_victory

  end

  def start_phase_defeat

  end

  def update_phase_defeat

  end




  # CHOOSING TARGETS

	  #--------------------------------------------------------------------------
  # * Determine if for One Ally
  #--------------------------------------------------------------------------
  def for_one_friend?
    # If kind = skill, and effect scope is for ally (including 0 HP)
    if @kind == 1 and [3, 5].include?($data_skills[@skill_id].scope)
      return true
    end
    # If kind = item, and effect scope is for ally (including 0 HP)
    if @kind == 2 and [3, 5].include?($data_items[@item_id].scope)
      return true
    end
    return false
  end
  
  #--------------------------------------------------------------------------
  # * Determine if for One Ally (HP 0)
  #--------------------------------------------------------------------------
  def for_one_friend_hp0?
    # If kind = skill, and effect scope is for ally (only 0 HP)
    if @kind == 1 and [5].include?($data_skills[@skill_id].scope)
      return true
    end
    # If kind = item, and effect scope is for ally (only 0 HP)
    if @kind == 2 and [5].include?($data_items[@item_id].scope)
      return true
    end
    return false
  end
  #--------------------------------------------------------------------------
  # * Random Target (for Actor)
  #--------------------------------------------------------------------------
  def decide_random_target_for_actor
    # Diverge with effect scope
    if for_one_friend_hp0?
      battler = $game_party.random_target_actor_hp0
    elsif for_one_friend?
      battler = $game_party.random_target_actor
    else
      battler = $game_troop.random_target_enemy
    end
    # If a target exists, get an index, and if a target doesn't exist,
    # clear the action
    if battler != nil
      @target_index = battler.index
    else
      clear
    end
  end
  #--------------------------------------------------------------------------
  # * Random Target (for Enemy)
  #--------------------------------------------------------------------------
  def decide_random_target_for_enemy
    # Diverge with effect scope
    if for_one_friend_hp0?
      battler = $game_troop.random_target_enemy_hp0
    elsif for_one_friend?
      battler = $game_troop.random_target_enemy
    else
      battler = $game_party.random_target_actor
    end
    # If a target exists, get an index, and if a target doesn't exist,
    # clear the action
    if battler != nil
      @target_index = battler.index
    else
      clear
    end
  end
  #--------------------------------------------------------------------------
  # * Last Target (for Actor)
  #--------------------------------------------------------------------------
  def decide_last_target_for_actor
    # If effect scope is ally, then it's an actor, anything else is an enemy
    if @target_index == -1
      battler = nil
    elsif for_one_friend?
      battler = $game_party.actors[@target_index]
    else
      battler = $game_troop.enemies[@target_index]
    end
    # Clear action if no target exists
    if battler == nil or not battler.exist?
      clear
    end
  end
  #--------------------------------------------------------------------------
  # * Last Target (for Enemy)
  #--------------------------------------------------------------------------
  def decide_last_target_for_enemy
    # If effect scope is ally, then it's an enemy, anything else is an actor
    if @target_index == -1
      battler = nil
    elsif for_one_friend?
      battler = $game_troop.enemies[@target_index]
    else
      battler = $game_party.actors[@target_index]
    end
    # Clear action if no target exists
    if battler == nil or not battler.exist?
      clear
    end
  end

end
  