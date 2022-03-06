<?php
require_once('../controller/db.php');
require_once('../models/response.php');
require_once('../models/room_model.php');
require_once('../update/update_room.php');
try {
    $writeDB = DB::connectionWriteDB();
} catch (PDOException $ex) {
    error_log("connection Error: " . $ex, 0);
    $response = new Response();
    $response->setHttpStatusCode(500);
    $response->setSuccess(false);
    $response->addMessage('Database connection error');
    $response->send();
    exit;
}



if ($_SERVER['REQUEST_METHOD']  !== 'POST') {
    $response = new Response();
    $response->setHttpStatusCode(405);
    $response->setSuccess(false);
    $response->addMessage('Request method not allowed');
    $response->send();
    exit;
}


$rowPostData = file_get_contents('php://input');

if (!$jsonData = json_decode($rowPostData)) {

    $response = new Response();
    $response->setHttpStatusCode(400);
    $response->setSuccess(false);
    $response->addMessage('Request body is not valid json');
    $response->send();
    exit;
}
$room = new RoomModel();
if (isset($jsonData->boardSize) && !isset($jsonData->playerId)) {

    if (
        $jsonData->boardSize < 4 || $jsonData->boardSize > 6
    ) {
        $response = new Response();

        $response->setHttpStatusCode(400);
        $response->setSuccess(false);

        $jsonData->boardSize < 4 ?  $response->addMessage("Board Size cannot be less than 4") : false;
        $jsonData->boardSize > 6 ?  $response->addMessage("Board Size  cannot be greater than 6") : false;

        $response->send();
        exit;
    }

    
    $boardSize = trim($jsonData->boardSize);

    $room->joinOrCreate($boardSize);
    $response = new Response();
    $response->setHttpStatusCode(400);
    $response->setSuccess(false);

    $response->addMessage("You can't access link");

    $response->send();
    exit;
    return;
} else if (isset($jsonData->playerId) && !isset($jsonData->boardSize)) {
    if (!isset($jsonData->roomId) || !isset($jsonData->number1) || !isset($jsonData->number2)) {
    } else {
        playController($jsonData->roomId,$jsonData->playerId,$jsonData->number1,$jsonData->number2);
        return;
    }
} else {
    if(isset($jsonData->message)){
      if($jsonData->message="Get Data"){
        $room->getData($jsonData->roomId);
        return;
      }
    }else{
    $response = new Response();
    $response->setHttpStatusCode(400);
    $response->setSuccess(false);

    $response->addMessage("You can't access link");

    $response->send();
    exit;
    }
}
