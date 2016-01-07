package ru.kubline.interfaces {
import flash.display.MovieClip;
import flash.display.SimpleButton;

import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;

import flash.text.TextField;

import ru.kubline.comon.Classes;
import ru.kubline.controllers.Singletons;
import ru.kubline.events.InterfaceEvent;
import ru.kubline.gui.controls.QuantityPanel;
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.controls.button.UIButton;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.interfaces.lang.Messages;
import ru.kubline.interfaces.menu.team.UserPlayersMenu;
import ru.kubline.interfaces.window.FootballerWindow;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.interfaces.window.SuperSellBox;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.model.Footballer;
import ru.kubline.model.Price;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.UserProfileHelper;
import ru.kubline.net.HTTPConnection;
import ru.kubline.utils.EndingUtils;
import ru.kubline.utils.MessageUtils;

public class UserTeam extends UIWindow{

    private var acitePlayersPanel:UserPlayersMenu ;
    private var deacitePlayersPanel:UserPlayersMenu ;

    private var safeBtn:UISimpleButton;
    private var closeBtn:UISimpleButton;

    private var inActive:UIButton;
    private var inDeactive:UIButton;
    private var settingsBtn:UIButton;
    private var sellBtn:UIButton;
    private var superBtn:UIButton;

    private var emptyTeam:MovieClip;
    private var emptyReserve:MovieClip;

    private var safeInfo:TextField;
    private var availableStady:TextField;

    private var data:Object;
    private var stadyPoint:uint;

    private var progressSafe:QuantityPanel;
    private var progressHalf:QuantityPanel;
    private var progressForward:QuantityPanel;

    private var paramForward:TextField;
    private var paramHalf:TextField;
    private var paramSafe:TextField;
    private var player:Footballer;

    private var footballerSettings:FootballerWindow;
    private var megaBall:MovieClip;

    public static const LOCK_UP_BUTTONS_ACTIVE:String = "LOCK_UP_BUTTONS_ACTIVE";

    public static const LOCK_UP_BUTTONS_DEACTIVE:String = "LOCK_UP_BUTTONS_DEACTIVE";

    public static const FAVORITE_COST:uint = 30;

    private var safeText:String = "Параметры вступят в силу после сохранения";

    public function UserTeam() {
        super(ClassLoader.getNewInstance(Classes.PANEL_USER_TEAM));

        var progressSafeMovieClip:MovieClip = MovieClip(getContainer().getChildByName("progressSafe"));
        var progressHalfMovieClip:MovieClip = MovieClip(getContainer().getChildByName("progressHalf"));
        var progressForwardMovieClip:MovieClip = MovieClip(getContainer().getChildByName("progressForward"));

        if(progressSafeMovieClip){
            progressSafe = new QuantityPanel(progressSafeMovieClip);
            progressSafe.setMaxValue(TeamProfiler.MAX_TEAM_PARAM);
        }
        if(progressHalfMovieClip){
            progressHalf = new QuantityPanel(progressHalfMovieClip);
            progressHalf.setMaxValue(TeamProfiler.MAX_TEAM_PARAM);
        }
        if(progressForwardMovieClip){
            progressForward = new QuantityPanel(progressForwardMovieClip);
            progressForward.setMaxValue(TeamProfiler.MAX_TEAM_PARAM);
        }

    }

    override protected function initComponent():void{

        super.initComponent();

        closeBtn = new UISimpleButton(SimpleButton(getChildByName("closeBtn")));
        closeBtn.addHandler(onCloseClick);

        safeBtn = new UISimpleButton(SimpleButton(getChildByName("safeBtn")));
        safeBtn.addHandler(onSaveClick);

        megaBall = MovieClip(container.getChildByName("megaBall"));

        acitePlayersPanel = new UserPlayersMenu(MovieClip(getChildByName("active")));
        acitePlayersPanel.addEventListener(InterfaceEvent.GLOBAL_LOCK_UP_BUTTONS, disableUp);
        acitePlayersPanel.handlerUp(this);
        acitePlayersPanel.hideNavigation(true);

        deacitePlayersPanel = new UserPlayersMenu(MovieClip(getChildByName("deacive")));
        deacitePlayersPanel.addEventListener(InterfaceEvent.GLOBAL_LOCK_UP_BUTTONS, disableUp);
        deacitePlayersPanel.handlerUp(this);

        inActive = new UIButton(MovieClip(container.getChildByName("inActive")));
        inActive.addHandler(moveToInActive);
        inActive.setQtip("В основной состав");

        inDeactive = new UIButton(MovieClip(container.getChildByName("inDeactive")));
        inDeactive.addHandler(moveToActive);
        inDeactive.setQtip("В запасные");

        settingsBtn = new UIButton(MovieClip(container.getChildByName("settingsBtn")));
        settingsBtn.addHandler(showFootballerSettings);
        settingsBtn.setDisabled(true);
        settingsBtn.setQtip("Узнать/Настроить параметры футболиста");

        sellBtn = new UIButton(MovieClip(container.getChildByName("sellBtn")));
        sellBtn.addHandler(sellFootballer);
        sellBtn.setDisabled(true);
        sellBtn.setQtip("Продажа футболиста");

        superBtn = new UIButton(MovieClip(container.getChildByName("superBtn")));
        superBtn.addHandler(setAsSuperStar);
        superBtn.setDisabled(true);
        superBtn.setQtip("Сделать фаворитом");


        paramForward = TextField(getContainer().getChildByName("paramForward"));
        paramHalf = TextField(getContainer().getChildByName("paramHalf"));
        paramSafe = TextField(getContainer().getChildByName("paramSafe"));

        emptyTeam = MovieClip(getChildByName("emptyTeam"));
        emptyReserve = MovieClip(getChildByName("emptyReserve"));

        availableStady = TextField(getContainer().getChildByName("availableStady"));

        safeInfo = TextField(getContainer().getChildByName("safeInfo"));
        safeInfo.visible = false;
        safeInfo.text = safeText;

        footballerSettings = new FootballerWindow();
        footballerSettings.addEventListener(UIEvent.ELEMENT_CHANGED, onChange);

        acitePlayersPanel.addEventListener(UIEvent.MENU_ITEM_CLICK, onItemClickActive);
        deacitePlayersPanel.addEventListener(UIEvent.MENU_ITEM_CLICK, onItemClickInActive);

        acitePlayersPanel.addEventListener(UIEvent.MENU_ITEM_DOUBLE_CLICK, onItemDoubleClick);
        deacitePlayersPanel.addEventListener(UIEvent.MENU_ITEM_DOUBLE_CLICK, onItemDoubleInClick);

        acitePlayersPanel.addEventListener(UIEvent.ELEMENT_CHANGED, onChange);
        deacitePlayersPanel.addEventListener(UIEvent.ELEMENT_CHANGED, onChange);

        safeInfo.visible = false;

        updateElements(true);

        superBtn.setDisabled(true);
    }

    override public function destroy():void{

        superBtn.removeHandler(setAsSuperStar);
        sellBtn.removeHandler(sellFootballer);
        settingsBtn.removeHandler(showFootballerSettings);
        inDeactive.removeHandler(moveToActive);
        safeBtn.removeHandler(onSaveClick);
        closeBtn.removeHandler(onCloseClick);

        acitePlayersPanel.removeEventListener(UIEvent.MENU_ITEM_CLICK, onItemClickActive);
        deacitePlayersPanel.removeEventListener(UIEvent.MENU_ITEM_CLICK, onItemClickInActive);
        acitePlayersPanel.removeEventListener(UIEvent.ELEMENT_CHANGED, onChange);
        deacitePlayersPanel.removeEventListener(UIEvent.ELEMENT_CHANGED, onChange);
        acitePlayersPanel.removeEventListener(InterfaceEvent.GLOBAL_LOCK_UP_BUTTONS, disableUp);
        deacitePlayersPanel.removeEventListener(InterfaceEvent.GLOBAL_LOCK_UP_BUTTONS, disableUp);

        super.destroy();
    }

    public function disableUp(e:Event):void {
        dispatchEvent(new Event(InterfaceEvent.GLOBAL_LOCK_UP_BUTTONS));
    }

    private function updateStadyPoint():void {
        var ST:uint = Application.teamProfiler.getStudyPoints();
        if(ST){
            megaBall.alpha = 1;
            availableStady.text  = ST + EndingUtils.chooseEnding(ST, " очков", " очко", " очка") + " обучения";
            availableStady.textColor  = UserPanel.MEGA_TXT_NORMAL;
        }else{
            megaBall.alpha = UserPanel.MEGA_BOLL_ALPHA;
            availableStady.text = "Очков обучения нет";
            availableStady.textColor  = UserPanel.MEGA_TXT_COLOR;
        }
    }

    private function moveToActive(e:Event):void {
        moveTo(false);
    }

    private function showFootballerSettings(e:Event):void {
        footballerSettings.show();
        footballerSettings.initPlayer(player);
    }

    private function sellFootballer(e:Event):void {

        var footballerCost:uint = Application.teamProfiler.getStudyPointCount() *  player.getLevel();
        footballerCost = (player.isFavorite()) ? footballerCost * 3 : footballerCost;
        footballerCost *= 0.25;

        if(Application.teamProfiler.isDiscount() && footballerCost > 0){
            // footballerCost = footballerCost - footballerCost * Application.teamProfiler.getTourBonus();
            footballerCost = Math.floor(footballerCost - footballerCost * Application.teamProfiler.getTourBonus() / 100);
        }

        var msgBox:MessageBox = new MessageBox("Сообщение",
                "На сегодняшний день \n" + player.getFootballerName() + " \nстоит: " + footballerCost + " $\n\nПродать футболиста?", MessageBox.OK_CANCEL_BTN, function():void{

            Singletons.connection.addEventListener(HTTPConnection.COMMAND_DROP_ITEM, whenSelld);
            Singletons.connection.addEventListener(IOErrorEvent.IO_ERROR, whenSelld);
            Singletons.connection.send(HTTPConnection.COMMAND_DROP_ITEM, {
                footballerId: player.getId()
            });

        });
        msgBox.show();
    }


    private function whenSelld(e:Event):void{

        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_DROP_ITEM, whenSelld);
        Singletons.connection.removeEventListener(IOErrorEvent.IO_ERROR, whenSelld);

        var result:Object = HTTPConnection.getResponse();

        if(result.balance){

            Application.teamProfiler.dropFootballerById(player.getId());

            data[player.getId()] = null;
            delete(data[player.getId()]) ;

            player = null;

            Application.teamProfiler.setParamForward(parseInt(result.teamParameters.Forward));
            Application.teamProfiler.setParamSafe(parseInt(result.teamParameters.Safe));
            Application.teamProfiler.setParamHalf(parseInt(result.teamParameters.Half));

            Application.teamProfiler.setRealMoney(parseInt(result.balance.realMoney));
            Application.teamProfiler.setMoney(parseInt(result.balance.money));

            Application.mainMenu.userPanel.setMoney(Application.teamProfiler.getMoney().toString());
            Application.mainMenu.userPanel.setRealMoney(Application.teamProfiler.getRealMoney().toString());
            Application.mainMenu.userPanel.update();

            updateElements(true);
        }
    }

    private function setAsSuperStar(e:Event):void {

        var footballerCost:uint = Application.teamProfiler.getStudyPointCount() *  player.getLevel();

        var msgBox:SuperSellBox = new SuperSellBox("Сообщение",
                FAVORITE_COST.toString(), MessageBox.OK_CANCEL_BTN, function():void{

            if(UserProfileHelper.isEnoughMoney(Application.teamProfiler, new Price(0, FAVORITE_COST))){

                Singletons.connection.addEventListener(HTTPConnection.COMMAND_SET_AS_STAR, whenSetAsStar);
                Singletons.connection.addEventListener(IOErrorEvent.IO_ERROR, whenSetAsStar);
                Singletons.connection.send(HTTPConnection.COMMAND_SET_AS_STAR, {
                    footballerId: player.getId()
                });

            }

        });
        msgBox.show();

    }

    private function whenSetAsStar(e:Event):void{

        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_SET_AS_STAR, whenSetAsStar);
        Singletons.connection.removeEventListener(IOErrorEvent.IO_ERROR, whenSetAsStar);

        var result:Object = HTTPConnection.getResponse();

        if(result && result.balance){

            Application.teamProfiler.setRealMoney(parseInt(result.balance.realMoney));
            Application.teamProfiler.setMoney(parseInt(result.balance.money));

            Application.mainMenu.userPanel.setMoney(Application.teamProfiler.getMoney().toString());
            Application.mainMenu.userPanel.setRealMoney(Application.teamProfiler.getRealMoney().toString());
            Application.mainMenu.userPanel.update();

            player.setFavorite("1");

            updateElements(true);
        }
    }


    private function moveToInActive(e:Event):void {
        moveTo(true);
    }

    private function moveTo(isActive:Boolean):void {
        var item:IUIMenuItem;
        if(!isActive){
            item = acitePlayersPanel.getSelectedMenuItem();
        }else{
            item = deacitePlayersPanel.getSelectedMenuItem();
        }
        var player:Footballer = Footballer(item.getItem());
        player.setIsActive(isActive);

        var sType:String = player.getType();
        switch(sType){
            case ItemTypeStore.TYPE_FORWARD:
                Application.teamProfiler.setParamForward((isActive) ?
                                                         Application.teamProfiler.getParamForward() + player.getLevel() :
                                                         Application.teamProfiler.getParamForward() - player.getLevel());
                break;
            case ItemTypeStore.TYPE_HALFSAFER:
                Application.teamProfiler.setParamHalf((isActive) ?
                                                      Application.teamProfiler.getParamHalf() + player.getLevel() :
                                                      Application.teamProfiler.getParamHalf() - player.getLevel());
                break;
            case ItemTypeStore.TYPE_GOALKEEPER:
            case ItemTypeStore.TYPE_SAFER:
                Application.teamProfiler.setParamSafe((isActive) ?
                                                      Application.teamProfiler.getParamSafe() + player.getLevel() :
                                                      Application.teamProfiler.getParamSafe() - player.getLevel());
                break;
        }

        safeInfo.visible = true;
        if(Application.teamProfiler.getFootballers(Footballer.ACTIVEED).length >= Footballer.MAX_TEAM){
            safeInfo.text = "Вы набрали полный состав команды и сможете участвовать в соревнованиях";
        }else{
            safeInfo.text = safeText;
        }
        updateElements(true);
    }


    private function updateElements(isNeedSetPage:Boolean):void {

        if(progressSafe){
            progressSafe.setValue(Application.teamProfiler.getParamSafe());
        }
        if(progressHalf){
            progressHalf.setValue(Application.teamProfiler.getParamHalf());
        }
        if(progressForward){
            progressForward.setValue(Application.teamProfiler.getParamForward());
        }

        paramForward.text = Application.teamProfiler.getParamForward().toString();
        paramHalf.text = Application.teamProfiler.getParamHalf().toString();
        paramSafe.text = Application.teamProfiler.getParamSafe().toString();

        MessageUtils.optimizeParameterSize(paramForward);
        MessageUtils.optimizeParameterSize(paramHalf);
        MessageUtils.optimizeParameterSize(paramSafe);

        acitePlayersPanel.redrawContainer(Footballer.ACTIVEED);
        deacitePlayersPanel.redrawContainer(Footballer.DEACTIVEED);

        var hideNavi:Boolean = deacitePlayersPanel.getData().getTotalCount() <= deacitePlayersPanel.getData().getPageSize();
        deacitePlayersPanel.hideNavigation(hideNavi);

        if(isNeedSetPage){
            acitePlayersPanel.setPage(1);
            deacitePlayersPanel.setPage(1);
        }

        inActive.setDisabled(true);
        inDeactive.setDisabled(true);

        inActive.setVisible(false);
        inDeactive.setVisible(true);

        acitePlayersPanel.setVisible(Boolean(acitePlayersPanel.getData().getTotalCount()));
        deacitePlayersPanel.setVisible(Boolean(deacitePlayersPanel.getData().getTotalCount()));

        emptyTeam.visible = !Boolean(acitePlayersPanel.getData().getTotalCount());
        emptyReserve.visible = !Boolean(deacitePlayersPanel.getData().getTotalCount());

        updateStadyPoint();

    }

    private function liteUpdateElements(isNeedSetPage:Boolean):void {

        acitePlayersPanel.redrawContainer(Footballer.ACTIVEED);
        deacitePlayersPanel.redrawContainer(Footballer.DEACTIVEED);

        progressSafe.setValue(Application.teamProfiler.getParamSafe());
        progressHalf.setValue(Application.teamProfiler.getParamHalf());
        progressForward.setValue(Application.teamProfiler.getParamForward());

        paramForward.text = Application.teamProfiler.getParamForward().toString();
        paramHalf.text = Application.teamProfiler.getParamHalf().toString();
        paramSafe.text = Application.teamProfiler.getParamSafe().toString();

        MessageUtils.optimizeParameterSize(paramForward);
        MessageUtils.optimizeParameterSize(paramHalf);
        MessageUtils.optimizeParameterSize(paramSafe);

        /*        availableStady.visible = Boolean(Application.teamProfiler.getStudyPoints());
         if(Application.teamProfiler.getStudyPoints()){
         availableStady.text = "У вас доступно очков обучения " + Application.teamProfiler.getStudyPoints();
         }*/

    }

    override public function show():void{

        player = null;

        data = Application.teamProfiler.getFootballersCopy();
        stadyPoint = Application.teamProfiler.getStudyPoints();

        super.show();
    }

    private function onChange(event:Event):void {

        safeInfo.visible = true;
        //   updateStadyPoint();

        stadyPoint = Application.teamProfiler.getStudyPoints();

        //     Application.teamProfiler.setFootballers(data);
        updateElements(true);
    }

    override public function hide():void{

        Application.teamProfiler.setFootballers(data);
        Application.teamProfiler.setStudyPoints(stadyPoint);

        settingsBtn.setDisabled(true);
        sellBtn.setDisabled(true);
        superBtn.setDisabled(true);

        super.hide();
    }

    private function onItemClickActive(e:Event):void {
        var item:IUIMenuItem = acitePlayersPanel.getSelectedMenuItem();
        player = Footballer(item.getItem());

        inDeactive.setDisabled(!player.getIsActive());
        inActive.setDisabled(player.getIsActive());

        inActive.setVisible(!player.getIsActive());
        inDeactive.setVisible(player.getIsActive());

        settingsBtn.setDisabled(false);
        sellBtn.setDisabled(false);
        superBtn.setDisabled(player.isFavorite());
    }

    private function onItemDoubleInClick(e:Event):void {

        onItemClickInActive(e);

        footballerSettings.show();
        footballerSettings.initPlayer(player);

    }

    private function onItemDoubleClick(e:Event):void {

        onItemClickActive(e);

        footballerSettings.show();
        footballerSettings.initPlayer(player);

    }

    private function onItemClickInActive(e:Event):void {

        var item:IUIMenuItem = deacitePlayersPanel.getSelectedMenuItem();

        player = Footballer(item.getItem());
        inDeactive.setDisabled(!player.getIsActive());
        inActive.setDisabled(player.getIsActive());

        inActive.setVisible(!player.getIsActive());
        inDeactive.setVisible(player.getIsActive());

        if(Application.teamProfiler.getFootballers(Footballer.ACTIVEED).length >= Footballer.MAX_TEAM || player.getHealthDown()){
            inActive.setDisabled(true);
            inActive.setDisabled(true);
            inDeactive.setVisible(false);
        }else{
            safeInfo.text = safeText;
        }
        settingsBtn.setDisabled(false);
        sellBtn.setDisabled(false);
        superBtn.setDisabled(player.isFavorite());
    }

    private function onSaveClick(event:MouseEvent):void {

        data = Application.teamProfiler.getFootballersCopy();



        var isExistsGoalKeeper:Boolean = false;
        var countOfActive:uint = 0;

        for each (var footballer:Footballer in Application.teamProfiler.getFootballers(Footballer.ACTIVEED)){
            if(footballer.getType() == ItemTypeStore.TYPE_GOALKEEPER){
                isExistsGoalKeeper = true;
            }
            countOfActive ++;
        }

        var msgBox:MessageBox ;
        if(countOfActive > 11){

            var text:String;
            if(data.length == countOfActive){
                text = "Есть некоторое недрозумение в команде.\n\nПересмотрите основной состав Вашей команды."  ;
            }else{
                text = "Некоторые из Ваших запасных футболистов тоже хотят участвовать \nв игре.\n\nПересмотрите основной состав \nВашей команды." ;
            }

            msgBox = new MessageBox("Сообщение", text , MessageBox.OK_BTN); ;
            msgBox.show();

            for each (footballer in Application.teamProfiler.getFootballers(0)){
                footballer.setIsActive(false);
            }

            updateElements(true);

            return;
        }

        if(isExistsGoalKeeper){
            Singletons.connection.addEventListener(HTTPConnection.COMMAND_SAVE_FOOTBALLER, whenSafed);
            Singletons.connection.addEventListener(IOErrorEvent.IO_ERROR, whenSafed);
            Singletons.connection.send(HTTPConnection.COMMAND_SAVE_FOOTBALLER, Application.teamProfiler.getJSONofFootballers());
            hide();
        }else{
            msgBox = new MessageBox("Сообщение",
                    "В основном составе команды обязательно должен присутствовать вратарь", MessageBox.OK_BTN); ;
            msgBox.show();
        }
    }

    private function whenSafed(e:Event):void{

        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_SAVE_FOOTBALLER, whenSafed);
        Singletons.connection.removeEventListener(IOErrorEvent.IO_ERROR, whenSafed);

        var result:Object = HTTPConnection.getResponse();
        if(result){

            Application.teamProfiler.setParamForward(parseInt(result.teamParameters.Forward));
            Application.teamProfiler.setParamSafe(parseInt(result.teamParameters.Safe));
            Application.teamProfiler.setParamHalf(parseInt(result.teamParameters.Half));

            Application.teamProfiler.setStudyPoints(parseInt(result.studyPoints));
            Application.mainMenu.userPanel.setStudyPoints(Application.teamProfiler.getStudyPoints().toString());

            //    data = Application.teamProfiler.getFootballers(0);

            stadyPoint = Application.teamProfiler.getStudyPoints();

            if(Application.teamProfiler.getFootballers(Footballer.ACTIVEED).length < Footballer.MAX_TEAM){
                var msgBox:MessageBox = new MessageBox("Сообщение", "У вас недобор в основном составе. вы не сможете участвовать в соревнованиях", MessageBox.OK_BTN); ;
                msgBox.show();
            }
        }
    }

}
}