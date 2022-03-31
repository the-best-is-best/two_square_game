<?php
require_once '../delete/room_delete_end.php';
require_once '../models/fcm_model.php';


function JoinRoom($writeDB, $id, $numOfPlayer, $user1, $user2, $user3, $user4)
{

    $query = $writeDB->prepare('UPDATE rooms_two_square_game SET started = :started ,id_user1 =:id_user1 , id_user2=:id_user2 ,id_user3=:id_user3 ,id_user4=:id_user4    WHERE id = :id ');

    $id_user1 = $user1;
    $id_user2 = $user2;
    $id_user3 = $user3;
    $id_user4 = $user4;

    $my_userId = null;
    $started = 0;
    if ($user1 == null || $user1 == 0) {
        $my_userId = $id_user1 = 1;
    } else {
        if ($user2 == null || $user2 == 0) {
            if ($numOfPlayer == 2)
                $started = 1;

            $my_userId =  $id_user2 = 2;
        } else {
            if ($user3 == null  || $user3 == 0) {
                if ($numOfPlayer == 3)
                    $started = 1;

                $my_userId = $id_user3 = 3;
            } else {
                if ($numOfPlayer == 4)
                    $started = 1;

                $my_userId = $id_user4 = 4;
            }
        }
    }


    $query->bindParam(':id', $id, PDO::PARAM_STR);
    $query->bindParam(':started', $started, PDO::PARAM_STR);
    $query->bindParam(':id_user1', $id_user1, PDO::PARAM_STR);

    $query->bindParam(':id_user2', $id_user2, PDO::PARAM_STR);
    $query->bindParam(':id_user3', $id_user3, PDO::PARAM_STR);
    $query->bindParam(':id_user4', $id_user4, PDO::PARAM_STR);
    $query->execute();

    if ($started == 1)
        return array("startGame", $my_userId);
    else {
        return array("", $my_userId);
    }
}
function playController($id, $playerId, $action1, $action2)
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
    $query = $readDB->prepare("SELECT * FROM rooms_two_square_game WHERE id = $id");
    $query->execute();
    $row = $query->fetch();

    $board = json_decode($row['board']);
    $boardSize = $row['boardSize'];
    $totalGameNum = $row['totalGameNum'];
    $numOfPlayer = $row['numOfPlayer'];
    if ($playerId != $row['turn']) {
        // room destroyed
        deleteRoomEnd($id);
        $response = new Response();
        $response->setHttpStatusCode(201);
        $response->setSuccess(true);
        $response->setData($row);
        $response->addMessage('Room Destroyed');
        $response->send();
        exit;
    }
    if ($board[$action1 - 1] != "x" && $board[$action2 - 1] != "x") {
        if (
            abs($action2 - $action1) == $boardSize ||
            abs($action2 - $action1) == 1
        ) {
            if ($action1 != $totalGameNum || $action2 != $totalGameNum) {
                if (
                    $action1 % $boardSize == 0 && $action2 == $action1 + 1 ||
                    $action2 % $boardSize == 0 && $action1 == $action2 + 1
                ) {
                    $response = new Response();
                    $response->setHttpStatusCode(201);
                    $response->setSuccess(true);
                    $response->setData($row);
                    $response->addMessage('You can\'t play here');
                    $response->send();
                    exit;
                    return;
                }
            }

            $board[$action1 - 1] = "x";
            $board[$action2 - 1] = "x";

            $turns = 0;
            $draw = true;

            for ($i = 0; $i < count($board); $i++) {
                if ($board[$i] != "x") {
                    $draw = false;

                    if (($i + 1) % $boardSize != 0) {
                        if (($i + 1) < $totalGameNum && $board[$i + 1] != "x") {
                            $turns += 1;

                            break;
                        }
                    }

                    if (($i) % ($boardSize) != 0) {
                        if (($i - 1) >= 0 && $board[$i - 1] != "x") {
                            $turns += 1;

                            break;
                        }
                    }

                    if (($i - $boardSize) >= 0 && $board[$i - $boardSize] != "x") {
                        $turns += 1;

                        break;
                    }

                    if (($i + $boardSize) < $totalGameNum && $board[$i + $boardSize] != "x") {
                        $turns += 1;

                        break;
                    }
                }
            }
            if ($draw == true) {

                deleteRoomEnd($id);
                $response = new Response();
                $response->setHttpStatusCode(201);
                $response->setSuccess(true);
                $response->addMessage('No One Win The Game');
                $response->send();


                $dataFCM = ['message' => 'No One Win The Game'];
                sendFCM($dataFCM, 'room_' . $id);
                exit;
            }
            if ($turns != 0) {
                $board =  json_encode($board);

                $query = $writeDB->prepare('UPDATE rooms_two_square_game SET turn = :turn , board= :board WHERE id = :id ');
                $turn = $row['turn'];
                if ($turn == $numOfPlayer) {
                    $turn = 1;
                } else {
                    $turn++;
                }
                $query->bindParam(':id', $id, PDO::PARAM_STR);
                $query->bindParam(':turn', $turn, PDO::PARAM_STR);
                $query->bindParam(':board', $board, PDO::PARAM_STR);

                $query->execute();
                $response = new Response();
                $response->setHttpStatusCode(201);
                $response->setSuccess(true);
                $response->addMessage('Next Player');
                $response->send();

                $dataFCM = ['message' => "Get Data Player", "board" => $board];
                sendFCM($dataFCM, 'room_' . $id);
                exit;
            } else {
                $turn = $row['turn'];
                deleteRoomEnd($id);
                $response = new Response();
                $response->setHttpStatusCode(201);
                $response->setSuccess(true);
                $response->addMessage('Player Win');

                $dataFCM = ['message' => "Player Win", "player" => $turn];
                sendFCM($dataFCM, 'room_' . $id);
                $response->send();
                exit;
            }
        } else {
            // you can't play here
            $response = new Response();
            $response->setHttpStatusCode(201);
            $response->setSuccess(true);
            $response->addMessage('You can\'t play here');
            $response->send();
            exit;
        }
    } else {
        // you can't play here
        $response = new Response();
        $response->setHttpStatusCode(201);
        $response->setSuccess(true);
        $response->addMessage('You can\'t play here');
        $response->send();
        exit;
    }
}
