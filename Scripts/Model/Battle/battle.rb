#==============================================================================
# ** Game_Battle
#==============================================================================

# Hold battle state

class Game_Battle

  attr_accessor :map, :weather

  attr_reader :enemies

	def initialize
		@enemies = []
    @props = []
    @actor_index = 0

    @map = 26
	end

  def add(enemy)
    @enemies.push(Game_Enemy.new(enemy))
  end

  def start
    $game.push_scene(Scene_Battle.new)
  end

  def win?
    return false
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
  