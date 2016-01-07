package ru.kubline.net {

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.events.TimerEvent;
import flash.net.Socket;
import flash.system.Security;
import flash.utils.ByteArray;

import flash.utils.Timer;
import flash.utils.getQualifiedClassName;

import ru.kubline.logger.luminicbox.Logger;
import ru.kubline.serialization.BinarySerializer;
import ru.kubline.serialization.interfaces.ICommandHeader;
import ru.kubline.serialization.internals.BinaryCommandHeader;

/**
 * класс отвечает за взаимодействие клиента с сервером,
 * то есть подключатся к серверу, отправляет туда команды,
 * принимает команды и отправляет их на дисериализацию а так же рассылает событие о том что пришла новая команда
 *
 * @autor denis
 */
public class SocketConnection extends EventDispatcher {

    // create logger instance
    private static var log:Logger = new Logger(SocketConnection);

    /**
     * разрешаем социалке получать доступ к приложению
     */
    Security.allowDomain("vkontakte.ru", "*.vkontakte.ru", "vk.com", "*.vk.com");

     /**
     * таймер по которому будем слать команду пинг на сервер
     */
    private var pingTimer:Timer;

    /**
     * сериализатор который будет
     */
    private var serializer:BinarySerializer = BinarySerializer.getInstance();

    /**
     * сокет для взаимодействия с сервером
     */
    private var socket:Socket;

    /**
     * хотс сервра
     */
    private var host:String;

    /**
     * порт на сервере к которому будет происходить подключение
     */
    private var port:uint;

    /**
     * т.к. протокол TCP/IP бъет команду на пакеты,
     * то нам нужен некий буфер в котором мы будем накапливать байтики
     * до тех пор пока не придут все части команды
     */
    private var deserializeInputStream:ByteArray;

    private var inputPosition:uint = 0;

    private var needReadHeader:Boolean =true;

    /**
     * команда которой будем пинговать сервер
     */
    private var pingMsg:Object;

    private var pingTimeout:int;

    /**
     * @param host хост сервера
     * @param port порт сервера
     */
    public function SocketConnection(host:String, port:uint, pingMsg:Object, pingTimeout:int = 30000) {
        this.host = host;
        this.port = port;
        this.pingTimeout = pingTimeout;
        this.deserializeInputStream = new ByteArray();
        socket = new Socket(host, port);
        //подписываемся на события сокета
        socket.addEventListener(Event.CLOSE, closeHandler);
        socket.addEventListener(Event.CONNECT, onConnectedHandler);
        socket.addEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        socket.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        socket.addEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);        
    }

    public function connect(): void {
        Security.loadPolicyFile("xmlsocket://" + host + ":5190");
        socket.connect(host, port);
        
        //отправляем команду ping каждых pingTimeout секунд если соединение простаивает
        pingTimer = new Timer(pingTimeout);
        pingTimer.addEventListener(TimerEvent.TIMER, function():void {
            send(pingMsg);
        });
    }

    public function close():void {
        socket.close();
        pingTimer.stop();
    }

    protected function closeHandler(event:Event) : void {
        log.fatal("connection to " + host + ":" + port + " was closed by server");
        this.host = null;
        this.port = 0;
        socket.removeEventListener(Event.CLOSE, closeHandler);
        socket.removeEventListener(Event.CONNECT, onConnectedHandler);
        socket.removeEventListener(IOErrorEvent.IO_ERROR, ioErrorHandler);
        socket.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
        socket.removeEventListener(ProgressEvent.SOCKET_DATA, socketDataHandler);
        socket = null;
        this.deserializeInputStream.length = 0;
        this.inputPosition = 0;
        pingTimer.stop();

        super.dispatchEvent(event);
    }

    protected function onConnectedHandler(event:Event) : void {
        log.info("connected to " + host + ":" + port);
        dispatchEvent(event);
    }

    protected function ioErrorHandler(event:IOErrorEvent) : void {
        log.error("IoError: " + event.toString());
        dispatchEvent(event);
    }

    protected function securityErrorHandler(event:SecurityErrorEvent) : void {
        log.error("SecurityError: " + event.toString());
        dispatchEvent(event);
    }

    private var header:ICommandHeader;

    /**
     * основной метод получения данных от сервера
     */
    private function socketDataHandler(event:Event) : void {
        if(socket.bytesAvailable > 0){
            var data:ByteArray = new ByteArray();
            //считываем все пришедшие байтики в объект data
            socket.readBytes(data);
            log.debug("reading data from socket, length: " + data.length +" needHeaderRead: " + needReadHeader);

            if(deserializeInputStream.bytesAvailable == 0) {
                deserializeInputStream = new ByteArray();
            }
            data.readBytes(deserializeInputStream, deserializeInputStream.length);

            // сюда будем писать оставшиеся данные
            var tail:ByteArray = new ByteArray();
            try {
                do {
                    if(needReadHeader) {
                        header = new BinaryCommandHeader();
                        header.read(deserializeInputStream);
                        //заголовок прочли, теперь читаем тело
                        needReadHeader =false;
                        log.debug("header readed, header.commandId=" + header.getCommandId() +
                                  ", header.length=" + header.getLength() + ", try to read body");
                    }

                    //если в буфере достаточно байт для того чтобы собрать команду, то
                    if (header != null && deserializeInputStream.bytesAvailable >= header.getLength()) {
                        //тело команды сохраним сюда
                        var commandData:ByteArray = new ByteArray();
                        //команда может быть маркерной, тоесть без тела
                        if (header.getLength() > 0) {
                            //читаем тело команды
                            deserializeInputStream.readBytes(commandData, 0, header.getLength());
                        }
                        log.debug("Command is readed fully, commandData.length: " + commandData.bytesAvailable);
                        //команда прочтена, читаем следующую
                        needReadHeader =true;
                        log.debug("try to read next command...");
                        var msg:Object = serializer.deserializeCommand( commandData, header);
                        if (msg != null) {
                            log.warn("Command is deserialazed, msg: " + msg);
                            //рассылаем событие всем слушателям данной команды
                            dispatchEvent(new IncommingMessageEvent(msg, getQualifiedClassName(msg)));
                        } else {
                            log.error("error while deserialize command, commandId: "+header.getCommandId());
                        }
                    } else {
                        log.debug("waiting for other part of command, needByte:" + header.getLength() +
                                  ", available: " + deserializeInputStream.bytesAvailable);
                        //сохроняем конец команды
                        if(deserializeInputStream.bytesAvailable > 0) {
                            deserializeInputStream.readBytes(tail);
                        }
                    }
                } while(deserializeInputStream.bytesAvailable > 0);
            } catch(ex:Error) {
                log.error("Deserialize ERROR: " + ex.toString());
                needReadHeader = true;
            }
            // Создаем поток с оставшимися данными
            deserializeInputStream = new ByteArray();
            tail.readBytes(deserializeInputStream);
        } else {
            log.error("deserialized data can't be empty");
        }
    }

    /**
     * отправка команды на сервер
     * @param obj команда которую необходимо отослать
     */
    public function send(obj:Object):void {
        log.warn("try to send message ["+ obj +"] to server...");
        pingTimer.reset();
        
        var stream:ByteArray = new ByteArray();
        serializer.serializeCommand(obj, stream);
        socket.writeBytes(stream);
        socket.flush();
        var isConnected:Boolean  = socket.connected;
        log.debug("connection status:" + isConnected);

        pingTimer.start();
    }

    /**
     * добавить обработчик на входящую команду
     * @param messageClass класс входящей команды
     * @param listener обработчик
     */
    public function addListener(messageClass:Class, listener:Function):void {
        log.debug("addMessageListener for message: " + getQualifiedClassName(messageClass));
        addEventListener(getQualifiedClassName(messageClass), listener);
    }

    /**
     * удалить обработчик входящей команды
     * @param messageClass класс входящей команды
     * @param listener обработчик
     */
    public function removeListener(messageClass:Class, listener:Function):void {
        log.debug("removeMessageListener for message: " + getQualifiedClassName(messageClass));
        removeEventListener(getQualifiedClassName(messageClass), listener);
    }
}
}