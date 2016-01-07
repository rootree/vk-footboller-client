package ru.kubline.utils {
public class ServerTime {

    private static var serverTime:Number;

    private static var deltaTime:Number;


    public function ServerTime() {
    }

    public static function getServerTime():Number
    {
        return serverTime;
    }

    public static function setServerTime(time:Number):void
    {
        serverTime = time;
        var currentTime:Number = Math.round(new Date().time / 1000);
        deltaTime = currentTime - serverTime; 
    }

    public static function getDeltaTime():Number
    {
        return deltaTime;
    }

    public static function getCurrentTime():Number
    {
        var currentTime:Number = Math.round(new Date().time / 1000);
        return currentTime;
    }
}
}