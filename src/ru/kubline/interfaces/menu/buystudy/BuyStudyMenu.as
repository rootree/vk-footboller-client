package ru.kubline.interfaces.menu.buystudy {
import flash.events.IOErrorEvent;

import ru.kubline.controllers.Singletons;
import ru.kubline.interfaces.menu.ChooseBayMoneyDialog;
import ru.kubline.interfaces.menu.news.*;
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.events.Event;
import ru.kubline.comon.Classes;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.controls.menu.UIPagingMenu;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.loader.ClassLoader;
import ru.kubline.model.StudyPayment;
import ru.kubline.net.HTTPConnection;

public class BuyStudyMenu extends UIPagingMenu{

    private var chooseMoneyType:ChooseBayMoneyDialog;
    private var paymentRecord:StudyPayment;

    public function BuyStudyMenu() {
        super(ClassLoader.getNewInstance(Classes.PANEL_BUY_STUDY));

        chooseMoneyType = new ChooseBayMoneyDialog();
    }

    override protected function initComponent():void{
        super.initComponent();

        chooseMoneyType.addEventListener(ChooseBayMoneyDialog.SELECTED_IN_GAME, onBayForInGame);
        chooseMoneyType.addEventListener(ChooseBayMoneyDialog.SELECTED_REALS, onBayForReal);

    }

    override public function destroy():void{

        super.destroy();

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

    override public function show():void{

        var ar:Array = BuyStudyStore.getStore();

        setData(ar);
        setPage(1);
        super.show();
        hideNavigationButtons() ;
    }

    override protected function createCell(cell:DisplayObject):IUIMenuItem {
        var logoItem:BuyStudyItem = new BuyStudyItem(MovieClip(cell));
        logoItem.addEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick);
        return logoItem;
    }

    private function onItemClick(e:Event):void {

        var isInGame:Boolean = false;
        var item:UIMenuItem = UIMenuItem(e.target);

        if(item.isDisabled()){
            return;
        }

        var itemRecord:StudyPayment = StudyPayment(item.getItem());
        if(itemRecord != null){
            paymentRecord = itemRecord;
            hide();
            chooseMoneyType.showMenu(paymentRecord);
        }
    }

    private function buyItem(isInGame:Boolean):void{
        Singletons.connection.addEventListener(HTTPConnection.COMMAND_BUY_STUDY_POINTS, whenBuyed);
        Singletons.connection.addEventListener(IOErrorEvent.IO_ERROR, whenBuyed);
        Singletons.connection.send(HTTPConnection.COMMAND_BUY_STUDY_POINTS, {isInGame:isInGame, paymentId : paymentRecord.paymentId});
    }

    private function whenBuyed(e:Event):void{

        Singletons.connection.removeEventListener(HTTPConnection.COMMAND_BUY_STUDY_POINTS, whenBuyed);
        Singletons.connection.removeEventListener(IOErrorEvent.IO_ERROR, whenBuyed);

        var result:Object = HTTPConnection.getResponse();
        var msgBox:MessageBox;

        if(result){

            Application.teamProfiler.setRealMoney(parseFloat(result.balance.realMoney));
            Application.teamProfiler.setMoney(parseFloat(result.balance.money));
            Application.teamProfiler.setStudyPoints(parseFloat(result.balance.studyPoints));

            Application.mainMenu.userPanel.update();

            var message:String =  "Вы докупили дополнительные очки обучения";
            msgBox = new MessageBox("Сообщение", message, MessageBox.OK_BTN, function():void{
                Application.mainMenu.stadium.show();
            });
            msgBox.show();
        }

    }

    override protected function initCell(cell:IUIMenuItem, item:Object):void {
        if (item) {
            super.initCell(cell, item);
        }
        cell.setVisible(item != null);
    }
}
}