package ru.kubline.net {
import com.adobe.serialization.json.JSON;

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.events.ProgressEvent;
import flash.events.SecurityErrorEvent;
import flash.net.URLLoader;
import flash.net.URLLoaderDataFormat;
import flash.net.URLRequest;
import flash.net.URLRequestMethod;
import flash.net.URLVariables;
import flash.system.Security;

import flash.utils.getQualifiedClassName;

import flash.utils.getTimer;

import mx.formatters.DateFormatter;

import ru.kubline.controllers.Singletons;
import ru.kubline.crypto.MD5v2; 
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.logger.luminicbox.Logger;

/**
 * @autor ivan
 */

public class HTTPConnection extends EventDispatcher  {

    public static const COMMAND_PING:String = "ping";
    public static const COMMAND_WELCOME:String = "welcome";
    public static const COMMAND_FRIEND_INFO:String = "friend_info";
    public static const COMMAND_FRIEND_TEAM:String = "friend_team";
    public static const COMMAND_SAVE_SPONSORS:String = "save_sponsors";
    public static const COMMAND_SAVE_FOOTBALLER:String = "save_footballer";
    public static const COMMAND_SELL_FOOTBALLER:String = "sell_footballer";
    public static const COMMAND_BUY_FOOTBALLER:String = "buy_footballer";
    public static const COMMAND_BUY_STUDY_POINTS:String = "buy_study_points";
    public static const COMMAND_BUY_STADIUM:String = "buy_stadium";
    public static const COMMAND_GET_EMENY:String = "get_enemy";
    public static const COMMAND_GET_MATCH_RESULT:String = "get_result";
    public static const COMMAND_ADD_MONEY:String = "wonna_money";
    public static const COMMAND_DROP_ITEM:String = "drop_item";
    public static const COMMAND_CUSTOM:String = "customization";
    public static const COMMAND_FRIEND_IN_TEAM:String = "in_team_please";
    public static const COMMAND_UPDATE_ENERGY:String = "update_energy";
    public static const COMMAND_SEND_GIFT:String = "send_gift";
    public static const COMMAND_SET_AS_STAR:String = "set_as_star";
    public static const COMMAND_FRESH_ENERGY:String = "fresh_energy";
    public static const COMMAND_GROUPS:String = "tour_groups";
    public static const COMMAND_GET_TEAM_INFO:String = "team_info";

    // create logger instance
    private static var log:Logger = new Logger(HTTPConnection);

    Security.allowDomain("vkontakte.ru", "*.vkontakte.ru", "vk.com", "*.vk.com", "*.vk-footballer.com", "vk-footballer.com", "109.234.155.18");

    private var host:String;

    private var port:uint;

    private var inputPosition:uint = 0;

    private var needReadHeader:Boolean = true;
    
    private var pingMsg:Object;

    private var pingTimeout:int;

    private var loader:URLLoader;

    private var request:URLRequest;


    /**
     * ключ авторизации в социальной сети
     */
    private var authKey:String;

    /**
     * id друга который пригласил в игру
     */
    private var referrerId:uint;

    private var id:String;
    
    private static var result:Object;


    /**
     */
    public function HTTPConnection(host:String, port:uint) {
        
        this.host = host;
        this.port = port;

        this.referrerId = Singletons.context.getReferrerId();
        this.authKey = Singletons.context.getAuthKey();
        this.id =  Singletons.context.getUserId();;//Application.teamProfiler.getSocialUserId();
  
        loader = new URLLoader() ;
        loader.dataFormat = URLLoaderDataFormat.VARIABLES;
        loader.addEventListener(Event.COMPLETE, sendComplete);
        loader.addEventListener(IOErrorEvent.IO_ERROR, sendIOError);
        loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler); 
    }

    public function connect(): void {
        log.info("HTTPConnection.connect();");
        var uniTime:uint = getTimer();
        send("ping", {});
    }

    public function close():void {
        loader.removeEventListener(Event.COMPLETE, sendComplete);
        loader.removeEventListener(IOErrorEvent.IO_ERROR, sendIOError);
        loader.removeEventListener(SecurityErrorEvent.SECURITY_ERROR, securityErrorHandler);
    }

    public static function getResponse():Object {
        return result.response;
    }

    protected function sendComplete(event:Event) : void {

        if(Singletons.statistic){
            Singletons.statistic.reset();
        }
 
        log.info("connected to " + host );
        var loader:URLLoader = URLLoader(event.target);

        result = false;
        try{
            result = JSON.decode(loader.data);
        }catch(error:Error){
            log.fatal(loader.data);
        }

        if(!result){
            new MessageBox("Ошибка", "Произошла критическая ошибка в работе приложения. Обратитесь в техническую поддержку", MessageBox.OK_BTN).show();
            dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
            return;
        }

        if(result.command != COMMAND_PING && result.error ){
            var msgBox:MessageBox;
            msgBox = new MessageBox("Сообщение", result.error, MessageBox.OK_BTN); ;
            msgBox.show();
            if(Singletons.loadingMsg){ 
                Singletons.loadingMsg.hide();
            }
            dispatchEvent(new Event(IOErrorEvent.IO_ERROR));
        }else{
            dispatchEvent(new Event(result.command));

            if(Singletons.loadingMsg){

                var loadingMessage:String;
                switch(result.command){
                    case COMMAND_ADD_MONEY:
                        loadingMessage = "Начислнеие произведено";
                        break;
                    case COMMAND_GET_MATCH_RESULT:
                        loadingMessage = "Вычисления получены";
                        break;
                    case COMMAND_GET_EMENY:
                        loadingMessage = "Список команд загружен";
                        break;
                    case COMMAND_BUY_FOOTBALLER:
                        loadingMessage = "Покупка завершена";
                        break;
                    case COMMAND_SAVE_FOOTBALLER:
                        loadingMessage = "Сохранение завершено";
                        break;
                    case COMMAND_SAVE_SPONSORS:
                        loadingMessage = "Сохранение завершено";
                        break;
                    case COMMAND_WELCOME:
                        loadingMessage = "Сохранение завершено";
                        break;
                    case COMMAND_FRIEND_IN_TEAM:
                        loadingMessage = "Операция заверщина";
                        break;
                    case COMMAND_SEND_GIFT:
                        loadingMessage = "Подарок учтен";
                        break;
                    case COMMAND_DROP_ITEM:
                        loadingMessage = "Контракт анулирован";
                        break;
                    default:
                        loadingMessage = "Готово";
                        break;
                }

                if(loadingMessage){
                    Singletons.loadingMsg.delayHide(loadingMessage);
                }
            } 
        }
    }

    protected function sendIOError(event:IOErrorEvent) : void {
        new MessageBox("Ошибка", "Произошла техническая ошибка, приносим свои извинения. Обратитесь в техническую поддержку", MessageBox.OK_BTN).show();
        if(Singletons.loadingMsg){
            Singletons.loadingMsg.hide();
        }

        log.error("IoError: " + event.toString());
        dispatchEvent(event);
    }

    protected function securityErrorHandler(event:SecurityErrorEvent) : void {

        new MessageBox("Ошибка", "Произошла техническая ошибка, приносим свои извинения. Обратитесь в техническую поддержку", MessageBox.OK_BTN).show();
        if(Singletons.loadingMsg){
            Singletons.loadingMsg.hide();
        }

        log.error("SecurityError: " + event.toString());
        dispatchEvent(event);
    }
  
    public function send(commandName:String, params:Object):void {

        trace("Try to send command: " + commandName);

        var variables:URLVariables = new URLVariables();

        if(!Application.VKIsEnabled){
            this.authKey = "db67672ffed2c96e1417bb4ddcf15222";
            this.id = "4778426";            
        }

        if(  Singletons.statistic){
            var statistic:String = JSON.encode(Singletons.statistic.getJSON());
            variables.statistic = statistic;  
        }

        variables.checksum = MD5v2.encrypt(this.authKey + "FUZ" + this.id);
        variables.referrerId = this.referrerId;
        variables.groupId = Singletons.context.getGroupSource();
        variables.authKey = this.authKey;
        variables.id = this.id; 
        variables.params = JSON.encode(params);
        variables.command = commandName;
  
        request = new URLRequest("http://" + Server.MAIN.getHost() + ":" + Server.MAIN.getPort() +"/" + Server.MAIN.getDirectories() +"?accelerator=" + Math.floor(Math.random()*999));
        request.data = variables;

        request.method = URLRequestMethod.POST;

        log.warn("try to send message [" + variables.command + "] to server: " + request);
        loader.dataFormat = URLLoaderDataFormat.TEXT;

        var loadingMessage:String;

        if(COMMAND_PING != commandName){ 
            switch(commandName){
                case COMMAND_ADD_MONEY:
                    loadingMessage = "Производиться зачисление на счет";
                    break;
                case COMMAND_GET_MATCH_RESULT:
                    loadingMessage = "Расчет соревнования";
                    break;
                case COMMAND_GET_EMENY:
                    loadingMessage = "Получение списка участвующих команд";
                    break;
                case COMMAND_BUY_FOOTBALLER:
                    loadingMessage = "Производится покупка";
                    break;
                case COMMAND_SAVE_FOOTBALLER:
                    loadingMessage = "Сохранение информации о команде";
                    break;
                case COMMAND_SAVE_SPONSORS:
                    loadingMessage = "Сохранение информации о спонсорах";
                    break;
                case COMMAND_WELCOME:
                    loadingMessage = "Сохранение информации о команде";
                    break;
                case COMMAND_FRIEND_IN_TEAM:
                    loadingMessage = "Добавление друга в команду";
                    break;
                case COMMAND_SEND_GIFT:
                    loadingMessage = "Отправляем подарок";
                    break;
                case COMMAND_DROP_ITEM:
                    loadingMessage = "Анулирование контракта";
                    break;
                default:
                    loadingMessage = "Загрузка";
                    break;
            }
        }

        if(loadingMessage){
            Singletons.loadingMsg.start(loadingMessage);    
        }

        loader.load(request); 

    }
 
}
}