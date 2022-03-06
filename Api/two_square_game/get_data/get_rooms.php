<?php
require '../insert_data/create_room.php';
require_once('../controller/db.php');
require_once('../models/response.php');
require_once '../update/update_room.php';



function joinOrCreateRooms($boardSize)
{

    try {
        $readDB = DB::connectReadDB();
    } catch (PDOException $ex) {
        error_log("connection Error: " . $ex, 0);
        $response = new Response();
        $response->setHttpStatusCode(500);
        $response->setSuccess(false);
        $response->addMessage('Database connection error');
        $response->send();
        exit;
    }

    $query = $readDB->prepare("SELECT * FROM rooms WHERE boardSize = $boardSize  AND started = 0");
    $query->execute();
    $row = $query->fetch();
    if (empty($row)) {

        makeRooms($boardSize);
    } else {

        JoinRoom($readDB, $row['id']);
        $query = $readDB->prepare("SELECT * FROM rooms WHERE boardSize = $boardSize  AND started = 1 ORDER BY id DESC LIMIT 1");
        $query->execute();
        $row = $query->fetch();
        $response = new Response();
        $response->setHttpStatusCode(201);
        $response->setSuccess(true);
        $response->setData($row);
        $response->addMessage('Join Room');
        $response->send();
        exit;
    }
}
function GetDataRoom($id){
    
    try {
        $readDB = DB::connectReadDB();
    } catch (PDOException $ex) {
        error_log("connection Error: " . $ex, 0);
        $response = new Response();
        $response->setHttpStatusCode(500);
        $response->setSuccess(false);
        $response->addMessage('Database connection error');
        $response->send();
        exit;
    }
    $query = $readDB->prepare("SELECT * FROM rooms WHERE id = $id ");
    $query->execute();
    $row = $query->fetch();
    $response = new Response();
    $response->setHttpStatusCode(201);
    $response->setSuccess(true);
    $response->setData($row);
    $response->addMessage('Get Data');
    $response->send();

}