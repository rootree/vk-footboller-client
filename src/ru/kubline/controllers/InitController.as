package ru.kubline.controllers {

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IOErrorEvent;

import ru.kubline.interfaces.lang.Messages; 
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.ClassLoader;
import ru.kubline.logger.luminicbox.Logger; 

/**
 * Контроллер который отвечает за инициализацию приложения
 * (подгрузку и прочее)
 *
 * @author denis
 */
public class InitController extends EventDispatcher {

    /**
     * create logger instance
     */
    private var log:Logger = new Logger(InitController);

    /**
     * класс лоадер
     */
    private var classLoader:ClassLoader;

    private var buildingTypeLoader:ItemTypeStore;
  
    /**
     * Класс локализации
     */
    private var messagesStore:Messages;

    public function InitController() {
        log.info("InitController;");
    }

     /**
     * метод для запуска инициализации приложения
     */
    public function init(): void {
        log.info("InitController.init();");
        messagesStore = new Messages(Messages.LANG_RU, Singletons.context.getBaseUrl());
        messagesStore.addEventListener(Event.COMPLETE, onDictionaryLoaded);
        messagesStore.load();
    }
 
    /**
     * Событие возникает после успешной загрузки локализации
     * @param event
     */
    private function onDictionaryLoaded(event:Event): void {
        log.info("InitController.onDictionaryLoaded();");
        //загружаем все ресурсы приложения
        classLoader = new ClassLoader(Singletons.context.getBaseUrl(), Singletons.context.getLoaderContext());
        classLoader.addEventListener(Event.COMPLETE, onClassesLoaded);
        classLoader.load();
    }

    /**
     * Событие возникает после успешной загрузки всех классов из ресурсов
     * @param event инстанс события
     */
    private function onClassesLoaded(event:Event):void {
        log.debug("onClassesLoaded");
        buildingTypeLoader = new ItemTypeStore(Singletons.context.getBaseUrl());
        buildingTypeLoader.addEventListener(Event.COMPLETE, onBuildingsLoaded);
        buildingTypeLoader.load();
    }
 
    public function ioErrorListener(e:IOErrorEvent):void {
        log.info("Load Error: " + e.text);
        dispatchEvent(e);
    }

    /**
     * Событие возникает после успешной загрузки хмл со списком всех изо-элементов на сцене.
     * @param event инстанс события
     */
    private function onBuildingsLoaded(event:Event):void {
        log.debug("onBuildingsLoaded");
        //рассылаем событие о том, что иничиализация прошла успешно
        this.dispatchEvent(new Event(Event.COMPLETE, true));
    }
}
}