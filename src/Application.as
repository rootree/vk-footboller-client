package {
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.display.StageScaleMode;
import flash.events.ErrorEvent;
import flash.events.Event;
import flash.filters.DropShadowFilter;
import flash.system.Security;
import flash.text.TextField;
import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import ru.kubline.controllers.EventController;
import ru.kubline.controllers.Singletons;
import ru.kubline.core.Cookie;
import ru.kubline.core.LimitByCookie;
import ru.kubline.events.ChangeModeEvent;
import ru.kubline.interfaces.MainMenu;
import ru.kubline.interfaces.UserPanel;
import ru.kubline.interfaces.Welcome;
import ru.kubline.interfaces.menu.friends.FriendProfilesStore;
import ru.kubline.interfaces.window.LoadingMessage;
import ru.kubline.interfaces.window.message.NewLevelMessage;
import ru.kubline.interfaces.window.message.WinTourlMessage;
import ru.kubline.interfaces.window.tour.TourEventWindow;
import ru.kubline.interfaces.window.message.TourMessage;
import ru.kubline.loader.tour.TourNotifyType;
import ru.kubline.loader.tour.TourType;
import ru.kubline.model.ApplicationContext;
import ru.kubline.interfaces.lang.Messages;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.model.ApplicationContext;
import ru.kubline.model.FootballEvent;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.TeamProfiler;
import ru.kubline.gui.utils.InterfaceUtils;
import ru.kubline.logger.luminicbox.Logger;
import ru.kubline.net.Server;
import ru.kubline.social.events.LoadCitiesEvent;
import ru.kubline.social.events.LoadCountriesEvent;
import ru.kubline.social.model.SocialCity;
import ru.kubline.social.model.SocialCountry;
import ru.kubline.utils.EndingUtils;
import ru.kubline.utils.MessageUtils;
import ru.kubline.utils.ServerTime;

/**
 * MAIN класс приложения )   !
 * простой, легкий, молодежный
 *
 * User: denis
 * Date: 26.04.2010
 * Time: 20:00:49
 *

 */
[SWF(width="745", height="651", frameRate="30", backgroundColor="#00A600")]
public class Application extends Sprite {


    Security.allowDomain("vkontakte.ru", "*.vkontakte.ru", "vk.com", "*.vk.com", "*.vk-footballer.com", "vk-footballer.com", "109.234.155.18");


    /**
     * create logger instance
     */
    public static var log:Logger = new Logger(Application);


    /**
     * инстанс данного класса (singleton)
     */
    public static var instance:Application;

    public static var VKIsEnabled:Boolean;

    public static var runQAMode:Boolean = false; // TODO


    /*
     * инстанс спрайта для всех объектов меню
     * */
    public static var mainMenu:MainMenu;

    public static var welcome:Welcome;

    /**
     * Контекст приложения
     */
    public var context:ApplicationContext;

    /**
     * для отображения системных отладочных сообщений
     */
    private static var systemMessage:TextField = new TextField();

    /**
     * класс через который можно получить ссылку на любой сингелтон
     */
    private static var singletons:Singletons;

    private static const APPLICATION_WIDTH:uint = 745;

    private static const APPLICATION_HEIGHT:uint = 650;//590;//

    /**
     * Профайл текущего пользователя
     */
    //public static var userProfile:UserProfile;
    public static var teamProfiler:TeamProfiler = new TeamProfiler();

    public static var isFristLauch:Boolean = false;

    public function Application() {
        Application.VKIsEnabled = true;  //TODO переставить когда интернет появиться
        log.debug("========Create new Instance of Application========");
        instance = this;
        this.context = new ApplicationContext();
        showSystemMessage("...");
        this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
        Server.MAIN = new Server("footboll.loc", 80, "");
        Server.STATIC = new Server("static.loc", 80, "");
        Server.STATIC_SECOND = new Server("static_second.loc", 80, "");
    }

    /**
     * инициализация приложения из прелодера
     * @param wrapper flash контейнер от контакта
     * @param baseUrl базовый URL для загрузки ресурсов
     * @param referrerId id анкеты игрока который привел данного в игру
     */
    public function initFromPreloader(wrapper:Object, baseUrl:String, referrerId:uint):void {

        Application.VKIsEnabled = true;

        if(Application.runQAMode == false){
            Server.MAIN = new Server("vk-footballer.com", 80, "index.php");
            Server.STATIC = new Server("vk-footballer.com", 80, "Static/content/");
            Server.STATIC_SECOND = new Server("109.234.155.18:8080", 8080, "content/");
        }else{
            Server.MAIN = new Server("188.93.17.159", 8080, "server/");
            Server.STATIC = new Server("188.93.17.159", 80, "content/");
            Server.STATIC_SECOND = new Server("188.93.17.159", 8080, "content/");
        }


        log.error("init from peloading: url: " + baseUrl + ",  referrerId: " + referrerId);
        context.setBaseUrl(baseUrl);
        context.setReferrerId(referrerId);
        context.setWrapper(wrapper);

        trace("initFromPreloader");
    }

    /**
     * событие возникает когда данный класс
     * будет добавлен на сцену для отрисовки
     * @param event инстанс события
     */
    private function onAddedToStage(event:Event):void {


        log.info("Application.onAddedToStage();");
        context.setFlashVars(stage.loaderInfo.parameters);
        stage.scaleMode = StageScaleMode.NO_SCALE;

        // инициализируем сингелтоны приложения
        singletons = new Singletons(context);
        singletons.addEventListener(ErrorEvent.ERROR, onError);
        singletons.addEventListener(Event.COMPLETE, onAppInit);
        singletons.init();
    }

    /**
     * вызываеться на последнем этапе загрузки приложения
     * все проверки удволетворили и можно грузить сцену
     */
    private function onAppInit(event:Event):void {

        var msgBox:MessageBox;
        switch(TeamProfiler.getIsInstalled()){
            case 1:


                //удаляем сообщение о загрузке приложения
                this.removeChild(systemMessage);
                teamProfiler = Singletons.loginController.getUserProfile();


                //создаем главное меню игры
                mainMenu = new MainMenu();

                addChild(mainMenu.getContainer());

                mainMenu.getContainer().y = 60;

                var prizeStudyPoint:uint = Application.teamProfiler.getStudyPointsViaPrize();
                if(prizeStudyPoint){
                    msgBox = new MessageBox("Сообщение",
                            "Благодаря вашим друзьям, вы получили " + prizeStudyPoint +
                            EndingUtils.chooseEnding(prizeStudyPoint, " очков", " очко", " очка") + " обучения\n\n" +
                            "Не забывайте своих друзей, вы тоже можете дарить подарки", MessageBox.OK_BTN);
                    msgBox.show();
                }

                if(Singletons.loginController.groupBonusNeeded){
                    var bonusReal:uint = 10;
                    msgBox = new MessageBox("Сообщение",
                            "За вступление в официальную группу игры по получаете 10 реалов",
                            MessageBox.OK_BTN, function():void{
                        Application.teamProfiler.setRealMoney(Application.teamProfiler.getRealMoney() + bonusReal);
                        Application.mainMenu.userPanel.update();
                    });
                    msgBox.show();
                }

                if(Application.teamProfiler.getIsNeedDailyBonus() && Application.teamProfiler.getTotalStadiumBonus()){
                    var bonus:uint = Application.teamProfiler.getTotalStadiumBonus();
                    msgBox = new MessageBox("Сообщение",
                            "Сегодня стадион принес вам прибыль в размере " + bonus + " $",
                            MessageBox.OK_BTN, function():void{
                        Application.teamProfiler.setMoney(Application.teamProfiler.getMoney() + bonus);
                        Application.mainMenu.userPanel.update();
                    });
                    msgBox.show();
                }

                if(Application.teamProfiler.getTourNotify() == TourNotifyType.TOUR_NOTIFY_START || Application.teamProfiler.getTourNotify() == TourNotifyType.TOUR_NOTIFY_NEW){
                    
                    Application.mainMenu.cupInfo.show();

                    if (Application.teamProfiler.isDiscount()) {

                        var bonusTime:Number = Application.teamProfiler.getTourBonusTime();
                        var deltaTime:Number = ServerTime.getDeltaTime()   ;
                        var currentTime:Number = ServerTime.getCurrentTime();
                        var goldNumber:uint = bonusTime + deltaTime - currentTime;

                        msgBox = new TourMessage("Внимание",
                                "За выиграш в 3-ем турнире вы получаете скидку на один день на всех футболистов и тренеров.\n\nДо конца скидки осталось " + MessageUtils.converTimeToShortString(goldNumber),
                                MessageBox.OK_BTN);
                        msgBox.show();

                    }

                }
                break;
            case 0:

                //удаляем сообщение о загрузке приложения
                this.removeChild(systemMessage);
                teamProfiler = Singletons.loginController.getUserProfile();

                //log.debug("Name length" + Application.teamProfiler.getSocialData().getFirstName().length);

                welcome = new Welcome();
                welcome.show();
                break;
            case -1:
                msgBox = new MessageBox("Сообщение", "Производиться обновление игры. Приносим извинения за неудобства. Зайдите позже ... ", MessageBox.OK_BTN); ;
                msgBox.show();
                break;
        }

        // рассылаем сообщение всем слушателям об успешной инициализации приложения

 

        this.dispatchEvent(new Event(Event.INIT, true));
    }

    private function onError(event:Event): void {
        // говорим, что приложение инициализировалось хоть и с ошибкой
        // чтоб убрать прилодер и показать сообщение об ошибке
        this.dispatchEvent(new Event(Event.INIT, true));
    }

    /**
     * метод отображает системное сообщение
     * @param msg сообщение которое необходимо отобразить
     */
    public static function showSystemMessage(msg:String):void {
        var textFormat:TextFormat = new TextFormat("_sans", 17, 0xFFCBFF);
        systemMessage.autoSize = TextFieldAutoSize.LEFT;
        systemMessage.selectable = false;
        systemMessage.mouseEnabled = false;
        systemMessage.defaultTextFormat = textFormat;
        systemMessage.filters = [new DropShadowFilter(1, 45, 0, 1, 2, 2, 2, 2)];
        systemMessage.alpha = 0.7;
        systemMessage.multiline = true;
        systemMessage.htmlText = "<font size='32'><b>" + msg + "</b></font>";
        instance.addChild(systemMessage);
        InterfaceUtils.alignByScreenCenter(systemMessage);
    }

    public static function get stageWidth():int {
        return APPLICATION_WIDTH;
    }

    public static function get stageHeight():int {
        return APPLICATION_HEIGHT;

    }

    public static function isFirstLanch():Boolean {
        return Application.isFristLauch;
    }
}
}