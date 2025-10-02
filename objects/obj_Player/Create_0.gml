/// @description Setup Player

localSteamID = steam_get_user_steam_id();
lobbyHost = steam_lobby_get_owner_id();
isHost = steam_lobby_is_owner();
isLocal = (localSteamID == steamID)
lobbyMemberID = 0;
image_index =lobbyMemberID;

xInput = 0;
yInput = 0;

moveSpeed = 5
fireCooldown = 50
currentCooldown = 0

init_controls()