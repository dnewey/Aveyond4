#=============================================================================
# * Snapshot script from screenshot.dll, Modified from GAMEGUY's SCRIPT
#=============================================================================
module Snapshot
  def self.snap
    snp = Win32API.new('screenshot.dll', 'Screenshot', %w(l l l l p l l), '')    
    file_name = "#{$appdata}//temp.png"
    snp.call(0, 0, 640, 480, file_name, $mouse.hwnd, 2)
  end
end