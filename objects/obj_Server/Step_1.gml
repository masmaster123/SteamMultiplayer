///@description Listening for activy as server

//Receiving Packets
while(steam_net_packet_receive()){

	var _sender = steam_net_packet_get_sender_id();
	steam_net_packet_get_data(inbuff); //store recieved packet into clients inbufffer
	buffer_seek(inbuff,buffer_seek_start,0); // Always start at the head of the buffer
	var _type = buffer_read(inbuff,buffer_u8);
	
	switch(_type){
		
		case NETWORK_PACKETS.CLIENT_PLAYER_INPUT:
			var _playerInput = recieve_player_input(inbuff,_sender);
			//Send input to all the other clients
			send_player_input_to_clients(_playerInput);
			break;
		
		default:
			show_debug_message("Unknown Packet received: " + string(_type));
			break;
	
	}


}