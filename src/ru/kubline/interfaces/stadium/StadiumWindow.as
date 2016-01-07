package ru.kubline.interfaces.stadium {
import flash.events.Event;
import flash.events.IOErrorEvent;

import ru.kubline.controllers.Singletons;
import ru.kubline.gui.controls.QuantityPanel;
import ru.kubline.gui.controls.UIWindow;

import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;
import flash.text.TextField;
import ru.kubline.comon.Classes;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.interfaces.menu.ChooseBayMoneyDialog;
import ru.kubline.interfaces.menu.buystudy.BuyStudyMenu;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.model.Price;
import ru.kubline.model.Sponsor;
import ru.kubline.model.Stadium;
import ru.kubline.model.StudyPayment;
import ru.kubline.net.HTTPConnection;

public class StadiumWindow extends UIWindow{

    public var stadiumShop:StadiumShopMenu;
    public var buyStudy:BuyStudyMenu;

    private var closeBtn:UISimpleButton;
    private var buyBtn:UISimpleButton;
    private var ecxangeBtn:UISimpleButton;

    private var addStudyPointBtn:UISimpleButton;
    private var freshEnergyBtn:UISimpleButton;

    private var titleStadiumText:TextField;
    private var cityStadiumText:TextField;

    private var totalBonusText:TextField;
    private var bonusText:TextField;
    private var indexSponsorsText:TextField;
    private var indexFanatsText:TextField;

    private var stadiumImage:MovieClip;

    private var stadiumParameters:MovieClip;
    private var stadiumNotExists:MovieClip;

    private var starsPanel:QuantityPanel;

    private var chooseMoneyType:ChooseBayMoneyDialog;

    public function StadiumWindow() {

        super(ClassLoader.getNewInstance(Classes.PANEL_STADIUM));

        stadiumShop = new StadiumShopMenu();
        buyStudy = new BuyStudyMenu();

        chooseMoneyType = new ChooseBayMoneyDialog();

    }

    override protected function initComponent():void{
        super.initComponent();
 
        closeBtn = new UISimpleButton(SimpleButton(getChildByName("closeBtn")));
        closeBtn.addHandler(onCloseClick);

        buyBtn = new UISimpleButton(SimpleButton(getChildByName("bayBtn")));
        buyBtn.addHandler(onBuyClick);

        ecxangeBtn = new UISimpleButton(SimpleButton(getChildByName("exchange")));
        ecxangeBtn.addHandler(onExchangeClick);

        stadiumParameters = MovieClip(getChildByName("stadiumParameters"));
        stadiumNotExists = MovieClip(getChildByName("stadiumNotExists"));

        addStudyPointBtn = new UISimpleButton(SimpleButton(stadiumParameters.getChildByName("addStudyPointBtn")));
        addStudyPointBtn.addHandler(onAddPointClick);

        freshEnergyBtn = new UISimpleButton(SimpleButton(stadiumParameters.getChildByName("freshEnergyBtn")));
        freshEnergyBtn.addHandler(onGetFreshClick);

        titleStadiumText = TextField(stadiumParameters.getChildByName("stadiumTytle"));
        cityStadiumText = TextField(stadiumParameters.getChildByName("stadiumCity"));

        totalBonusText = TextField(stadiumParameters.getChildByName("totalBonus"));
        bonusText = TextField(stadiumParameters.getChildByName("bonus"));
        indexSponsorsText = TextField(stadiumParameters.getChildByName("indexSponsors"));
        indexFanatsText = TextField(stadiumParameters.getChildByName("indexFanats"));

        if(!starsPanel){
            starsPanel = new QuantityPanel(MovieClip(stadiumParameters.getChildByName("starts")));
            starsPanel.setMaxValue(5);
        }

        stadiumImage = MovieClip(stadiumParameters.getChildByName("photoOfStadium"));
 
        chooseMoneyType.addEventListener(ChooseBayMoneyDialog.SELECTED_IN_GAME, onBayForInGame);
        chooseMoneyType.addEventListener(ChooseBayMoneyDialog.SELECTED_REALS, onBayForReal);

    }

    override public function destroy():void{

        super.destroy();

        closeBtn.removeHandler(onCloseClick);
        addStudyPointBtn.removeHandler(onAddPointClick);
        freshEnergyBtn.removeHandler(onGetFreshClick);
        ecxangeBtn.removeHandler(onExchangeClick);
        buyBtn.removeHandler(onBuyClick);

        chooseMoneyType.removeEventListener(ChooseBayMoneyDialog.SELECTED_IN_GAME, onBayForInGame);
        chooseMoneyType.removeEventListener(ChooseBayMoneyDialog.SELECTED_REALS, onBayForReal);
    }

    private function onBayForInGame(e:Event):void {
        buyFreshItem(true);
    }

    private function onBayForReal(e:Event):void {
        buyFreshItem(false);
    }

    private function buyFreshItem(isInGame:Boolean):void{
        Singletons.connection.addEventListener(HTTPConnection.COMMAND_FRESH_ENERGY, whenBuyed);
        Singletons.connection.addEventListener(IOErrorEvent.IO_ERROR, whenBuyed);
        Singletons.connection.send(HTTPConnection.COMMAND_FRESH_ENERGY, {
            isInGame : isInGame
        });
    }

    private function whenBuyed(e:Event):void{

        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_FRESH_ENERGY, whenBuyed);
        Singletons.connection.removeEventListener(IOErrorEvent.IO_ERROR, whenBuyed);

        var result:Object = HTTPConnection.getResponse();
        var msgBox:MessageBox;

        if(result){
            Application.teamProfiler.setRealMoney(parseFloat(result.balance.realMoney));
            Application.teamProfiler.setMoney(parseFloat(result.balance.money));
            Application.teamProfiler.setEnergy(parseFloat(result.balance.energy));
            Application.mainMenu.userPanel.update();

            var message:String = "Энергия команды полностью восстановлена";
            msgBox = new MessageBox("Сообщение", message, MessageBox.OK_BTN);
            msgBox.show();
        }
    }

    private function onBuyClick(event:MouseEvent):void {
        hide();
        stadiumShop.show();
    }

    private function onExchangeClick(event:MouseEvent):void {
        hide();
        stadiumShop.show();
    }

    private function onGetFreshClick(event:MouseEvent):void {
        var freshEnergy:StudyPayment = new StudyPayment(0, 0, new Price(5000, 3), 0, 0); // TODO
        chooseMoneyType.showMenu(freshEnergy);
    }

    private function onAddPointClick(event:MouseEvent):void {
        hide();
        buyStudy.show();
    }

    override public function show():void{

        super.show();

        var isInstallerStadiums:Boolean = Boolean(Application.teamProfiler.getStadium().getId());

        stadiumNotExists.visible = !isInstallerStadiums;
        stadiumParameters.visible = isInstallerStadiums;

        buyBtn.setVisible(!isInstallerStadiums);
        ecxangeBtn.setVisible(isInstallerStadiums);

        if(isInstallerStadiums){

            var stadium:Stadium = Application.teamProfiler.getStadium();

            titleStadiumText.text = stadium.getName();
            cityStadiumText.text = stadium.getCityName();

            new Gallery(stadiumImage, Gallery.TYPE_STADIUM, Application.teamProfiler.getStadium().getId().toString(), true);


            starsPanel.setValue(stadium.getRating());

            bonusText.text = stadium.getDailyBonus().toString();
            
            totalBonusText.text = Application.teamProfiler.getTotalStadiumBonus().toString();;

            indexSponsorsText.text = Application.teamProfiler.getEvergyRate().toString();
            indexFanatsText.text = Application.teamProfiler.getFanatRating().toString();

            initSponsors();
        }

    }

    public function initSponsors():void{

        var sponsor:MovieClip;

        var friendSponsor:Object = Application.teamProfiler.getSponsors();

        var sponsorCount:uint = 1;
        var sponsorId:uint;

        for each (var value:Sponsor in friendSponsor) {
            sponsor = MovieClip(stadiumParameters.getChildByName("sponsor" + sponsorCount));
            sponsorId = value.getId();
            new Gallery(MovieClip(sponsor.getChildByName("container")), Gallery.TYPE_SPONSOR, sponsorId.toString(), true);
            sponsorCount++;
            sponsor.visible = true;
        }

        for(; sponsorCount < 4; sponsorCount ++){
            sponsor = MovieClip(stadiumParameters.getChildByName("sponsor" + sponsorCount));
            MovieClip(MovieClip(sponsor.getChildByName("container")).getChildByName("loading")).stop();
            if(sponsor){
                sponsor.visible = false;
            }
        }
    }
}
}