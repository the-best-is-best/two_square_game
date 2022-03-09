<?php

function  makeRooms($boardSize)
{
    
    try {
        $writeDB = DB::connectionWriteDB();
        $readDB = DB::connectionWriteDB();
    } catch (PDOException $ex) {
        error_log("connection Error: " . $ex, 0);
        $response = new Response();
        $response->setHttpStatusCode(500);
        $response->setSuccess(false);
        $response->addMessage('Database connection error');
        $response->send();
        exit;
    }

    $query = $writeDB->prepare('SELECT * FROM rooms_two_square_game ORDER BY id DESC LIMIT 1');
    $query->execute();
    $row = $query->fetch();
    $id = 1;
    if ($row != null) {

        $id = $row['id'] + 1;
    }
    $totalGameNum = pow($boardSize, 2);
    $board = [];
    for ($i = 0; $i < $totalGameNum; $i++) {
        array_push($board, $i + 1);
    }
    $board =  json_encode($board);
    $query = $writeDB->prepare('INSERT into rooms_two_square_game (id  , board , boardSize ,totalGameNum)
    VALUES (:id , :board , :boardSize , :totalGameNum)');

    $query->bindParam(':id', $id, PDO::PARAM_STR);
    $query->bindParam(':board',  $board, PDO::PARAM_STR);
    $query->bindParam(':boardSize', $boardSize, PDO::PARAM_STR);
    $query->bindParam(':totalGameNum', $totalGameNum, PDO::PARAM_STR);

    $query->execute();
    $rowCount = $query->rowCount();

    if ($rowCount === 0) {
        $response = new Response();
        $response->setHttpStatusCode(500);
        $response->setSuccess(false);
        $response->addMessage('There was an issue creating Room - please try again');
        $response->send();
        exit;
    }
    $query = $readDB->prepare("SELECT * FROM rooms_two_square_game ORDER BY id DESC LIMIT 1");
    $query->execute();
    $row = $query->fetch();

    $response = new Response();
    $response->setHttpStatusCode(201);
    $response->setSuccess(true);
    $response->setData($row);
    $response->addMessage('Room Created');
    $response->send();
    exit;
}

