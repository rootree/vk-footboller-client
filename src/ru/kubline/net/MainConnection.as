package ru.kubline.net {

import flash.events.Event;

import ru.kubline.interfaces.lang.Messages;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.messages.client.Ping;
import ru.kubline.logger.luminicbox.Logger;
import ru.kubline.net.SocketConnection;

/**
 * класс отвечает за взаимодействие клиента с сервером,
 * то есть подключатся к серверу, отправляет туда команды,
 * принимает команды и отправляет их на дисериализацию а так же рассылает событие о том что пришла новая команда
 *
 * @autor denis
 */
public class MainConnection extends HTTPConnection {

    // create logger instance
    private static var log:Logger = new Logger(MainConnection);

    private static var INSTANCE:MainConnection;

    public function MainConnection(host:String, port:uint) {
        super(host, port);
        INSTANCE = this;
    }

    /**
     * отправка команды на сервер
     * @param obj команда которую необходимо отослать
     */
    public static function sendMessage(obj:Object):void {
        // INSTANCE.send();
    }
 
}
}