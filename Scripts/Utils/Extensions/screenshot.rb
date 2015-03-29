#=============================================================================
# * Snapshot script from screenshot.dll, Modified from GAMEGUY's SCRIPT
#=============================================================================
module Snapshot
  def self.snap
    snp = Win32API.new('screenshot.dll', 'Screenshot', %w(l l l l p l l), '')
    window = Win32API.new('user32', 'FindWindowA', %w(p p), 'l')
    ini = (Win32API.new 'kernel32', 'GetPrivateProfileStringA', %w(p p p p l p), 
      'l')
    game_name = '\0' * 256
    ini.call('Game', 'Title', '', game_name, 255, '.\Game.ini')
    game_name.delete!('\0')
    win = window.call('RGSS Player', game_name)
    count = 0
    
    file_name = "Graphics/Pictures/temp_screenshot#{rand(30)}.png"


    log_info 'works to here'

    snp.call(0, 0, 640, 480, file_name, win, 2)
  end
end