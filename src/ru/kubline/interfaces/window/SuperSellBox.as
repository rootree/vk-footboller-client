package ru.kubline.interfaces.window {
import flash.display.DisplayObject;
import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.text.TextField;

import flash.text.TextFieldAutoSize;

import ru.kubline.comon.Classes;
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.utils.InterfaceUtils;
import ru.kubline.loader.ClassLoader;

/**
 * Класс для отображения на экране диалогового сообщения
 */
public class SuperSellBox extends UIWindow {

    /**
     *  показать только одну кнопку Ok
     */
    public static const OK_BTN:int = 0;

    private static const OK_BTN_NAME:String = "ok";

    private static const CANCEL_BTN_NAME:String = "cancel";

    /**
     * показать 2 кнопки ok и cancel
     */
    public static const OK_CANCEL_BTN:int = 1;

    /**
     * не показывать ни одной кнопки
     */
    public static const BTN_NONE:int = 2;

    /**
     * заголовок у диалогового окна
     */
    private var titleField:TextField;

    /**
     * сообщение которое необходимо отобразить
     */
    private var messageField:TextField;


    private var callback:Function;

    private var buttons:Array = [];

    private var panel:MovieClip;
    /**
     * расстояние между кнопками
     */
    private var btnIndent:int = 15;

    /**
     * @param title заголовок у диалогового окна
     * @param message сообщение которое необходимо отобразить
     * @param buttons - BTN_OK или BTN_OK_CANCEL
     * @param callback функция в которую необходимо передать управление
     * после того как пользователь нажмет какую либо кнопку
     */
    public function SuperSellBox(title:String, message:String, buttons:int, callback:Function = null ) {
        
        super(ClassLoader.getNewInstance(Classes.SUPER_MESSAGE));

        titleField = TextField(getChildByName("title"));
        titleField.text = title;

        messageField = TextField(getChildByName("msg"));
        messageField.autoSize = TextFieldAutoSize.CENTER;
        messageField.htmlText = message;

        panel = MovieClip(getChildByName("panel"));
        this.callback = callback;

        setButtons([getChildByName(OK_BTN_NAME), getChildByName(CANCEL_BTN_NAME)]);
        if (buttons == OK_BTN) {
            getChildByName(OK_BTN_NAME).visible = true;
        } else if (buttons == OK_CANCEL_BTN) {
            getChildByName(OK_BTN_NAME).visible = true;
            getChildByName(CANCEL_BTN_NAME).visible = true;
        }
    }
 
    /**
     * массив кнопок(DrawingObject)
     * @param buttons
     * @return
     */
    public function setButtons(buttons:Array):void {
        this.buttons = buttons;
        for each (var button:DisplayObject in buttons) {
            button.visible = false;
            button.addEventListener(MouseEvent.CLICK, buttonClickHandler);
        }
    }



    protected function buttonClickHandler(event:MouseEvent):void {
        hide();
        if (callback != null && event.currentTarget.name == OK_BTN_NAME) {
            callback();
        }
    }

    /**
     * удаляет себя из парента и свои листнеры
     * @return
     */
    override public function destroy():void {
        for (var i:int; i < buttons.length; i++) {
            buttons[i].removeEventListener(MouseEvent.CLICK, this.buttonClickHandler);
        }
        super.destroy();
    }
}
}