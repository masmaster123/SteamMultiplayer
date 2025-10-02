///@self obj_server
function send_player_sync(_steam_id){
	var _b = buffer_create(1,buffer_grow,1); // create the buffer
	buffer_write(_b,buffer_u8,NETWORK_PACKETS.SYNC_PLAYERS);
	buffer_write(_b, buffer_string, shrink_player_list());
	steam_net_packet_send(_steam_id,_b);
	buffer_delete(_b);
}

///@self obj_server
function send_player_spawn(_steam_id,_slot){
	var _pos = grab_spawn_point(_slot);
	var _b = buffer_create(5,buffer_fixed,1); // first byte = the purpose, second two bytes x position and last two bytes y position
	buffer_write(_b,buffer_u8,NETWORK_PACKETS.SPAWN_SELF);
	buffer_write(_b,buffer_u16,_pos.x);
	buffer_write(_b,buffer_u16,_pos.y);
	steam_net_packet_send(_steam_id,_b);
	buffer_delete(_b);
	server_player_spawn_at_position(_steam_id,_pos);
	send_other_player_spawn(_steam_id,_pos);
}

function send_other_player_spawn(_steam_id,_pos){
	var _b = buffer_create(13,buffer_fixed,1); // first byte = the purpose, second two bytes x position and last two bytes y position, Steam id is the remaining eight
	buffer_write(_b, buffer_u8,NETWORK_PACKETS.SPAWN_OTHER); // Purpose
	buffer_write(_b, buffer_u16,_pos.x);
	buffer_write(_b, buffer_u16,_pos.y);
	buffer_write(_b, buffer_u64,_steam_id);
	//send to all other players than the one who joined
	for(var _i = 0; _i < array_length(playerList);_i++){
		if(playerList[_i].steamID != _steam_id){
			steam_net_packet_send(playerList[_i].steamID,_b);
		}
	}
	buffer_delete(_b);
}


///@self obj_server
function shrink_player_list(){ // Shrinks the size of player info by removing the character
	//var _shrunkList = playerList;
	//for(var _i = 0; _i < array_length(_shrunkList);_i++){
	//	_shrunkList[_i].character = undefined;
	//}
	return json_stringify(playerList);
}

///@self obj_server
function server_player_spawn_at_position(_steam_id,_pos){
	var _layer = layer_get_id("Instances");
	for(var _i = 0; _i < array_length(playerList); _i++){
		var _inst = instance_create_layer(_pos.x, _pos.y,_layer,obj_Player,{
			steamName: playerList[_i].steamName,
			steamID : _steam_id,
			lobbyMemberID :_i
		});
		playerList[_i].character = _inst;
	}
}


///@self obj_Server
function send_player_input_to_clients(_player_input){
	if(_player_input == undefined)
		return;
	var _b = buffer_create(13,buffer_fixed,1); // 1+8+1+1+1+1
	buffer_write(_b, buffer_u8, NETWORK_PACKETS.SERVER_PLAYER_INPUT);//1
	buffer_write(_b, buffer_u64,_player_input.steamID); //8
	buffer_write(_b,buffer_s8, _player_input.xInput); // 1
	buffer_write(_b, buffer_s8, _player_input.yInput);// 1
	buffer_write(_b,buffer_u8,_player_input.runKey); // 1
	buffer_write(_b,buffer_u8,_player_input.actionKey); // 1
	
	for(var _i =0; _i < array_length(obj_Server.playerList); _i++){
		if(obj_Server.playerList[_i].steamID != obj_Server.steamID){
			steam_net_packet_send(obj_Server.playerList[_i].steamID,_b);
		}
	}
	buffer_delete(_b);
	

}
