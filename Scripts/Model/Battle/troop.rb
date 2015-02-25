#==============================================================================
# ** Game_Troop
#==============================================================================

class Game_Troop
  #--------------------------------------------------------------------------
  # * Object Initialization
  #--------------------------------------------------------------------------
  def initialize
    # Create enemy array
    @enemies = []
  end
  #--------------------------------------------------------------------------
  # * Get Enemies
  #--------------------------------------------------------------------------
  def enemies
    return @enemies
  end
  #--------------------------------------------------------------------------
  # * Setup
  #     troop_id : troop ID
  #--------------------------------------------------------------------------
  def setup(troop_id)
    # Set array of enemies who are set as troops
    @enemies = []
    troop = $data_troops[troop_id]
    for i in 0...troop.members.size
      enemy = $data_enemies[troop.members[i].enemy_id]
      if enemy != nil
        @enemies.push(Game_Enemy.new(troop_id, i))
      end
    end
    
    # Set up BGM and escape
    if troop.name.index(/[Ff][Ii][Nn][Aa][Ll][Bb][Oo][Ss][Ss]/) != nil
      bgm = RPG::AudioFile.new(FINAL_BOSS_BGM, 100, 100)
      $game_switches[IN_BOSS_BATTLE_SWITCH] = true # in boss battle
    elsif troop.name.index(/[Bb][Oo][Ss][Ss]/) != nil
      bgm = RPG::AudioFile.new(BOSS_BGM, 100, 100)
      $game_switches[IN_BOSS_BATTLE_SWITCH] = true # in boss battle
    elsif troop.name.index(/[Nn][Oo][Bb][Gg][Mm]/) != nil
      #don't play any bgm
    else
      bgm = RPG::AudioFile.new(BATTLE_BGM, 80, 100)
    end
    $game_system.bgm_play(bgm)
  end
  #--------------------------------------------------------------------------
  # * Random Selection of a Target Enemy
  #     hp0 : limited to enemies with 0 HP
  #--------------------------------------------------------------------------
  def random_target_enemy(hp0 = false)
    # Initialize roulette
    roulette = []
    # Loop
    for enemy in @enemies
      # If it fits the conditions
      if (not hp0 and enemy.exist?) or (hp0 and enemy.hp0?)
        # Add an enemy to the roulette
        roulette.push(enemy)
      end
    end
    # If roulette size is 0
    if roulette.size == 0
      return nil
    end
    # Spin the roulette, choose an enemy
    return roulette[rand(roulette.size)]
  end
  #--------------------------------------------------------------------------
  # * Random Selection of a Target Enemy (HP 0)
  #--------------------------------------------------------------------------
  def random_target_enemy_hp0
    return random_target_enemy(true)
  end
  #--------------------------------------------------------------------------
  # * Smooth Selection of a Target Enemy
  #     enemy_index : enemy index
  #--------------------------------------------------------------------------
  def smooth_target_enemy(enemy_index)
    # Get an enemy
    enemy = @enemies[enemy_index]
    # If an enemy exists
    if enemy != nil and enemy.exist?
      return enemy
    end
    # Loop
    for enemy in @enemies
      # If an enemy exists
      if enemy.exist?
        return enemy
      end
    end
  end
end
