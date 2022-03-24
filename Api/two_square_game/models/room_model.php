<?php
require_once '../get_data/get_rooms.php';
require_once '../insert_data/create_room.php';
class RoomModel{
    
    function joinOrCreate( $boardSize , $numberOfPlayer ){
        
        joinOrCreateRooms($boardSize , $numberOfPlayer);
        
    }

    function getData($id){
        GetDataRoom($id);
    }

  

}