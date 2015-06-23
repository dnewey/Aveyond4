
class Scene_Battle

  def phase_victory_init

  	$battle.clear

  	# Everybody grin
  	@hud.all_grin

  	$scene.message.start("sys:Battle Victory")

  	@phase = :victory_xp  	

  end

  def phase_victory_xp

	$scene.message.start("sys:100 XP GAINED!")

	@phase = :victory_level

  end

  def phase_victory_level

  	# Show level up wallpapers
  	@hud.chars.each{ |c| c.box.wallpaper = $cache.menu_wallpaper("green")}

  	$scene.message.start("sys:Boyle is now level 1000!")

	@phase = :victory_end

  end

  def phase_victory_end
  	$game.pop_scene
  end


end