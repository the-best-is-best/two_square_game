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
  

if ($_SERVER['CONTENT_TYPE'] !== 'application/json') {
    $response = new Response();
    $response->setHttpStatusCode(400);
    $response->setSuccess(false);
    $response->addMessage('Content Type header not json');
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


if (!isset($jsonData->userName) || !isset($jsonData->password) || !isset($jsonData->phone) ||  !isset($jsonData->email)) {

    $response = new Response();
    $response->setHttpStatusCode(400);
    $response->setSuccess(false);

    (!isset($jsonData->userName) ?  $response->addMessage("User Name not supplied") : false);
    (!isset($jsonData->email) ?  $response->addMessage("Email not supplied") : false);
    (!isset($jsonData->password) ?  $response->addMessage("password not supplied") : false);
    (!isset($jsonData->phone) ?  $response->addMessage("Phone not supplied") : false);

    $response->send();
    exit;
}


if (
    strlen($jsonData->userName) < 1 || strlen($jsonData->userName) > 255 || 
    strlen($jsonData->password) < 3 || strlen($jsonData->password) > 255 || 
    strlen($jsonData->phone) < 10 ||  strlen($jsonData->email) < 5 || !filter_var($jsonData->email, FILTER_VALIDATE_EMAIL)
) {
    $response = new Response();

    $response->setHttpStatusCode(400);
    $response->setSuccess(false);

    (strlen($jsonData->userName) < 1 ?  $response->addMessage("User Name cannot be black") : false);
    (strlen($jsonData->userName) > 255 ?  $response->addMessage("User Name cannot be greater than 255 characters") : false);
   
    (strlen($jsonData->email) < 5 ?  $response->addMessage("Email cannot be black or less than 5") : false);
    if(!filter_var($jsonData->email, FILTER_VALIDATE_EMAIL)) {
        $emailErr = "Invalid email format";
        $response->addMessage($emailErr);
      }else{
          false;
      }


    (strlen($jsonData->password) < 3 ?  $response->addMessage("Password cannot be black or less than 3") : false);
    (strlen($jsonData->password) > 255 ?  $response->addMessage("Password cannot be greater than 255 characters") : false);

    (strlen($jsonData->phone) < 10 ?  $response->addMessage("Phone cannot be black or less than 10") : false);
    (strlen($jsonData->phone) > 15 ?  $response->addMessage("Phone error") : false);

    $response->send();
    exit;
}
$userName = trim($jsonData->userName);
$password = trim($jsonData->password);
$phone = trim($jsonData->phone);
$email = trim($jsonData->email);

$password =password_hash($password, PASSWORD_DEFAULT);

try {
    $query = $writeDB->prepare('SELECT id FROM users_two_square_game WHERE phone = :phone');
    $query->bindParam(':phone', $phone, PDO::PARAM_STR);
    $query->execute();

    $rowCount = $query->rowCount();
    if ($rowCount !== 0) {
        $response = new Response();
        $response->setHttpStatusCode(409);
        $response->setSuccess(false);
        $response->addMessage('Phone already exists');
        $response->send();
        exit;
    }

    $query = $writeDB->prepare('SELECT id FROM users_two_square_game WHERE email = :email');
    $query->bindParam(':email', $email, PDO::PARAM_STR);
    $query->execute();

    $rowCount = $query->rowCount();
    if ($rowCount !== 0) {
        $response = new Response();
        $response->setHttpStatusCode(409);
        $response->setSuccess(false);
        $response->addMessage('Email already exists');
        $response->send();
        exit;
    }
    $query = $writeDB->prepare('INSERT into users (userName , password , phone , email )
         VALUES (:userName , :password , :phone , :email)');

    $query->bindParam(':userName', $userName, PDO::PARAM_STR);
    $query->bindParam(':password', $password, PDO::PARAM_STR);
    $query->bindParam(':phone', $phone, PDO::PARAM_STR);
    $query->bindParam(':email', $email, PDO::PARAM_STR);

    $query->execute();
    $rowCount = $query->rowCount();

    if ($rowCount === 0) {
        $response = new Response();
        $response->setHttpStatusCode(500);
        $response->setSuccess(false);
        $response->addMessage('There was an issue creating Users - please try again');
        $response->send();
        exit;
    }


    $response = new Response();
    $response->setHttpStatusCode(201);
    $response->setSuccess(true);
    $response->addMessage('Users Created');
    $response->send();
    exit;
} catch (PDOException $ex) {
    error_log("Database query error: " . $ex, 0);
    $response = new Response();
    $response->setHttpStatusCode(500);
    $response->setSuccess(false);
    $response->addMessage('There was an issue creating Users - please try again' . $ex);
    $response->send();
    exit;
}
