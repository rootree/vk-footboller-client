package ru.kubline.interfaces.menu.shop {
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.interfaces.menu.*;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.text.TextField;
import ru.kubline.controllers.Singletons;
import ru.kubline.gui.controls.button.UIButton;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.interfaces.PriceContainer;
import ru.kubline.interfaces.UserPanel;
import ru.kubline.interfaces.menu.shop.cups.CupSelectedEvent;
import ru.kubline.interfaces.menu.shop.cups.CupsPanel;
import ru.kubline.interfaces.menu.shop.footballes.FootballerSelectedEvent;
import ru.kubline.interfaces.menu.shop.footballes.FootballersPanel;
import ru.kubline.interfaces.menu.shop.teams.TeamPanel;
import ru.kubline.interfaces.menu.shop.teams.TeamSelectedEvent;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.model.Footballer;
import ru.kubline.model.Price;
import ru.kubline.model.Trainer;
import ru.kubline.net.HTTPConnection;

/**
 * Работа с главным магазином
 */
public class ShopMenu extends UIWindow  {

    private var tryBuy:UIButton;
    private var backBtn:UIButton;
    private var closeTextBtn:UISimpleButton;
    private var inBank:UISimpleButton;

    private var money:TextField;
    private var realMoney:TextField;

    private var emptyStore:MovieClip;

    private var peoplePrice:PriceContainer;

    private var chooseMoneyType:ChooseBayMoneyDialogAbstract;

    private var cupsPanel:CupsPanel;
    private var teamsPanel:TeamPanel;
    private var footballersPanel:FootballersPanel;

    private var shopTitle:TextField;

    private var currentStep:uint;

    public var cup:ItemResource;
    public var team:ItemResource;
    public var footballer:ItemResource;
    public var footballerItem:UIMenuItem;

    public function ShopMenu(container:MovieClip) {

        super(container);

        cupsPanel = new CupsPanel(MovieClip(container.getChildByName("chooseCupPanel")));
        teamsPanel = new TeamPanel(MovieClip(container.getChildByName("chooseTeamPanel")));
        footballersPanel = new FootballersPanel(MovieClip(container.getChildByName("chooseFootballerPanel")));
 
    }

    override protected function initComponent():void{
        super.initComponent();
 
        shopTitle = TextField(getChildByName("shopTitle"));

        cupsPanel.addEventListener(CupSelectedEvent.SELECTED, onCupSelected);
        teamsPanel.addEventListener(TeamSelectedEvent.SELECTED, onTeamSelected);
        footballersPanel.addEventListener(FootballerSelectedEvent.SELECTED, onFootballerSelected);
        footballersPanel.addEventListener(FootballersPanel.TAB_CHANGED, onChangePanel);

        cupsPanel.setVisible(false);
        teamsPanel.setVisible(false);
        footballersPanel.setVisible(false);

        if (Application.teamProfiler.isDiscount()) {
            chooseMoneyType = new ChooseBayMoneyDialogTour();
        }else{
            chooseMoneyType = new ChooseBayMoneyDialog();
        }
        chooseMoneyType.addEventListener(ChooseBayMoneyDialog.SELECTED_IN_GAME, onBayForInGame);
        chooseMoneyType.addEventListener(ChooseBayMoneyDialog.SELECTED_REALS, onBayForReal);

        emptyStore = MovieClip(container.getChildByName("emptyStore"));

        peoplePrice = new PriceContainer(MovieClip(container.getChildByName("pricer")));
        peoplePrice.setColor(peoplePrice.COLOR_WFITE);

        var buyBtnMovie:MovieClip = MovieClip(container.getChildByName("tryBuyARA"));
        tryBuy = new UIButton(buyBtnMovie);
        tryBuy.addHandler(onTryBuyClick);

        //var buyBtnMovie:MovieClip = MovieClip(container.getChildByName("backBtn"));
        backBtn = new UIButton(MovieClip(container.getChildByName("backBtn")));
        backBtn.addHandler(onBackClick);

        closeTextBtn = new UISimpleButton(SimpleButton(container.getChildByName("closeBtn")));
        closeTextBtn.addHandler(onCloseClick);

        inBank = new UISimpleButton(SimpleButton(container.getChildByName("inBank")));
        inBank.addHandler(inBankClick);
        inBank.setVisible(false);

        container.setChildIndex(emptyStore, container.numChildren - 1);

        updateMoney();

    }

    override public function destroy():void{
        super.destroy();
        inBank.removeHandler(inBankClick);
        closeTextBtn.removeHandler(onCloseClick);
        backBtn.removeHandler(onBackClick);
        tryBuy.removeHandler(onTryBuyClick);

        chooseMoneyType.removeEventListener(ChooseBayMoneyDialog.SELECTED_IN_GAME, onBayForInGame);
        chooseMoneyType.removeEventListener(ChooseBayMoneyDialog.SELECTED_REALS, onBayForReal);

        cupsPanel.removeEventListener(CupSelectedEvent.SELECTED, onCupSelected);
        teamsPanel.removeEventListener(TeamSelectedEvent.SELECTED, onTeamSelected);
        footballersPanel.removeEventListener(FootballerSelectedEvent.SELECTED, onFootballerSelected);
        footballersPanel.removeEventListener(FootballersPanel.TAB_CHANGED, onChangePanel) ;
    }

    private function onBayForInGame(e:Event):void {
        buyItem(true);
    }

    private function onBayForReal(e:Event):void {
        buyItem(false);
    }

    private function buyItem(isInGame:Boolean):void{
        Singletons.connection.addEventListener(HTTPConnection.COMMAND_BUY_FOOTBALLER, whenBuyed);
        Singletons.connection.addEventListener(IOErrorEvent.IO_ERROR, whenBuyed);
        Singletons.connection.send(HTTPConnection.COMMAND_BUY_FOOTBALLER, {isInGame:isInGame, peopleId:footballer.getId(), line: (footballer.getShopType())});
    }

    private function inBankClick(e:Event):void {
        UserPanel.bankController.showMenu();
    }

    /**
     * Пытаемся что-то купить
     * @param event
     */
    private function onCupSelected(event:CupSelectedEvent):void {

        cup = event.cup;
        selectTeamPlease();
    }

    private function selectTeamPlease():void{

        currentStep = 1;

        backBtn.setDisabled(false);
        tryBuy.setDisabled(true);

        cupsPanel.setVisible(false);
        teamsPanel.setVisible(true);
        footballersPanel.setVisible(false);

        teamsPanel.redraw(cup.getId());

        emptyStore.visible = !Boolean(teamsPanel.getData().getTotalCount());
        shopTitle.text = cup.getName();

    }

    /**
     * Пытаемся что-то купить
     * @param event
     */
    private function onTeamSelected(event:TeamSelectedEvent):void {

        team = event.team;
        selectFootballed();
    }

    /**
     * Пытаемся что-то купить
     * @param event
     */
    private function onFootballerSelected(event:FootballerSelectedEvent):void {
        footballer = event.footballer;
        footballerItem = event.footballerItem;
        tryBuy.setDisabled(false);
    }

    /**
     * Пытаемся что-то купить
     * @param event
     */
    private function onChangePanel(event:Event):void {
        emptyStore.visible = !Boolean(footballersPanel.getData().getTotalCount());
    }

    private function selectFootballed():void{

        currentStep = 2;

        backBtn.setDisabled(false);
        tryBuy.setDisabled(true);

        cupsPanel.setVisible(false);
        teamsPanel.setVisible(false);
        footballersPanel.setVisible(true);

        footballersPanel.setTeamId(team.getId());
        footballersPanel.redraw(ItemTypeStore.TYPE_FORWARD);

        emptyStore.visible = !Boolean(footballersPanel.getData().getTotalCount());
        shopTitle.text = team.getName();

    }

    /**
     * Пытаемся что-то купить
     * @param event
     */
    private function onBackClick(event:MouseEvent):void {

        switch (currentStep){
            case 1: selectCups(); break;
            case 2: selectTeamPlease(); break;
        }

    }

    /**
     * Пытаемся что-то купить
     * @param event
     */
    private function onTryBuyClick(event:MouseEvent):void {
        chooseMoneyType.showMenu(footballer);
    }

    private function whenBuyed(e:Event):void{

        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_BUY_FOOTBALLER, whenBuyed);
        Singletons.connection.removeEventListener(IOErrorEvent.IO_ERROR, whenBuyed);

        var result:Object = HTTPConnection.getResponse();
        var msgBox:MessageBox;

        if(result){

            Application.teamProfiler.setRealMoney(parseFloat(result.balance.realMoney));
            Application.teamProfiler.setMoney(parseFloat(result.balance.money));
            Application.mainMenu.userPanel.setMoney(Application.teamProfiler.getMoney().toString());
            Application.mainMenu.userPanel.setRealMoney(Application.teamProfiler.getRealMoney().toString());

            var isActive:Boolean;
            var footballer:Footballer;


            var item:ItemResource = ItemResource(this.footballer);
            var message:String;

            if(item.getShopType() == ItemTypeStore.TYPE_TEAMLEAD){
                var teamlead:Trainer = new Trainer(item.getId());
                Application.teamProfiler.setTrainer(teamlead);
                Application.mainMenu.userPanel.setTeamLeadName();
                Application.mainMenu.userPanel.updateTrainerAvatar();
                message = "Вы только что наняли отличного тренера";

            }else{
                isActive = Boolean(parseInt(result.isActive));
                footballer = new Footballer(item.getName(), item.getParams().level, item.getShopType(),
                        item.getId(), false, isActive, "", item.getPrice().price);

                Application.teamProfiler.addFootballer(footballer);

                Application.teamProfiler.setParamForward(parseInt(result.teamParameters.Forward));
                Application.teamProfiler.setParamSafe(parseInt(result.teamParameters.Safe));
                Application.teamProfiler.setParamHalf(parseInt(result.teamParameters.Half));

                message = "Вы только что взяли в команду великолепного футболиста";
            }

            footballerItem.setDisabled(true);
            msgBox = new MessageBox("Наши поздравления!", message, MessageBox.OK_BTN);
            // CupsItem(this.getSelectedMenuItem()).setDisabled(true);

            tryBuy.setDisabled(true);
            msgBox.show();
            updateMoney();
        }

    }

    override public function show():void {
        super.show();
        selectCups();
    }

    private function selectCups():void{
        shopTitle.text = "Мой магазин";

        cupsPanel.setVisible(true);
        teamsPanel.setVisible(false);
        footballersPanel.setVisible(false);

        cupsPanel.redraw();
        emptyStore.visible = !Boolean(cupsPanel.getData().getTotalCount());

        currentStep = 0;
        backBtn.setDisabled(true);
        tryBuy.setDisabled(true);
    }

    override protected function onCloseClick(event:MouseEvent):void {
        super.onCloseClick(event);
    }

    public function updateMoney():void {
        if(peoplePrice){
            peoplePrice.setPrice(new Price(Application.teamProfiler.getMoney(), Application.teamProfiler.getRealMoney()));
        }
    }
}
}