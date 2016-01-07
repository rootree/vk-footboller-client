package ru.kubline.loader {
import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;
import flash.net.URLLoader;
import flash.net.URLRequest;
import flash.system.LoaderContext;

import ru.kubline.logger.luminicbox.Logger;

/**
 * грузит resconfig.xml и все перечисленные там ресурсы
 */
public class AbstractResourceLoader extends EventDispatcher {

    // create logger instance
    private var log:Logger = new Logger(AbstractResourceLoader);

    /**
     * какое количество ресурсов
     * все еще находиться в режиме ожидания загрузки
     */
    protected var needLoad:int = 0;

    /**
     * общее количество ресурсов для загрузки
     */
    protected var resCount:int = 0;

    /**
     * массив loader'ов для ресурсов, сохраняем ссылки на них здесь
     * чтобы GC их не пожахал до того как произойдет загрузка
     */
    private var resourceLoaders:Array = new Array();

    /**
     * загрузчик XML
     */
    private var xmlLoader:URLLoader;

    /**
     * контекст загрузки ресурсов
     * (удаленный, локальный)
     */
    private var context:LoaderContext;

    /**
     * папка в которой лежит xml
     */
    protected var basePath:String;

    private var path:String;

    public function AbstractResourceLoader(basePath:String, configFile:String, context:LoaderContext) {
        this.basePath = basePath;
        this.context = context;
        this.path = basePath + "/" + configFile;
    }

    /**
     * можно подписаться на событие  Event.COMPLETE,
     * которое будет рассылаться после окончания загрузки
     */
    public function load():void {
        xmlLoader = new URLLoader();
        xmlLoader.addEventListener(Event.COMPLETE, onResConfigLoaded);
        xmlLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
        xmlLoader.load(new URLRequest(path));
    }

    /**
     * вызываеться при успешной загрузке XML
     * @param event экземпляр события
     */
    private function onResConfigLoaded(event:Event):void {
        parseXmlAndLoadResources(new XML(event.target.data));
    }

    protected function parseXmlAndLoadResources(resXml:XML):void {
        //сначало загружаем все ресурсы помечаные тегом resource
        parseAndLoadResources(resXml);
        //далее грузим все библиотеки ресурсов (тег library)
        parseAndLoadLibraries(resXml);
        resCount = needLoad;
    }

    protected function onIOError(e:IOErrorEvent):void {
        log.error("Resconfig load error: " + e.text);
        dispatchEvent(e);
    }

    /**
     * парсит все теги recourse и загружает классы из этих ресурсов
     * @param resXml ссылка на xml node
     */
    protected function parseAndLoadResources(resXml:XML):void {
        for each(var resource:XML in resXml.resource) {
            var resDefinition:Resource = parseResource(resource);
            log.info("Try to load: " + resource.@src.toString() + "?" + resource.@lastupdate.toString());
            loadResource(resDefinition, resource.@src.toString() + "?" + resource.@lastupdate.toString());
        }
    }

    /**
     * загрузка ресурса из swf
     * @param resDefinition ресурс который нужно загрузить
     * @param path полный путь до swf с ресурсом
     */
    protected function loadResource(resDefinition:Resource, path:String):void {
        var resName:String = path.substr(path.lastIndexOf("/") + 1);
        needLoad++;
        // загружаем ресурс указанный в XML

        var loader:ResourceLoader = new ResourceLoader();
        loader.addEventListener(Event.COMPLETE, onLoadResourceComplete);
        loader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);

        var srcPath:String = basePath + "/" + path;
        // log.info("try to load recource: " + srcPath + ", needLoad: " + needLoad);
        loader.loadResource(srcPath, resDefinition, context);
        //сохроняем ссылку на загрузчик
        resourceLoaders.push(loader);
    }

    protected function parseAndLoadLibraries(resXml:XML):void {
        for each(var lib:XML in resXml.library) {
            needLoad++;
            var libPath:String = basePath + "/" + lib.@path + "?" + lib.@lastupdate;

            log.info("try to load library: " + libPath + ", needLoad: " + needLoad);
            var library:Array = [];
            for each(var r:XML in lib..resource) {
                var resDef:Resource = parseResource(r);
                library.push(resDef);
            }
            var libLoader:ResourceLoader = new ResourceLoader();
            libLoader.addEventListener(Event.COMPLETE, onLoadResourceComplete);
            libLoader.addEventListener(IOErrorEvent.IO_ERROR, onIOError);
            libLoader.loadResources(libPath, library, context);

            //сохраняем ссылку на загрузчик
            resourceLoaders.push(libLoader);
        }
    }

    /**
     * вызываеться при успешной загрузки ресурса
     * @param event эксемпляк события
     */
    protected function onLoadResourceComplete(event:Event):void {
        var loader:ResourceLoader = ResourceLoader(event.target);
        for each(var resource:Resource in loader.getResources()) {
            onResourceLoad(resource);
        }
        needLoad --;
        // log.info("recource loaded: " + loader.getPath() + ", needLoad: " + needLoad);
        if (needLoad < 1) {
            onCompleteLoading();
        }
    }

    /**
     * парсит xml node который содержит тег с описанием ресурса и
     * создает инстанс класса Resource для последующего заполнения его данными из XML
     *
     * @param resource ссылка на xml node с описанием ресурса
     * @return созданный класс ресурса
     */
    protected function parseResource(resource:XML):Resource {
        var resDefinition:Resource = new Resource();
        fillResource(resDefinition, resource);
        return resDefinition;
    }

    /**
     * записать ресурс из xml в класс Resource,
     * @param resDefinition ссылка на xml node с описанием ресурса
     * @param resource класс куда необходимо записать
     */
    protected function fillResource(resDefinition:Resource, resource:XML):void {
        resDefinition.setClassName(resource.@className.toString());
        resDefinition.setX(int(resource.@x.toString()));
        resDefinition.setY(int(resource.@y.toString()));
        resDefinition.setWidth(int(resource.@width.toString()));
        resDefinition.setHeight(int(resource.@height.toString()));
    }

    protected function onResourceLoad(resource:Resource):void {
    }

    /**
     * вызывается перед завершением загрузки
     */
    protected function onCompleteLoading():void {
        //освобождаем ресурсы
        xmlLoader = null;
        resourceLoaders = null;
        needLoad = 0;
        resCount = 0;

        //сообщаем всем слушателям о завершении загрузки
        log.info("ClassLoader.dispatchEvent() ");
        dispatchEvent(new Event(Event.COMPLETE));
    }

}
}