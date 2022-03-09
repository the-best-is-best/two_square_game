<?php
require_once('../controller/db.php');
require_once('../models/response.php');
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

if(!isset($jsonData->roomId)){


   
        $response = new Response();
        $response->setHttpStatusCode(400);
        $response->setSuccess(false);
    
        (!isset($jsonData->roomId) ?  $response->addMessage("Room id not supplied") : false);
       
        $response->send();
        exit;
    
    
}else{
$query = $writeDB->prepare('DELETE FROM rooms_two_square_game  WHERE id = :id');

$query->bindParam(':id', $jsonData->roomId, PDO::PARAM_STR);
$query->execute();
}