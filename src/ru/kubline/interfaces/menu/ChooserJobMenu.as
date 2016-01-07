package ru.kubline.interfaces.menu {
import flash.display.MovieClip;

import flash.display.SimpleButton;

import flash.events.Event;

import ru.kubline.comon.Classes;
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.model.Footballer;
import ru.kubline.utils.ItemUtils;

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 1:24:12 PM
 */

public class ChooserJobMenu extends UIWindow {

    public static const CHOOSED_JOB:String = "ChoosedJob";

    private var ForwardBtn:UISimpleButton;
    private var SaferBtn:UISimpleButton;
    private var GoalKeeper:UISimpleButton;
    private var HalfSaferBtn:UISimpleButton;
    
    private var footballer:Footballer;

    public function ChooserJobMenu(footballer:Footballer) { 
        this.footballer = footballer;
        super(ClassLoader.getNewInstance(Classes.CHOOSER_JOB));
    }

    override protected function initComponent():void{
        super.initComponent();

        ForwardBtn = new UISimpleButton(SimpleButton(getChildByName("ForwardBtn")));
        ForwardBtn.addHandler(onForwardBtn);

        SaferBtn = new UISimpleButton(SimpleButton(getChildByName("SaferBtn")));
        SaferBtn.addHandler(onSaferBtn);

        GoalKeeper = new UISimpleButton(SimpleButton(getChildByName("GoalKeeper")));
        GoalKeeper.addHandler(onGoalKeeper);

        HalfSaferBtn = new UISimpleButton(SimpleButton(getChildByName("HalfSaferBtn")));
        HalfSaferBtn.addHandler(onHalfSaferBtn);

    }

    override public function destroy():void{ 
        ForwardBtn.removeHandler(onForwardBtn);
        SaferBtn.removeHandler(onSaferBtn);
        GoalKeeper.removeHandler(onGoalKeeper);
        HalfSaferBtn.removeHandler(onHalfSaferBtn);
        super.destroy();
    }

    private function onForwardBtn(e:Event):void {
        myChooseIs(ItemTypeStore.TYPE_FORWARD);
    }

    private function onSaferBtn(e:Event):void {
        myChooseIs(ItemTypeStore.TYPE_SAFER);
    }

    private function onGoalKeeper(e:Event):void {
        myChooseIs(ItemTypeStore.TYPE_GOALKEEPER);
    }

    private function onHalfSaferBtn(e:Event):void {
        myChooseIs(ItemTypeStore.TYPE_HALFSAFER);
    }

    private function myChooseIs(choose:String):void {
        footballer.setType(ItemUtils.converStringTypeToInt(choose).toString()); 
        super.hide();
        dispatchEvent(new Event(ChooserJobMenu.CHOOSED_JOB));
    } 
}
}