<?php
require_once('../insert_data/create_room.php');
require_once('../controller/db.php');
require_once('../models/response.php');
require_once('../update/update_room.php');
require_once('../models/fcm_model.php');



function joinOrCreateRooms($boardSize, $numOfPlayer, $tokenPlayer)
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

    $query = $readDB->prepare("SELECT  id , board , id_user1 , id_user2 , id_user3 , id_user4 FROM rooms_two_square_game WHERE boardSize = $boardSize  AND started = 0 AND numOfPlayer= $numOfPlayer");
    $query->execute();
    $row = $query->fetch();
    if (empty($row)) {
        sleep(3);

        makeRooms($boardSize, $numOfPlayer, $tokenPlayer);
    } else {

        $startGame = JoinRoom($readDB, $row['id'], $numOfPlayer,  $row['id_user1'], $row['id_user2'], $row['id_user3'], $row['id_user4']);

        if ($startGame[0] == "startGame") {
            $query = $readDB->prepare("SELECT  id , board FROM rooms_two_square_game WHERE boardSize = $boardSize  AND numOfPlayer= $numOfPlayer AND started = 1 ORDER BY id DESC LIMIT 1");
            $query->execute();
            $row = $query->fetch();
            $row["yourId"] = $startGame[1];
            $response = new Response();
            $response->setHttpStatusCode(201);
            $response->setSuccess(true);
            $response->setData($row);
            $response->addMessage('Join Room');

            $response->send();

            $dataFCM = array('message' => 'joined');
            subscribeFCM('room_' . $row['id'], $tokenPlayer);
            sleep(1);
            sendFCM($dataFCM, 'room_' . $row['id']);

            exit;
        } else {
            $query = $readDB->prepare("SELECT id , board FROM rooms_two_square_game WHERE boardSize = $boardSize  AND started = 0  AND numOfPlayer= $numOfPlayer ORDER BY id DESC LIMIT 1");
            $query->execute();
            $row = $query->fetch();
            $row["yourId"] = $startGame[1];
            $response = new Response();
            $response->setHttpStatusCode(201);
            $response->setSuccess(true);
            $response->setData($row);
            $response->addMessage('Waiting More Player');
            $response->send();
            subscribeFCM('room_' . $row['id'], $tokenPlayer);
            exit;
        }
    }
}
function GetDataRoom($id)
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
    $query = $readDB->prepare("SELECT board FROM rooms_two_square_game WHERE id = $id ");
    $query->execute();
    $row = $query->fetch();
    $response = new Response();
    $response->setHttpStatusCode(201);
    $response->setSuccess(true);
    $response->setData($row);
    $response->addMessage('Get Data');
    $response->send();


    $dataFCM = ['message' => "Start Time"];
    sendFCM($dataFCM, 'room_' . $id);
    exit;
}
