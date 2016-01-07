package ru.kubline.interfaces {

import com.greensock.TweenLite;
import com.greensock.TweenMax;

import com.greensock.easing.Elastic;

import flash.display.SimpleButton;

import flash.events.Event;

import flash.events.MouseEvent;

import flash.geom.Point;

import ru.kubline.comon.Classes;
import ru.kubline.gui.controls.UIComponent;
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.interfaces.battle.TourIIIPrepare;
import ru.kubline.interfaces.battle.TourIIIWindow;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.tour.TourNotifyType;

public class Championnats extends UIWindow {

    private var enterFree:UISimpleButton;
    private var enterForReal:UISimpleButton;
    private var enterForVioce:UISimpleButton;

    private var closeBtn:UISimpleButton;

    private var selectionGame:SelectionChamp;
    private var tuerIIIstarted:TourIIIPrepare;
    private var tuerIIIprepare:TourIIIWindow;

    public function Championnats() {
        super(ClassLoader.getNewInstance(Classes.PANEL_CHAMPIONNAS));
    }

    override protected function initComponent():void{

        super.initComponent();

        closeBtn = new UISimpleButton(SimpleButton(getChildByName("closeBtn")));
        closeBtn.addHandler(onCloseClick);

        enterFree = new UISimpleButton(SimpleButton(getChildByName("enterFree")));
        enterFree.addHandler(onFreeClick);
        enterFree.getContainer().addEventListener(MouseEvent.MOUSE_OVER, onHigthLight);
        enterFree.getContainer().addEventListener(MouseEvent.MOUSE_OUT, unHightLight);

        enterForReal = new UISimpleButton(SimpleButton(getChildByName("enterForReal")));
        enterForReal.addHandler(onRealClick);
        enterForReal.getContainer().addEventListener(MouseEvent.MOUSE_OVER, onHigthLight);
        enterForReal.getContainer().addEventListener(MouseEvent.MOUSE_OUT, unHightLight);

        enterForVioce = new UISimpleButton(SimpleButton(getChildByName("enterForVioce")));
        enterForVioce.addHandler(onVoiceClick);
        enterForVioce.getContainer().addEventListener(MouseEvent.MOUSE_OVER, onHigthLight);
        enterForVioce.getContainer().addEventListener(MouseEvent.MOUSE_OUT, unHightLight);

    }

    override public function destroy():void{

        super.destroy();

        closeBtn.removeHandler(onCloseClick);
        enterFree.removeHandler(onFreeClick);
        enterForReal.removeHandler(onRealClick);
        enterForVioce.removeHandler(onVoiceClick);

    }

    override public function show():void{
        super.show();
    }

    private function onHigthLight(event:MouseEvent):void {
        higthLight(event.target);
    }

    private function higthLight(bnt:Object):void {
        getContainer().setChildIndex(SimpleButton(bnt), getContainer().numChildren - 1);
        TweenMax.to(bnt, 0.25, {glowFilter:{color:0xffffff, alpha:1, blurX:15, blurY:15}});
    }

    private function unHightLight(event:MouseEvent):void {
        tweenerOff(enterForVioce.getContainer());
        tweenerOff(enterForReal.getContainer());
        tweenerOff(enterFree.getContainer());
    }

    private function tweenerOff(bnt:Object):void {
        getContainer().setChildIndex(SimpleButton(bnt), 1);
        SimpleButton(bnt).filters = [];
        TweenMax.killTweensOf(bnt);
    }

    private function onVoiceClick(e:Event):void{ 
        showTour();
        hide();
    }

    public function showTour():void{
        if(Application.teamProfiler.getTourNotify() == TourNotifyType.TOUR_NOTIFY_NEW || Application.teamProfiler.getTourNotify() == TourNotifyType.TOUR_NOTIFY_NEW_NOTIFIED){
            if(!tuerIIIprepare){
                tuerIIIprepare = new TourIIIWindow();
            }
            tuerIIIprepare.show();
        }else{
            if(!tuerIIIstarted){
                tuerIIIstarted = new TourIIIPrepare();
            }
            tuerIIIstarted.show();
        }
    }

    private function onRealClick(e:Event):void{
        var msgBox:MessageBox = new MessageBox("В разработке", "Соревнования с существующимим командами будет доступна в полной версии игры", MessageBox.OK_BTN);
        msgBox.show();
        hide();
    }

    private function onFreeClick(e:Event):void{

        if(Application.teamProfiler.getEnergy() >= 16){
            selectionGame = new SelectionChamp();
            selectionGame.show();
            hide();
        }else{
            var msgBox:MessageBox = new MessageBox("Сообщение", "К сожалению, запас сил вашей команды иссяк, ей надо отдохнуть", MessageBox.OK_BTN);
            msgBox.show();
        }

    }

    public function getSelectionGame():SelectionChamp{
        if(selectionGame){
            selectionGame = new SelectionChamp();
            selectionGame.show();
        }
        return selectionGame;
    }

    public function getTourIIIStarted():TourIIIPrepare{
        return tuerIIIstarted;
    }


}
}