package ru.kubline.loader {

import flash.display.MovieClip;
import flash.events.Event;
import flash.media.Sound;
import flash.system.LoaderContext;

import ru.kubline.loader.progress.LoadingProgress;
import ru.kubline.logger.luminicbox.Logger;

/**
 * загрузчик классав из ресурсов приложения
 */
public class ClassLoader extends AbstractResourceLoader {

    // create logger instance
    private var log:Logger = new Logger(ClassLoader);

    public static var instance:ClassLoader;

    /**
     * Список всех загруженных классов приложения
     */
    private var classes:Object = new Object();

    /**
     * директория начиная от корня в которой лежат ресурсы
     */
    public static var dataPath:String = "data/";

    /**
     * @param baseURL базовый URL указывающий на путь где лежит приложение
     */
    public function ClassLoader(baseURL:String, context:LoaderContext) {
        super(baseURL + dataPath, "resconfig.xml?" + Math.round(Math.random() * 10000), context);
        instance = this;
    }

    /**
     * Вернет новый инстанс класса по имени
     */
    public static function getNewSoundInstance(name:String):Sound {
        return Resource(ClassLoader.instance.classes[name]).getNewSoundInstance();
    }

    /**
     * Вернет класс по имени
     */
    public static function getClass(name:String):Class {
        return Resource(ClassLoader.instance.classes[name]).getClass();
    }

    /**
     * Вернет новый инстанс класса по имени
     */
    public static function getNewInstance(name:String):MovieClip {
        return Resource(ClassLoader.instance.classes[name]).getNewInstance();
    }

    /**
     * Вернет описание ресурса по имени
     */
    public static function getResource(name:String):Resource {
        return Resource(ClassLoader.instance.classes[name]);
    }

    /**
     * отправляет информацию о ходе загрузки приложения
     * @param needLoad количество ресурсов которое еще нужно загрузить
     */
    private function progress(needLoad:int): void {
        // считаем, что загрузка ресурсов это 50% от загрузки всего приложения и
        // что 20% уже загрузилось до начала загрузки ресурсов

        //говорим сколько процентов приложения уже загружено
        LoadingProgress.publish(Number((resCount - needLoad) / resCount) * 50 + 20);
    }


    override protected function onResourceLoad(resource:Resource):void {
        classes[resource.getClassName()] = resource;
    }

    override protected function onLoadResourceComplete(event:Event):void {
        //говорим сколько процентов приложения уже загружено
        progress(needLoad);
        super.onLoadResourceComplete(event);
    }
}
}