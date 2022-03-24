<?php
require_once('../controller/db.php');
require_once('../models/response.php');
try {
    $conDB = DB::connectionWriteDB();
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

if (!isset($jsonData->roomId) || !isset($jsonData->userId)) {



    $response = new Response();
    $response->setHttpStatusCode(400);
    $response->setSuccess(false);

    (!isset($jsonData->roomId) ?  $response->addMessage("Room id not supplied") : false);
    (!isset($jsonData->userId) ?  $response->addMessage("User id not supplied") : false);
    $response->send();
    exit;
} else {
    try {
        $query = $conDB->prepare("SELECT id_user1 , id_user2 , id_user3 , id_user4 FROM rooms_two_square_game WHERE id = $jsonData->roomId ");
        $query->execute();
        $row = $query->fetch();
        if ($jsonData->userId == 1) {
            $row['id_user1'] = null;
        } else if ($jsonData->userId == 2) {
            $row['id_user2'] = null;
        } else if ($jsonData->userId == 3) {
            $row['id_user3'] = null;
        } else if ($jsonData->userId == 4) {
            $row['id_user4'] = null;
        }
print_r($row);
        $query = $conDB->prepare('UPDATE rooms_two_square_game SET id_user1 = :id_user1 , id_user2 = :id_user2 , id_user3 = :id_user3 , id_user4 = :id_user4 WHERE id = :id');

        $query->bindParam(':id', $jsonData->roomId, PDO::PARAM_STR);
        $query->bindParam(':id_user1',   $row['id_user1'], PDO::PARAM_STR);
        $query->bindParam(':id_user2',   $row['id_user2'], PDO::PARAM_STR);
        $query->bindParam(':id_user3',   $row['id_user3'], PDO::PARAM_STR);
        $query->bindParam(':id_user4',   $row['id_user4'], PDO::PARAM_STR);
        $query->execute();
    } catch (Exception $ex) {
        print($ex);
    }
}
