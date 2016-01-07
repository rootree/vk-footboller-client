package ru.kubline.gui.controls.button {

import flash.display.SimpleButton;
import flash.errors.IllegalOperationError;
import flash.events.EventDispatcher;
import flash.events.MouseEvent;

import ru.kubline.gui.controls.Qtip;
import ru.kubline.gui.controls.hint.Hintable;

/**
 * кнопка на основе SimpleButton
 */
public class UISimpleButton extends EventDispatcher implements IUIButton {

    /**
     * html текст для подсказки
     */
    private var qtip:String;

    private var qtipHintable:Hintable;

    private var btn:SimpleButton;

    public function UISimpleButton(btn:SimpleButton) {
        this.btn = btn;

        btn.tabEnabled = false;
    }

    public function addHandler(handler:Function):void {
        this.btn.addEventListener(MouseEvent.CLICK, handler);
    }

    public function removeHandler(handler:Function):void {
        this.btn.addEventListener(MouseEvent.CLICK, handler);
    }

    public function setDisabled(disabled:Boolean):void {
        this.btn.mouseEnabled = !disabled;
    }

    public function isDisabled():Boolean {
        return !this.btn.mouseEnabled;
    }

    public function getName():String {
        return this.btn.name;
    }

    public function getContainer():SimpleButton {
        return btn;
    }

    public function setVisible(visible:Boolean):void {
        btn.visible = visible;
    }

    public function destroy():void {
    }

    public function isVisible():Boolean {
        return btn.visible;
    }

    public function setQtip(value:String):void {
        qtip = value;
        if (!qtipHintable) {
            qtipHintable = new Hintable(this.getContainer());
        } else {
            qtipHintable.removeHintProvider();
        }
        if (qtip) {
            qtipHintable.setHintProvider(new Qtip(qtip));
        }

    }
}
}