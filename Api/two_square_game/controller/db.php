<?php

class DB
{
    private static $writeDBConnection;
    private static $readDBConnection;

    
   private static $db_name ="two_square_game";
   private static $db_user = "root";
   private static $db_pass ="";

    public static function connectionWriteDB()
    {
        if (self::$writeDBConnection === null) {
            self::$writeDBConnection = new PDO('mysql:host=localhost;dbname=' . self::$db_name .';utf8', self::$db_user, self::$db_pass);
            self::$writeDBConnection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            self::$writeDBConnection->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
        }

        return self::$writeDBConnection;
    }

    public static function connectReadDB()
    {
        if (self::$readDBConnection === null) {
            self::$readDBConnection = new PDO('mysql:host=localhost;dbname='. self::$db_name .';utf8',self:: $db_user, self::$db_pass);
            self::$readDBConnection->setAttribute(PDO::ATTR_ERRMODE, PDO::ERRMODE_EXCEPTION);
            self::$readDBConnection->setAttribute(PDO::ATTR_EMULATE_PREPARES, false);
        }

        return self::$readDBConnection;
    }
}
