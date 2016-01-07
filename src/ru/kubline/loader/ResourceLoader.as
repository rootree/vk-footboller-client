package ru.kubline.loader {
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.net.URLRequest;
import flash.system.ApplicationDomain;
import flash.system.LoaderContext;

import ru.kubline.logger.luminicbox.Logger;

/**
 * Класс для загрузки ресурсов из swf
 */
public class ResourceLoader extends EventDispatcher {

    // create logger instance
    private var log:Logger = new Logger(ResourceLoader);

    /**
     *  ссылка на класс для загрузки swf
     */
    private var loader:Loader;

    /**
     * ресурсы которые нужно загрузить из swf
     */
    private var resDefinitions:Array;

    /**
     * полный путь до файла
     */
    private var path:String;

    /**
     * загрузить один ресурс из swf
     * @param path полный путь до файла
     * @param resDefinition ресурс который нужно загрузить
     * @param context контекс в котором будет выполняться загрузка swf
     */
    public function loadResource(path:String, resDefinition:Resource, context:LoaderContext):void {
        this.resDefinitions = [resDefinition];
        load(path, context);
    }

    /**
     * загрузить один ресурс из swf
     * @param path полный путь до файла
     * @param resDefinitions ресурсы которые нужно загрузить из swf
     * @param context контекс в котором будет выполняться загрузка swf
     */
    public function loadResources(path:String, resDefinitions:Array, context:LoaderContext):void {
        this.resDefinitions = resDefinitions;
        load(path, context);
    }

    private function load(path:String, context:LoaderContext):void {
        this.path = path;
        loader = new Loader();
        loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
        loader.contentLoaderInfo.addEventListener(IOErrorEvent.IO_ERROR, ioErrorListener);
        loader.load(new URLRequest(path), context);
    }

    private function ioErrorListener(event:IOErrorEvent):void {
        dispatchEvent(event);
    }

    private function onComplete(event:Event):void {
        var loaderInfo:LoaderInfo = LoaderInfo(event.target);
        var appDomain:ApplicationDomain = loaderInfo.applicationDomain;
        log.debug("loaded " + loaderInfo.content);
        for each(var r:Resource in resDefinitions) {
            if(appDomain.hasDefinition(r.getClassName())) {
                var moduleClass:Class = appDomain.getDefinition(r.getClassName()) as Class;
                r.setClass(moduleClass);
            } else {
                dispatchEvent(new IOErrorEvent(IOErrorEvent.IO_ERROR, false, false, "Class " + r.getClassName() + " not found in " + path));
                return;
            }
        }
        dispatchEvent(new Event(Event.COMPLETE));
    }

    /**
     * @return полный путь по которому лежит swf с ресурсами
     */
    public function getPath():String {
        return path;
    }

    /**
     * @return массив загруженых ресурсов
     */
    public function getResources():Array {
        return resDefinitions;
    }
}
}