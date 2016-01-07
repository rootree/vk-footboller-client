package ru.kubline.interfaces.window.message {
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
public class MessageBox extends UIWindow {

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

    private var padding_h:int = 25;

    private var padding_v:int = 0;

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
    public function MessageBox(title:String, message:String, buttons:int, callback:Function = null, msgClass:String = Classes.MSG_BOX) {
        
        super(ClassLoader.getNewInstance(msgClass));

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

    override protected function initComponent():void {
        var buttonsLine:Sprite = initButtons();
        _addChild(buttonsLine);
        InterfaceUtils.distributeUnder(buttonsLine, messageField, 13);
        panel.height = buttonsLine.y + buttonsLine.height + padding_v;
        buttonsLine.x = (panel.width - buttonsLine.width) / 2;
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

    /**
     *  кнопки в нижней части окна, выравниваются по центру
     *  на заданном расстоянии друг от друга.
     */
    protected function initButtons():Sprite {
        var buttonsLine:Sprite = new Sprite();
        var i:int = 0;
        for each(var button:DisplayObject in buttons) {
            if (button.visible) {
                if (i > 0) {
                    button.x = buttonsLine.width + btnIndent;
                } else {
                    button.x = 0;
                }
                button.y = 0;
                buttonsLine.addChild(button);

                i++;
            }
        }
        return buttonsLine;
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