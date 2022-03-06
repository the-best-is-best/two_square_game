<?php
require_once '../delete/room_delete_end.php';
function JoinRoom($writeDB, $id)
{

    $query = $writeDB->prepare('UPDATE rooms SET started = :started , id_user2=:id_user2 WHERE id = :id ');
    $started = 1;
    $id_user2 = 2;
    $query->bindParam(':id', $id, PDO::PARAM_STR);
    $query->bindParam(':started', $started, PDO::PARAM_STR);
    $query->bindParam(':id_user2', $id_user2, PDO::PARAM_STR);
    $query->execute();
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
    $query = $readDB->prepare("SELECT * FROM rooms WHERE id = $id");
    $query->execute();
    $row = $query->fetch();

    $board = json_decode($row['board']);
    $boardSize = $row['boardSize'];
    $totalGameNum = $row['totalGameNum'];
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
                exit;
            }
            if ($turns != 0) {
                $board =  json_encode($board);

                $query = $writeDB->prepare('UPDATE rooms SET turn = :turn , board= :board WHERE id = :id ');
                $turn = $row['turn'] == 1 ? 2 : 1;

                $query->bindParam(':id', $id, PDO::PARAM_STR);
                $query->bindParam(':turn', $turn, PDO::PARAM_STR);
                $query->bindParam(':board', $board, PDO::PARAM_STR);

                $query->execute();
                $response = new Response();
                $response->setHttpStatusCode(201);
                $response->setSuccess(true);
                $response->addMessage('Next Player');
                $response->send();
                exit;
            } else {
                
                deleteRoomEnd($id);
                $response = new Response();
                $response->setHttpStatusCode(201);
                $response->setSuccess(true);
                $response->addMessage('Player Win');
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
