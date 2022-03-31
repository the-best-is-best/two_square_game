<?php
require_once('../controller/db.php');
require_once('../models/response.php');
require_once '../models/fcm_model.php';
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

if (!isset($jsonData->roomId) || !isset($jsonData->playerToken) || !isset($jsonData->playerId) || !isset($jsonData->roomError)) {



    $response = new Response();
    $response->setHttpStatusCode(400);
    $response->setSuccess(false);

    (!isset($jsonData->roomId) ?  $response->addMessage("Room id not supplied") : false);
    (!isset($jsonData->playerToken) ?  $response->addMessage("playerToken not supplied") : false);
    (!isset($jsonData->playerId) ?  $response->addMessage("playerId not supplied") : false);
    (!isset($jsonData->roomError) ?  $response->addMessage("roomError not supplied") : false);

    $response->send();


    exit;
} else {
   
    $resultFCM;
    if ($jsonData->roomError == 0) {
        $dataMessage = ["message" => "player lost"  ,"player"=> $jsonData->playerId];
        $resultFCM =  sendFCM($dataMessage, "room_$jsonData->roomId");
    } else if ($jsonData->roomError == 1) {
        $dataMessage = ["message" => "Room issue"];
        $resultFCM =  sendFCM($dataMessage, "room_$jsonData->roomId");
    }
unSubscribeFCM( "room_$jsonData->roomId" , $jsonData->playerToken);


  

   $query = $writeDB->prepare('DELETE FROM rooms_two_square_game  WHERE id = :id');

    $query->bindParam(':id', $jsonData->roomId, PDO::PARAM_STR);
    $query->execute();


}
