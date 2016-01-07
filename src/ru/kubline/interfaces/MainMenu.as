package ru.kubline.interfaces {

import com.greensock.TweenMax;

import com.greensock.easing.Quint;
import com.greensock.easing.Sine;

import flash.display.MovieClip;
import flash.display.SimpleButton;

import flash.events.MouseEvent;
import flash.events.TimerEvent;
import flash.text.StaticText;
import flash.text.TextField;

import flash.utils.Timer;

import ru.kubline.comon.Classes;
import ru.kubline.controllers.EnergyTimerController;
import ru.kubline.controllers.ShopController;
import ru.kubline.controllers.Singletons;
import ru.kubline.controllers.Statistics;
import ru.kubline.gui.controls.button.UIButton;
import ru.kubline.interfaces.lang.Messages;
import ru.kubline.interfaces.menu.friends.mainmenu.FriendsList;
import ru.kubline.interfaces.menu.news.NewsMenu;
import ru.kubline.interfaces.menu.rating.RatingMenu;
import ru.kubline.interfaces.menu.sponsors.SponsorMenu;
import ru.kubline.interfaces.menu.friends.FriendsListItem;
import ru.kubline.gui.controls.UIComponent;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.interfaces.stadium.StadiumWindow;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.interfaces.window.tour.TourEventWindow;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.model.Footballer;
import ru.kubline.model.TeamProfiler;
import ru.kubline.utils.EndingUtils;
import ru.kubline.utils.MessageUtils;
import ru.kubline.utils.ServerTime;

/**
 * Главное меню приложения
 */
public class MainMenu extends UIComponent{

    /**
     * кнопка для принятия изменений сцены
     */
    private var userTeamBtn:UISimpleButton;
    private var buyTeamBtn:UISimpleButton;
    private var sponsorBtn:UISimpleButton;
    private var matchBtn:UISimpleButton;
    private var ratingBtn:UISimpleButton;
    private var newsBtn:UISimpleButton;
    private var stadiumBtn:UISimpleButton;

    public var championnats:Championnats;
    public var sponsorsPanel:SponsorMenu;
    public var userTeam:UserTeam;
    public var shop:ShopController;
    public var rating:RatingMenu;
    public var news:NewsMenu;
    public var stadium:StadiumWindow;
    public var cupInfo:TourEventWindow;

    /**
     * Панель пользователя
     */
    public var userPanel:UserPanel;

    public var helper:TextField;

    public var friendsList:FriendsList;

    public var currentHightLighted:Object;

    /**
     * для того, чтобы звук контролировать
     */
    private var volumeBtn:UISimpleButton;

    private var cupBtn:UISimpleButton;

    /**
     * Звук отключён
     */
    private var volueBtnDisabled:UISimpleButton;

    /**
     * ссылка на класс для работы со списком друзей
     * который умеет подгружать аватарки и перелистывать друзей
     */
    private var friendList:FriendsListItem;
 

    private var goldNumber:Number;
    /**
     * таймер для золотой печеньки
     */
    private var goldTimer:Timer;


    /**
     * Установить золотую печеньку
     * @param goldCookie
     */
    public function setGoldCookie():void {
        goldTimer.stop(); 
        if (Application.teamProfiler.isNewTour() && Application.teamProfiler.getTourBonus() && Application.teamProfiler.getTourBonusTime()) {

            var bonusTime:Number = Application.teamProfiler.getTourBonusTime();
            var deltaTime:Number = ServerTime.getDeltaTime()   ;
            var currentTime:Number = ServerTime.getCurrentTime();
            goldNumber = bonusTime + deltaTime - currentTime;
            if (goldNumber <= 0) {
                return;
            }
            updateHelper(getDiscountString(goldNumber));
            goldTimer.start();
        } else {
           updateHelper("");
        }
    }

    function onGoldTimer(e:TimerEvent):void {
        if (goldNumber > 0) {
            goldNumber--;
            updateHelper(getDiscountString(goldNumber));
        } else {
            updateHelper("");
            goldTimer.stop();
        }
    }

    function getDiscountString(goldNumber:uint):String {
        return 'Скидки до ' + MessageUtils.converTimeToShortString(goldNumber);
        return 'Скидка ' + Application.teamProfiler.getTourBonus().toString() + "% пропадет через " + MessageUtils.converTimeToShortString(goldNumber);
    }
    
    public function MainMenu() {

        
        super(ClassLoader.getNewInstance(Classes.MAIN_MENU));

        helper = TextField(getChildByName("helper"));
        goldTimer = new Timer(1000);
        goldTimer.addEventListener(TimerEvent.TIMER, onGoldTimer);

        setGoldCookie();
        
        championnats = new Championnats();
        userTeam = new UserTeam();
        shop = new ShopController();
        sponsorsPanel = new SponsorMenu();
        rating = new RatingMenu();
        news = new NewsMenu();
        stadium = new StadiumWindow();
        cupInfo = new TourEventWindow();


        userTeamBtn = new UISimpleButton(SimpleButton(getChildByName("userTeamBtn")));
        userTeamBtn.getContainer().addEventListener(MouseEvent.CLICK, onClickUserTeamBtn);
        userTeamBtn.getContainer().addEventListener(MouseEvent.MOUSE_OVER, onShowUserTeamHelper);
        userTeamBtn.getContainer().addEventListener(MouseEvent.MOUSE_OUT, onResetHelper);
        userTeamBtn.setQtip("Управление составом вашей команды");

        buyTeamBtn = new UISimpleButton(SimpleButton(getChildByName("buyTeamBtn")));
        buyTeamBtn.getContainer().addEventListener(MouseEvent.CLICK, onClickBuyTeamBtn);
        buyTeamBtn.getContainer().addEventListener(MouseEvent.MOUSE_OVER, onBuyTeamHelper);
        buyTeamBtn.getContainer().addEventListener(MouseEvent.MOUSE_OUT, onResetHelper);
        buyTeamBtn.setQtip("Контракты с новыми футболистами и  тренерами");

        sponsorBtn = new UISimpleButton(SimpleButton(getChildByName("sponsorBtn")));
        sponsorBtn.getContainer().addEventListener(MouseEvent.CLICK, onClickSponsorBtn);
        sponsorBtn.getContainer().addEventListener(MouseEvent.MOUSE_OVER, onSponsorHelper);
        sponsorBtn.getContainer().addEventListener(MouseEvent.MOUSE_OUT, onResetHelper);
        sponsorBtn.setQtip("Спонсоры, заинтересовавшиеся вашей командой");

        matchBtn = new UISimpleButton(SimpleButton(getChildByName("matchBtn")));
        matchBtn.getContainer().addEventListener(MouseEvent.CLICK, onClickMatchBtn);
        matchBtn.getContainer().addEventListener(MouseEvent.MOUSE_OVER, onMatchHelper);
        matchBtn.getContainer().addEventListener(MouseEvent.MOUSE_OUT, onResetHelper);
        matchBtn.setQtip("Соревнования!!!");

        ratingBtn = new UISimpleButton(SimpleButton(getChildByName("ratingBtn")));
        ratingBtn.getContainer().addEventListener(MouseEvent.CLICK, onClickRatingBtn);
        ratingBtn.setQtip("Рейтинг фанатов");

        newsBtn = new UISimpleButton(SimpleButton(getChildByName("newsBtn")));
        newsBtn.getContainer().addEventListener(MouseEvent.CLICK, onClickNewsBtn);
        newsBtn.setQtip("Последние новости");

        stadiumBtn = new UISimpleButton(SimpleButton(getChildByName("stadiumBtn")));
        stadiumBtn.getContainer().addEventListener(MouseEvent.CLICK, onClickStadiumBtn);
        stadiumBtn.setQtip("Мой стадион");

        cupBtn = new UISimpleButton(SimpleButton(getChildByName("cupBtn")));
        cupBtn.getContainer().addEventListener(MouseEvent.CLICK, onClickCupBtn);
        cupBtn.setQtip("Информация по Турниру III");

        friendsList = new FriendsList(MovieClip(getContainer().getChildByName("friendsList")));

        // Кнопка звукового сопровождения
        volumeBtn = new UISimpleButton(SimpleButton(getChildByName("volumeBtn")));
        volumeBtn.getContainer().addEventListener(MouseEvent.CLICK, onClickVolumeBtn);
        volumeBtn.setQtip("Включить звуковое сопровождение");
        volumeBtn.getContainer().visible = Singletons.sound.isTurtOn();

        volueBtnDisabled = new UISimpleButton(SimpleButton(getChildByName("volueBtnDisabled")));
        volueBtnDisabled.getContainer().addEventListener(MouseEvent.CLICK, onClickVolumeBtn);
        volueBtnDisabled.setQtip("Выключить звуковое сопровождение");
        volueBtnDisabled.getContainer().visible = !Singletons.sound.isTurtOn();

        var userPanelMovie:MovieClip = MovieClip(getChildByName("userPanel"));
        userPanel = new UserPanel(userPanelMovie);

        if(Application.isFirstLanch()){
            newsBtn.setVisible(false);
            ratingBtn.setVisible(false);
        }else{

        }
        Singletons.energyTimerController = new EnergyTimerController();
        Singletons.energyTimerController.start();
        userPanel.update();


        updateHelper("Добро пожаловать!");
        unHightLight();

        tweenerOff(userTeamBtn.getContainer());
        tweenerOff(buyTeamBtn.getContainer());
        tweenerOff(sponsorBtn.getContainer());
        tweenerOff(matchBtn.getContainer());

        var glowFilter:Object = {color:0xffffff, alpha:1, blurX:150, blurY:70};
        var glowFilterOut:Object = {color:0xffffff, alpha:0, blurX:150, blurY:150};
        var delay:Number = 0.55;

        forwardButton(userTeamBtn.getContainer());
        TweenMax.to(userTeamBtn.getContainer(), delay, { glowFilter : glowFilter ,
            onComplete : function():void{
                forwardButton(buyTeamBtn.getContainer());
                TweenMax.to(userTeamBtn.getContainer(), delay, { glowFilter : glowFilterOut });
                TweenMax.to(buyTeamBtn.getContainer(), delay, { glowFilter : glowFilter ,
                    onComplete   : function():void{
                        forwardButton(sponsorBtn.getContainer());
                        TweenMax.to(buyTeamBtn.getContainer(), delay, { glowFilter : glowFilterOut });
                        TweenMax.to(sponsorBtn.getContainer(), delay, { glowFilter : glowFilter ,
                            onComplete   : function():void{
                                forwardButton(matchBtn.getContainer());
                                TweenMax.to(sponsorBtn.getContainer(), delay, { glowFilter : glowFilterOut });
                                TweenMax.to(matchBtn.getContainer(), delay, { glowFilter : glowFilter ,
                                    onComplete   : function():void{
                                        TweenMax.to(matchBtn.getContainer(), delay, { glowFilter : glowFilterOut });
                                        tweenerOff(userTeamBtn.getContainer());
                                        tweenerOff(buyTeamBtn.getContainer());
                                        tweenerOff(sponsorBtn.getContainer());
                                        tweenerOff(matchBtn.getContainer());

                                    }
                                });
                            }
                        });
                    }
                });
            }
        });

    }

    // клик на кнопке звука
    private function onClickVolumeBtn(event:MouseEvent):void {
        Singletons.sound.swichOnOff();
        volumeBtn.getContainer().visible = Singletons.sound.isTurtOn();
        volueBtnDisabled.getContainer().visible = !Singletons.sound.isTurtOn();
    }

    private function updateHelper(message:String):void {
        helper.text = message;
    }

    private function forwardButton(bnt:Object):void {
        getContainer().setChildIndex(SimpleButton(bnt), getContainer().numChildren - 2);
    }

    private function higthLight(bnt:Object):void {
        getContainer().setChildIndex(SimpleButton(bnt), getContainer().numChildren - 1);
        bnt.alpha = 0.25;
        TweenMax.to(bnt, 0.75, {
            alpha:1,
            onStartListener  : function():void{
                TweenMax.to(bnt, 0.75, {glowFilter:{color:0xffffff, alpha:1, blurX:150, blurY:70}});
            }
        }) ;
        currentHightLighted = bnt;
    }

    private function unHightLight():void {
        tweenerOff(userTeamBtn.getContainer());
        tweenerOff(buyTeamBtn.getContainer());
        tweenerOff(sponsorBtn.getContainer());
        tweenerOff(matchBtn.getContainer());
    }

    private function tweenerOff(bnt:Object):void {
        getContainer().setChildIndex(SimpleButton(bnt), 1);
        SimpleButton(bnt).filters = [];
        TweenMax.killTweensOf(bnt);
    }

    private function onResetHelper(event:MouseEvent):void {
        updateHelper("Добро пожаловать!");
        unHightLight();
    }

    private function onShowUserTeamHelper(event:MouseEvent):void {
        updateHelper("Моя команда");
        higthLight(event.target);
    }

    private function onBuyTeamHelper(event:MouseEvent):void {
        updateHelper("Мой магазин");
        higthLight(event.target);
    }

    private function onSponsorHelper(event:MouseEvent):void {
        updateHelper("Мои спонсоры");
        higthLight(event.target);
    }

    private function onMatchHelper(event:MouseEvent):void {
        updateHelper("Мои чемпионаты");
        higthLight(event.target);
    }

    private function onClickUserTeamBtn(event:MouseEvent):void {
        Singletons.statistic.increaseMainMenu(Statistics.MAIN_MENU_USER_TEAM);
        userTeam.show();
    }

    private function onClickBuyTeamBtn(event:MouseEvent):void {
        Singletons.statistic.increaseMainMenu(Statistics.MAIN_MENU_SHOP);
        shop.showShopMenu(ItemTypeStore.TYPE_FORWARD);

    }

    private function onClickSponsorBtn(event:MouseEvent):void {
        Singletons.statistic.increaseMainMenu(Statistics.MAIN_MENU_SPONSORS);
        var ar:Array = ItemTypeStore.getStoreByTypeAndLevel(ItemTypeStore.TYPE_LOGO_SPONSOR);
        sponsorsPanel.setData(ar);
        sponsorsPanel.setPage(1);
        sponsorsPanel.show();
    }

    private function onClickMatchBtn(event:MouseEvent):void {
        Singletons.statistic.increaseMainMenu(Statistics.MAIN_MENU_MATCH);
        if(Application.teamProfiler.getFootballers(Footballer.ACTIVEED).length == Footballer.MAX_TEAM){
            championnats.show();
        }else{
            var msgBox:MessageBox = new MessageBox("Сообщение", "Для участия в соревнованиях необходимо набраться основной состав", MessageBox.OK_BTN); ;
            msgBox.show();
        }
    }

    private function onClickRatingBtn(event:MouseEvent):void {
        rating.show();
    }

    private function onClickStadiumBtn(event:MouseEvent):void {
        stadium.show();
    }

    private function onClickCupBtn(event:MouseEvent):void {
        cupInfo.show();
    }

    private function onClickNewsBtn(event:MouseEvent):void {
        news.show();
    }

}
}