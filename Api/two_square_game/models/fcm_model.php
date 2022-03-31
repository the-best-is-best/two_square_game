<?php
require_once '../vendor/autoload.php';


function subscribeFCM($topic, $deviceId)
{
    $client = new \Fcm\FcmClient('AAAAReLpKTc:APA91bGR2YXjI0zEIMtwNf5zYDZhdEoPnVVsFLcyu7-od8n3SaDR7JMH_xr6xvPRNjBAj3m1tFgqrv8eo6ZLfHIQv8C39x-6zCpAaV3d0-m1nDWs4Lv4UmRWKZPxwTGP8nTp2vZUMpc9', '300159674679');

    $subscribe = new \Fcm\Topic\Subscribe($topic);
    $subscribe->addDevice($deviceId);

  $client->send($subscribe);

  
}
function unSubscribeFCM($topic, $deviceId)
{
    $client = new \Fcm\FcmClient('AAAAReLpKTc:APA91bGR2YXjI0zEIMtwNf5zYDZhdEoPnVVsFLcyu7-od8n3SaDR7JMH_xr6xvPRNjBAj3m1tFgqrv8eo6ZLfHIQv8C39x-6zCpAaV3d0-m1nDWs4Lv4UmRWKZPxwTGP8nTp2vZUMpc9', '300159674679');

    $subscribe = new \Fcm\Topic\unsubscribe($topic);
    $subscribe->addDevice($deviceId);

    $client->send($subscribe);
}



function sendFCM($dataMessage, $to)
{
    $client = new \Fcm\FcmClient('AAAAReLpKTc:APA91bGR2YXjI0zEIMtwNf5zYDZhdEoPnVVsFLcyu7-od8n3SaDR7JMH_xr6xvPRNjBAj3m1tFgqrv8eo6ZLfHIQv8C39x-6zCpAaV3d0-m1nDWs4Lv4UmRWKZPxwTGP8nTp2vZUMpc9', '300159674679');

    $notification = new \Fcm\Push\Notification();
    $notification
        ->addRecipient("/topics/$to")
        ->addDataArray($dataMessage);

    // Shortcut function:
    // $notification = $client->pushNotification('The title', 'The body', $deviceId);

    $response = $client->send($notification);

    return $response;
}
