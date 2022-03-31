<?php
require_once '../get_data/get_rooms.php';
require_once '../insert_data/create_room.php';
class RoomModel{
    
    function joinOrCreate( $boardSize , $numberOfPlayer , $tokenPlayer){
        
        joinOrCreateRooms($boardSize , $numberOfPlayer , $tokenPlayer);
        
    }

    function getData($id){
        GetDataRoom($id);
    }

  

}