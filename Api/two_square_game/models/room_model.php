<?php
require_once '../get_data/get_rooms.php';
require_once '../insert_data/create_room.php';
class RoomModel{
    
    function joinOrCreate( $boardSize ){
        
        joinOrCreateRooms($boardSize);
        
    }

    function getData($id){
        GetDataRoom($id);
    }

    function  makeRoom( $boardSize){
       makeRooms($boardSize);   
    }

}