package ru.kubline.net {
/**
 * класс содержит настройки для логина на сервер
 */
public class Server {

    /**
     * главный сервер
     */
    //public static const MAIN:Server = new Server("footboll.loc", 80);
    public static var MAIN:Server;// = new Server("70.40.192.88/footballer/", 80);
    public static var STATIC:Server;// = new Server("70.40.192.88/footballer/", 80);
    public static var STATIC_SECOND:Server;// = new Server("70.40.192.88/footballer/", 80);

    private var host:String;
    private var directories:String;

    private var port:int;

    public function Server(host:String, port:int, directories:String) {
        this.host = host;
        this.port = port;
        this.directories = directories;
    }

    public function getHost():String {
        return host;
    }

    public function getPort():int {
        return port;
    }

    public function getDirectories():String {
        return directories;
    }
}
}