package ru.kubline.interfaces.menu {
import flash.display.MovieClip;
import flash.display.SimpleButton;

import flash.events.Event;

import flash.text.TextField;

import ru.kubline.comon.Classes;
import ru.kubline.controllers.Singletons;
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.interfaces.UserPanel;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.model.Price;
import ru.kubline.model.UserProfileHelper;
import ru.kubline.utils.EndingUtils;
import ru.kubline.utils.NumberUtils;

public class ChooseBayMoneyDialogTour extends ChooseBayMoneyDialogAbstract {

    public static const SELECTED_REALS:String = "selectedReals";
    public static const SELECTED_IN_GAME:String = "selectedInGame";

    private var reals:UISimpleButton;
    private var inGame:UISimpleButton;

    private var inGameOldText:TextField;
    private var realsOldText:TextField;

    private var inGameText:TextField;
    private var realsText:TextField;
    
    private var requerLevel:TextField;
    private var NonRequerLevel:TextField;

    private var discountText:TextField;

    private var moneyNeed:Price;


    public function ChooseBayMoneyDialogTour() {
        super(ClassLoader.getNewInstance(Classes.CHOOSE_MONEY_TOUR));
    }

    override protected function initComponent():void{
        super.initComponent();

        reals = new UISimpleButton(SimpleButton(getChildByName("reals")));
        reals.addHandler(onBayForReal);

        inGame = new UISimpleButton(SimpleButton(getChildByName("inGame")));
        inGame.addHandler(onBayForInGame);

        inGameText = TextField(getChildByName("inGameText"));
        realsText = TextField(getChildByName("realsText"));

        inGameOldText = TextField(getChildByName("inGameOldText"));
        realsOldText = TextField(getChildByName("realsOldText"));

        requerLevel = TextField(getChildByName("requerLevel"));
        NonRequerLevel = TextField(getChildByName("NonRequerLevel"));

        discountText = TextField(getChildByName("discountText"));


    }

    override public function destroy():void{

        super.destroy();
        
        inGame.removeHandler(onBayForInGame);
        reals.removeHandler(onBayForReal);

    }

    private function detectMinPlace(currentPlace:uint, comparePlace:uint):uint {
        currentPlace = (comparePlace < currentPlace && comparePlace != 0) ? comparePlace : currentPlace;
        return currentPlace;
    }

    override public function showMenu(item:Object):void{

        super.show();

      
        discountText.text = Math.round(Application.teamProfiler.getTourBonus()).toString() + "%";


        inGameText.text = NumberUtils.toNumberFormat(Math.floor(item.getPrice().price - item.getPrice().price * Application.teamProfiler.getTourBonus() / 100));
        realsText.text = NumberUtils.toNumberFormat(Math.floor(item.getPrice().realPrice - item.getPrice().realPrice * Application.teamProfiler.getTourBonus() / 100));

        inGameOldText.text = NumberUtils.toNumberFormat(item.getPrice().price);
        realsOldText.text = NumberUtils.toNumberFormat(item.getPrice().realPrice);

        moneyNeed = item.getPrice();

        if(item.getRequiredLevel() > Application.teamProfiler.getLevel()){
            requerLevel.visible = true;
            NonRequerLevel.visible = true;
            inGame.getContainer().mouseEnabled = false;
            requerLevel.htmlText = "Но " + EndingUtils.chooseEnding( item.getRequiredLevel(), "с", "с", "со") + ' <font color="#E40303">' + item.getRequiredLevel() + '-го</font> уровня';
        } else {
            requerLevel.visible = false;
            NonRequerLevel.visible = false;
            inGame.getContainer().mouseEnabled = true;
        }
 
    }

    private function onBayForInGame(e:Event):void {
        hide(); 
        if(UserProfileHelper.isEnoughMoney(Application.teamProfiler, new Price(Math.floor(moneyNeed.price - moneyNeed.price * Application.teamProfiler.getTourBonus() / 100), 0))){
             dispatchEvent(new Event(SELECTED_IN_GAME));
        } 
    }

    private function onBayForReal(e:Event):void {
        hide();
        if(UserProfileHelper.isEnoughMoney(Application.teamProfiler, new Price(0, Math.floor(moneyNeed.realPrice - moneyNeed.realPrice * Application.teamProfiler.getTourBonus() / 100)))){
             dispatchEvent(new Event(SELECTED_REALS));
        } 
    }

}
}