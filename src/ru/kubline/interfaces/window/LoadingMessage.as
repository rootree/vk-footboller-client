package ru.kubline.interfaces.window {
import com.greensock.TweenMax;

import com.greensock.easing.Back;

import com.greensock.easing.Bounce;

import com.greensock.easing.Expo;

import flash.display.MovieClip;
import flash.display.Sprite;

import flash.events.Event;

import flash.events.TimerEvent;
import flash.text.TextField;

import flash.utils.Timer;

import ru.kubline.comon.Classes;
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.loader.ClassLoader;


public class LoadingMessage extends UIWindow {

    private var messageSRV:TextField;
    private var bol:MovieClip;
    private var panel:MovieClip;

    private var messageTimer:Timer;

    public function LoadingMessage() {

        super(ClassLoader.getNewInstance(Classes.LOADING_MSG));
        messageSRV = TextField(container.getChildByName("loadingMessage"));
        bol = MovieClip(container.getChildByName("bol"));
        panel = MovieClip(container.getChildByName("panel"));
        //message.mouseEnabled = false;

        messageTimer = new Timer(1000, 1);
        messageTimer.addEventListener(TimerEvent.TIMER, function():void {
            messageTimer.reset();
            messageTimer.stop();
            hide();
        });


    }

    public function start(loadingMessage:String):void{
        messageSRV.text = loadingMessage;
        panel.width =  Math.round(loadingMessage.length * 9 + 210);
        if(!shown){
            show();
        }
    }

    private function getXStart():uint{
        return Application.stageWidth - panel.width + 150;
    }

    /**
     * открыть окно
     */
    override public function show():void {
        turnBall(true);
        shown = true;
        if (!bgPanel) {
            bgPanel = new Sprite();
            bgPanel.graphics.beginFill(0x999999, 0);
            bgPanel.graphics.drawRect(0, 0, Application.stageWidth, Application.stageHeight);
        }

        this.getContainer().y = 530;
        this.getContainer().x = getXStart();

         TweenMax.from(this.getContainer(), 1.5, {

            alpha:0,
            bezierThrough:[{x:775}], orientToBezier:true, ease:Expo.easeOut}

        );

        Application.instance.addChild(bgPanel);
        getContainer().x = Application.stageWidth - getContainer().width;
        getContainer().y = Application.stageHeight - getContainer().height;
        Application.instance.addChild(getContainer());
        dispatchEvent(new Event(UIEvent.WINDOW_SHOW));
    }

    /**
     * закрыть
     */
    override public function hide():void {
        shown = false;
        if (bgPanel != null && Application.instance.contains(bgPanel)) {
            Application.instance.removeChild(bgPanel);
        }

         TweenMax.to(this.getContainer(), 1, {alpha:0, onComplete: hideByTweener,
         bezierThrough:[{x:775}], orientToBezier:true, ease:Back.easeIn
        });
    }


    public function delayHide(loadingMessage:String):void{
        turnBall(false);
        messageSRV.text = loadingMessage;
        messageTimer.start();
    }

    private function turnBall(isTurnOn:Boolean):void{
        if(isTurnOn) {
            MovieClip(bol.getChildAt(0)).play()
        } else {
            MovieClip(bol.getChildAt(0)).stop();
        }
    }

}
}