/// @description Setup Player

localSteamID = steam_get_user_steam_id();
isLocal = (localSteamID == steamID)
lobbyMemberID = 0;

moveSpeed = 5
fireCooldown = 50
currentCooldown = 0

init_controls()