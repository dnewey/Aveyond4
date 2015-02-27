

def condition_applies?(cond)
      # cond is [code,data1.....]

    case cond[0]

      # Flag
      when '?flag'
          return false if !flag?(cond[1])
              
        # Progress
      when '?progress'
        return false if !progress?(cond[1])

      # Active Quest
      when '?active'
        return false if !on_quest?(cond[1])
         when '?quest'
        return false if !on_quest?(cond[1])  
              
        # Item Check
      when '?item'
        return false if !$game_party.has_item?(cond[1].to_i)

    end

    return true

  end