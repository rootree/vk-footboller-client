package ru.kubline.interfaces.lang {

import flash.errors.IllegalOperationError;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;

import ru.kubline.logger.luminicbox.Logger;

/**
 * Класс для локализации приложения
 * @author Ivan
 */
public class Messages extends EventDispatcher {

    /**
     * метод для выбора правильного окончания для числа
     * @param number - число
     * @param ending0 - долларов, проверочное число 10
     * @param ending1 - доллар, проверочное число 21
     * @param ending2 - доллара, проверочное число 32
     * @return
     */
    public static function chooseEnding(number:uint, ending0:String, ending1:String, ending2:String):String {
        var num100:uint = number % 100;
        var num10:uint = number % 10;
        if (num100 >= 5 && num100 <= 20) {
            return ending0;
        } else if (num10 == 0) {
            return ending0;
        } else if (num10 == 1) {
            return ending1;
        } else if (num10 >= 2 && num10 <= 4) {
            return ending2;
        } else if (num10 >= 5 && num10 <= 9) {
            return ending0;
        } else {
            return ending2;
        }
    }

    private static var instance:Messages;

    public static const LANG_RU:String = "ru";

    public static const LANG_EN:String = "en";

    // create logger instance
    private var log:Logger = new Logger(Messages);

    /**
     * Текущий язык
     */
    private var language:String;

    /**
     * Содержит языковые переменные
     */
    private var messages:Object;

    private var baseUrl:String;

    /**
     * Директория где расположены файлы локализации
     */
    private var dataPath:String = "data/languages/";

    /**
     * В конструкторе определяем какой язык грузить, и источник загрузки
     * @param lang Устанавлением язык
     * @param baseUrl
     */
    public function Messages(lang:String, baseUrl:String) {
        if(instance != null) {
            throw new IllegalOperationError();
        } else {
            this.language =lang;
            this.baseUrl = baseUrl;
            Messages.instance = this;
        }
    }

    public static function getInstanse():Messages {
        return Messages.instance;
    }

     /**
     * Подписаться на событие  Event.COMPLETE,
     * которое будет рассылаться после окончания загрузки
     */
    public function load():void {
        var dictLoader:URLLoader = new URLLoader();
        dictLoader.addEventListener(Event.COMPLETE, onDictionatyLoaded);
        dictLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
        var dictionarySource:String = this.baseUrl + dataPath + language + "_messages.xml"; 
        dictLoader.load(new URLRequest(dictionarySource));
    }

    /**
     * Получение перевод по ключу, если перевод не найден, возращает ключ
     * @param key
     * @return
     */
    public static function getMessage(key:String):String {
        if(instance.messages[key]) {
            return instance.messages[key];
        } else {
            throw new IllegalOperationError("Message not found by key " + key);
        }
    }

    /**
     * Вызываеться при успешной загрузке XML словаря
     * @param event экземпляр события
     */
    private function onDictionatyLoaded(event:Event):void {
        var messageXML:XML = new XML(event.target.data);                                                      
        messages = new Object();
        for each(var mess:XML in messageXML..message) {
            messages[mess.@name.toString()] = mess.@value.toString();
        }
        onCompleteLoading();
    }

    /**
     * вызывается перед завершением загрузки
     */
    protected function onCompleteLoading():void {
        //сообщаем всем слушателям о завершении загрузки
        log.info("Messages.dispatchEvent() ");
        dispatchEvent(new Event(Event.COMPLETE));
    }

    private function onIOError(e:IOErrorEvent):void {
        log.error("Messages not load causeof error: " + e.text);
    }


    public static function sprintf(text:String, param0:Object = null, param1:Object = null):String {
        if (param0) {
            text = text.replace("{0}", param0);
        }

        if (param1) {
            text = text.replace("{1}", param1);
        }

        return text;
    }
}
}