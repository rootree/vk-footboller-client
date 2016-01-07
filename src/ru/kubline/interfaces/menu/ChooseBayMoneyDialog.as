package ru.kubline.interfaces.menu {
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

public class ChooseBayMoneyDialog extends ChooseBayMoneyDialogAbstract {

    public static const SELECTED_REALS:String = "selectedReals";
    public static const SELECTED_IN_GAME:String = "selectedInGame";

    private var reals:UISimpleButton;
    private var inGame:UISimpleButton;

    private var inGameText:TextField;
    private var realsText:TextField;
    
    private var requerLevel:TextField;
    private var NonRequerLevel:TextField;

    private var moneyNeed:Price;
 

    public function ChooseBayMoneyDialog() {
        super(ClassLoader.getNewInstance(Classes.CHOOSE_MONEY));
    }

    override protected function initComponent():void{
        super.initComponent();

        reals = new UISimpleButton(SimpleButton(getChildByName("reals")));
        reals.addHandler(onBayForReal);

        inGame = new UISimpleButton(SimpleButton(getChildByName("inGame")));
        inGame.addHandler(onBayForInGame);

        inGameText = TextField(getChildByName("inGameText"));
        realsText = TextField(getChildByName("realsText"));

        requerLevel = TextField(getChildByName("requerLevel"));
        NonRequerLevel = TextField(getChildByName("NonRequerLevel"));

    }

    override public function destroy():void{

        super.destroy();
        
        inGame.removeHandler(onBayForInGame);
        reals.removeHandler(onBayForReal);

    }

    override public function showMenu(item:Object):void{

        super.show();

        inGameText.text = NumberUtils.toNumberFormat(item.getPrice().price);
        realsText.text = NumberUtils.toNumberFormat(item.getPrice().realPrice);

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
        if(UserProfileHelper.isEnoughMoney(Application.teamProfiler, new Price(moneyNeed.price, 0))){
             dispatchEvent(new Event(SELECTED_IN_GAME));
        } 
    }

    private function onBayForReal(e:Event):void {
        hide();
        if(UserProfileHelper.isEnoughMoney(Application.teamProfiler, new Price(0, moneyNeed.realPrice))){
             dispatchEvent(new Event(SELECTED_REALS));
        } 
    }

}
}