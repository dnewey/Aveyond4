
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

    @phase = :intro_end

  end

  def phase_intro_end

    @phase = :start_turn

  end

  def phase_start_turn

    # Start all autoruns for this turn
    start_events

    # Any text or skills will use up a turn of the battle? But states won't remove?

    @texts = []
    @skill = false

    @turn += 1

    if !$battle.queue.has_key?(@turn)
      @phase = :actor_init
      return
    end

    $battle.queue[@turn].each{ |action|

      case action[0]

        when :text
          log_scr action[1]
          @texts.push(action[1])
          @phase = :misc_text

          # If text and skill, do skill first, it will queue up after text is done

        when :skill

          @skill = true

          $battle.enemies[action[1]].set_action(action[2])

          @battle_queue = []
          @active_battler = $battle.enemies[action[1]]
          @phase = :main_prep

        when :escape      

          @phase = :misc_escape

        when :join

          join_s 'mys'
          @hud.build_views
          unhide('A.1')
          $party.get('mys').ev = gev('A.1')

      end

    }

  end

end