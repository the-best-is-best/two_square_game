<?php
require_once('../controller/db.php');
require_once('../models/response.php');

function deleteRoomEnd($id)
{
   
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

    $query = $writeDB->prepare('DELETE FROM rooms_two_square_game  WHERE id = :id');

    $query->bindParam(':id', $id, PDO::PARAM_STR);
    $query->execute();

}
