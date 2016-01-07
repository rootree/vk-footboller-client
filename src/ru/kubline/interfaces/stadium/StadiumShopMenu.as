package ru.kubline.interfaces.stadium {

import flash.display.BitmapData;

import ru.kubline.controllers.WallController;
import ru.kubline.gui.controls.QuantityPanel;
import ru.kubline.interfaces.PriceContainer;
import ru.kubline.interfaces.menu.ChooseBayMoneyDialog;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.Event;
import flash.events.IOErrorEvent;
import flash.text.TextField;
import ru.kubline.comon.Classes;
import ru.kubline.controllers.Singletons;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.controls.menu.UIPagingMenu;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.model.Price;
import ru.kubline.net.HTTPConnection;

public class StadiumShopMenu extends UIPagingMenu{

    private var closeBtn:UISimpleButton;
    private var buyBtn:UISimpleButton;

    private var titleStadiumText:TextField;
    private var cityStadiumText:TextField;
    private var bonusText:TextField;

    private var stadiumImage:MovieClip;

    private var peoplePrice:PriceContainer;

    private var chooseMoneyType:ChooseBayMoneyDialog;
    private var itemRecord:ItemResource;

    private var starsPanel:QuantityPanel;

    private var userBalancePrice:PriceContainer;

    public function StadiumShopMenu() {

        super(ClassLoader.getNewInstance(Classes.PANEL_STADIUM_SHOP));

        chooseMoneyType = new ChooseBayMoneyDialog();

    }

    override protected function initComponent():void{
        super.initComponent();

        buyBtn = new UISimpleButton(SimpleButton(getChildByName("buyBtn")));
        buyBtn.addHandler(onBuyClick);

        closeBtn = new UISimpleButton(SimpleButton(getChildByName("closeBtn")));
        closeBtn.addHandler(onCloseClick);

        titleStadiumText = TextField(getChildByName("stadiumTytle"));
        cityStadiumText = TextField(getChildByName("stadiumCity"));
        bonusText = TextField(getChildByName("bonus"));

        stadiumImage = MovieClip(getChildByName("bigPhotoStadium"));

        peoplePrice = new PriceContainer(MovieClip(getChildByName("pricer")));
        peoplePrice.setColor(peoplePrice.COLOR_WFITE);

        userBalancePrice = new PriceContainer(MovieClip(getChildByName("userBalancePrice")));
        userBalancePrice.setColor(peoplePrice.COLOR_WFITE);


        chooseMoneyType.addEventListener(ChooseBayMoneyDialog.SELECTED_IN_GAME, onBayForInGame);
        chooseMoneyType.addEventListener(ChooseBayMoneyDialog.SELECTED_REALS, onBayForReal);

        starsPanel = new QuantityPanel(MovieClip(getChildByName("starts")));
        starsPanel.setMaxValue(5);

    }

    override public function destroy():void{

        super.destroy();
 
        buyBtn.removeHandler(onBuyClick);
        closeBtn.removeHandler(onCloseClick);

        chooseMoneyType.removeEventListener(ChooseBayMoneyDialog.SELECTED_IN_GAME, onBayForInGame);
        chooseMoneyType.removeEventListener(ChooseBayMoneyDialog.SELECTED_REALS, onBayForReal);

        for each (var item:IUIMenuItem in cells) {
            item.removeEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick);
        }
    }


    private function onBayForInGame(e:Event):void {
        buyItem(true);
    }

    private function onBayForReal(e:Event):void {
        buyItem(false);
    }

    private function buyItem(isInGame:Boolean):void{
        Singletons.connection.addEventListener(HTTPConnection.COMMAND_BUY_STADIUM, whenBuyed);
        Singletons.connection.addEventListener(IOErrorEvent.IO_ERROR, whenBuyed);
        Singletons.connection.send(HTTPConnection.COMMAND_BUY_STADIUM, {
            isInGame : isInGame ,
            stadiumId : itemRecord.getId()
        });
    }

    private function onBuyClick(e:Event):void{
        chooseMoneyType.showMenu(itemRecord);
    }

    private function whenBuyed(e:Event):void{

        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_BUY_STADIUM, whenBuyed);
        Singletons.connection.removeEventListener(IOErrorEvent.IO_ERROR, whenBuyed);

        var result:Object = HTTPConnection.getResponse();
        var msgBox:MessageBox;

        if(result.balance){

            Application.teamProfiler.setRealMoney(parseFloat(result.balance.realMoney));
            Application.teamProfiler.setMoney(parseFloat(result.balance.money));
            Application.mainMenu.userPanel.update();



            var message:String;
            if(Application.teamProfiler.getStadium().getId()){
                message = "Новый стадион приобретен успешно";
            }else{
                message = "Теперь у вас есть свой \nсобственный стадион";
            }

            Application.teamProfiler.initStadiumById(itemRecord.getId());
            Application.mainMenu.stadium.show();
            updateMoney();
            
            var uploadImage:BitmapData = Gallery.getFromStore(Gallery.TYPE_STADIUM, itemRecord.getId().toString());
            new WallController(uploadImage, Application.teamProfiler.getSocialUserId(),
                    "Великолепно. Теперь у меня есть свой собственный стадион «" + Application.teamProfiler.getStadium().getName() + "»",
                    message + "\n\nРасскажите своим друзьям об этой замечательной новости")
                .start();
 
            super.hide();
        }
    }

    override public function show():void{

        var data:Array;
        data = ItemTypeStore.getStoreByType(ItemTypeStore.TYPE_STADIUM);

        setData(data);
        setPage(1);

        super.show();
        
        if(data.length){
            getSelectedMenuItem().dispatchEvent(new Event(UIEvent.MENU_ITEM_CLICK));
        }
        updateMoney();

    }

    override public function hide():void{
        Application.mainMenu.stadium.show();
        super.hide();
    }

    override protected function createCell(cell:DisplayObject):IUIMenuItem {
        var logoItem:StadiumShopItem = new StadiumShopItem(MovieClip(cell));
        logoItem.addEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick);
        return logoItem;
    }
  
    private function onItemClick(e:Event):void {

        var item:UIMenuItem = UIMenuItem(e.target);

        if(item.isDisabled()){
            return;
        }

        itemRecord = ItemResource(item.getItem());

        if(itemRecord != null){

            titleStadiumText.text = itemRecord.getParams().tytle;   // .getParams().
            cityStadiumText.text = itemRecord.getParams().city;

            bonusText.text = itemRecord.getParams().daily;
            starsPanel.setValue(itemRecord.getParams().rating);

            stadiumImage = MovieClip(getChildByName("bigPhotoStadium"));

            new Gallery(stadiumImage, Gallery.TYPE_STADIUM, itemRecord.getId().toString(), true);
            peoplePrice.setPrice(itemRecord.getPrice());
        }
    }

    override protected function initCell(cell:IUIMenuItem, item:Object):void {
        if (item) {
            super.initCell(cell, item);
        }
        cell.setVisible(item != null);
    }

    public function updateMoney():void {
        userBalancePrice.setPrice(new Price(Application.teamProfiler.getMoney(), Application.teamProfiler.getRealMoney()));
    }
}
}