<?php
require_once('../controller/db.php');
require_once('../models/response.php');

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

if ($_SERVER['REQUEST_METHOD']  !== 'GET') {
    $response = new Response();
    $response->setHttpStatusCode(405);
    $response->setSuccess(false);
    $response->addMessage('Request method not allowed');
    $response->send();
    exit;
}


try {
    if (!isset($_GET['email']) || !isset($_GET['password'])) {
        $response = new Response();
        $response->setHttpStatusCode(500);
        $response->setSuccess(false);
        $response->addMessage('Not allowed');
        $response->send();
        exit;
    }

     

    $query = $writeDB->prepare('SELECT * FROM users_two_square_game WHERE email = :email');
    $query->bindParam(':email', $_GET['email'], PDO::PARAM_STR);
   
    $query->execute();
    $row =$query->fetch();
    if(empty($row)){
       
        $response = new Response();
        $response->setHttpStatusCode(500);
        $response->setSuccess(false);
        $response->addMessage('Check your email or password em ' .  $_GET['email']);
        $response->send();
    exit;
    }
    if( password_verify($_GET['password'], $row['password'])){
        $returnData = $row;
        $response = new Response();
        $response->setHttpStatusCode(201);
        $response->setSuccess(true);
        $response->setData($returnData);
        $response->send();
        exit;

    }else{
        $response = new Response();
        $response->setHttpStatusCode(500);
        $response->setSuccess(false);
        $response->addMessage('Check your email or password pass ' .password_hash($_GET['password'], PASSWORD_DEFAULT) );
        $response->send();
        exit;
    }
 
  
  
} catch (PDOException $ex) {
    error_log("Database query error: " . $ex, 0);
    $response = new Response();
    $response->setHttpStatusCode(500);
    $response->setSuccess(false);
    $response->addMessage('There was an issue Get Houses - please try again' . $ex);
    $response->send();
    exit;
}