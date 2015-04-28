
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
    battler = Game_Battler.new
    battler.init_enemy(enemy)
    @enemies.push(battler)
  end

  def start
    $game.push_scene(Scene_Battle.new)
  end

  def win?
    return false
  end



  def build_action_result(attacker)

    skill = $data.skills[attacker.skill_id]

    # First, how many attacks are happening
    num_hits = calc_hits(skill)

    # Attack already has skill selected, and targets if scope requires
    targets = build_target_list(attacker)

    # Get the defender, calc damage done, hmmmmm
    # Multi stage damage supported here


  end

  def build_target_list(attacker)

    # Get scope, prepare targets, return list
    targets = []

    case attacker.scope

      when 'single'

    end

  end

  def calc_hits(skill)
    # Need to check for 3-4 random hits and decide on amount
    return skill.hits.to_i
  end
  
end
  