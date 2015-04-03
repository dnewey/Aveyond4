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
    $player = @player
    @player.moveto(5,5)

        @map.update
        @player.update
        @map.update

        #@map.target = @player

    @tilemap = MapWrap.new(@vp) 
    #@tilemap.z = 500

    
    @tilemap.update

    refresh_tileset

    @hud = BattleHud.new(@vp_hud)

    # @character_sprites.push(Sprite_Character.new(@vp_main, @player))

    # Prepare characters
    (1..4).each{ |c|
      @map.events[c].direction = 4
    }


    Graphics.transition(50,'Graphics/System/trans')  
            
  end
  
  def terminate
    @character_sprites.each{ |s| s.dispose }
    
  end

  def busy?
    return false
  end

  #--------------------------------------------------------------------------
  # * Update the map contents and processes input from the player
  #--------------------------------------------------------------------------
  def update


    @player.update

    $battle.update
        @tilemap.ox = @map.display_x / 4
    @tilemap.oy = @map.display_y / 4
    @tilemap.update

    @map.display_x = 0
    @map.display_y = 0

    # Update character sprites
    @character_sprites.each{ |s|
      #log_info s.character.character_name
      s.update
      #s.x = 50
      #s.y = 50
    }

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




  #--------------------------------------------------------------------------
  # * Refresh Tileset
  #--------------------------------------------------------------------------
  def refresh_tileset
    @tileset_id = @map.tileset_id
    @tilemap.refresh(@map)

    #@character_sprites.each{ |s| s.dispose }
     @character_sprites = []

    for i in @map.events.keys.sort
      sprite = Sprite_Character.new(@vp_hud, @map.events[i])
      @character_sprites.push(sprite)
      sprite.x = 50
      sprite.y = 50
    end

    @character_sprites.push(Sprite_Character.new(@vp_hud, @player))

    # @character_sprites.push(Sprite_Character.new(@vp_main, @player))

  end

end