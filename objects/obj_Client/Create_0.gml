/// @description Init Client Variables

playerList = [];

inbuff = buffer_create(16,buffer_grow,1); // The in buffer

steamID = steam_get_user_steam_id();
steamName =steam_get_persona_name();
lobbyMemberID = undefined;
character = undefined;



playerList[0] = {
	steamID : steamID,
	steamName : steamName,
	character : undefined,
	startPos : grab_spawn_point(0),
	lobbyMemberID : 0

}