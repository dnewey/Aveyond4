
class SteamManager

	def initialize
		# Sync with steam

		#dll, func, send, rec

		# Steam test
		log_info "STARTING STEAM"
    	log_info Win32API.new('System/steamstub', "OpenSteam", "I", "I").call(364270)
		log_info Win32API.new('System/steamstub', "ReadSteam", "[]", "I").call
    	
    	log_info Win32API.new('System/steamstub', "GetSteamAchievement", "P", "I").call("START_GAME")
log_info Win32API.new('System/steamstub', "ReadSteam", "[]", "I").call
    	log_info Win32API.new('System/steamstub', "SetSteamAchievement", "P", "I").call("START_GAME")
log_info Win32API.new('System/steamstub', "ReadSteam", "[]", "I").call
    	log_info Win32API.new('System/steamstub', "GetSteamAchievement", "P", "I").call("START_GAME")
    	log_info Win32API.new('System/steamstub', "ReadSteam", "[]", "I").call
    	#stats =  Win32API.new('System/steam_api', "SteamUserStats", ["V"], "P").call     	

	end


	def unlock(ach)

	end

	def card(crd)

	end

end