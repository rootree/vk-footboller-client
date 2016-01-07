package ru.kubline.controllers {
import flash.events.ErrorEvent;
import flash.events.Event;

import flash.events.EventDispatcher; 
import ru.kubline.comon.ItemsClasses;
import ru.kubline.core.LimitByCookie;
import ru.kubline.interfaces.window.LoadingMessage;
import ru.kubline.loader.Gallery;
import ru.kubline.model.ApplicationContext;
import ru.kubline.model.TeamProfiler;
import ru.kubline.net.HTTPConnection; 
import ru.kubline.net.Server; 
import ru.kubline.loader.progress.LoadingProgress;
import ru.kubline.social.controller.VkontakteController;
import ru.kubline.social.manager.VkontakteRequestManager;
import ru.kubline.social.profile.SocialUserDataStore;
 
/**
 * класс через который можно получить ссылку на любой сингелтон
 *
 * @author denis
 */
public class Singletons extends EventDispatcher {


    /**
     * Озвучка
     */
    public static var sound:SoundController;
    /**
     * Контекст приложения
     */
    public static var statistic:Statistics;

    public static var context:ApplicationContext;

    public static var loadingMsg:LoadingMessage;

    public static var gallery:Gallery;

    /**
     * контроллер для работы с социалкой
     */
    public static var vkontakteController:VkontakteController;

    /**
     * хранилище всех профайлов загруженных из соц. сети
     */
    public static var socialUserDataStore:SocialUserDataStore = new SocialUserDataStore();

    /**
     * контроллер который отвечает за подгрузку всевозможных ресурсов приложения
     */
    public static var initController:InitController;

     /**
     * класс для сокетного соединения с сервером
     */
    public static var connection:HTTPConnection;

    public static var buildingsClases:ItemsClasses = new ItemsClasses();

    /**
     * контроллер который отвечает работу
     */
    public static var friendTeamController:FriendTeamController;

    public static var energyTimerController:EnergyTimerController;

    public static var limitForPrize:LimitByCookie;

    public static var limitForFight:LimitByCookie;

    /**
     * контроллер который отвечает за логин на сервер
     */
    public static var loginController:LoginController;

    public function Singletons(context:ApplicationContext) {
        Singletons.context = context;
    }

    /**
     * метод для запуска инициализации сингелтонов
     */
    public function init():void {
        //говорим сколько процентов приложения уже загружено
        LoadingProgress.publish(10); 
        connection = new HTTPConnection(Server.MAIN.getHost(), Server.MAIN.getPort());
        connection.addEventListener(HTTPConnection.COMMAND_PING, onConnected);
        connection.send(HTTPConnection.COMMAND_PING, {});
    }

    private function onConnected(event:Event): void {
         
        connection.removeEventListener(HTTPConnection.COMMAND_PING, onConnected);

        var response:Object = HTTPConnection.getResponse();
        if(response){
            TeamProfiler.setIsInstalled(response.isInstalled);

            //говорим сколько процентов приложения уже загружено
            LoadingProgress.publish(15); 
            //выполняем инициализацию приложения
            initController = new InitController();
            initController.addEventListener(Event.COMPLETE, onInitComplete);
            initController.init();
        }else{
            this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, true));    
        };
    }

    /**
     * вызывается после успешной инициализации приложения
     */
    private function onInitComplete(event:Event):void {
        LoadingProgress.publish(80);

        if(TeamProfiler.getIsInstalled() == -1){                       
            this.dispatchEvent(new Event(Event.COMPLETE, true));    
        }

        //cоздаем инстанс класса для работы с соц. сетью
        vkontakteController = new VkontakteController(new VkontakteRequestManager(context.getFlashVars()));

        loadingMsg = new LoadingMessage();

        //создаем инстанс login контроллера
        loginController = new LoginController(vkontakteController);

        statistic = new Statistics();

                // Упровление звуками
        sound = new SoundController();

        friendTeamController = new FriendTeamController();

        limitForPrize = new LimitByCookie("dayliPrizeLimit", "dayliPrizeTime", 1);
        limitForPrize.init();

        limitForFight = new LimitByCookie("dayliFriendFightLimit", "dayliFriendFightTime", 5);
        limitForFight.init();

        // логинимся на сервак
        loginController.addEventListener(Event.COMPLETE, onLoginComplete);
        loginController.addEventListener(ErrorEvent.ERROR, onError);
        loginController.login();
    }

    /**
     * вызывается после успешного логина на игровом сервере
     */
    private function onLoginComplete(event:Event):void {
        LoadingProgress.publish(99);

        // рассылаем сообщение всем слушателям об успешной инициализации приложения
        this.dispatchEvent(new Event(Event.COMPLETE, true));
    }

    /**
     * если произошла ошибка при загрузке
     */
    private function onError(event:Event): void {
        this.dispatchEvent(new ErrorEvent(ErrorEvent.ERROR, true));
    }
}
}
