
class Scene_Battle

  def phase_intro_init

    wait(30)
  	@phase = :intro_prep

  end

  def phase_intro_prep

    # Put actors in idle pose

    [0,1,2,3].each{ |i| 

      if $party.active.count > i

        act = $party.actor_by_index(i).id
        
        if !$party.get(act).down?

            ev = $party.actor_by_index(i).ev
            next if ev == nil
            act = $party.actor_by_index(i).id
            ev.character_name = "Player/#{act}-idle"
            ev.pattern = rand(4)
            #ev.direction = 2
            ev.step_anime = true

        end
      end

    }

    #wait(30)
    @phase = :intro_action

  end

  def phase_intro_action


    # If there is a queue skill, start with that
    # Change this to be better than this
    if $battle.queue2 != nil

      $battle.enemies[$battle.queue2[0]].set_action($battle.queue2[1])

        @battle_queue = []
      @active_battler = $battle.enemies[$battle.queue2[0]]
      @phase = :main_prep
      return

   end

    @phase = :intro_minion

  end

  def phase_intro_minion

    @phase = :actor_init

  end

end