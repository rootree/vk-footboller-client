package ru.kubline.gui.controls.button {
import flash.display.MovieClip;
import flash.display.SimpleButton;
import flash.events.MouseEvent;

import ru.kubline.gui.controls.UIComponent;

/**
 * кнопка на основе MovieClip. обычно в нем есть мувик который дизаблит кнопку
 */
public class UIButton extends UIComponent implements IUIButton {

    private var btn:SimpleButton;

    public function UIButton(container:MovieClip) {
        super(container);
        btn = SimpleButton(container.btn);
        btn.tabEnabled = false;
    }

    public function addHandler(handler:Function):void {
        this.btn.addEventListener(MouseEvent.CLICK, handler);
    }

    public function removeHandler(handler:Function):void {
        this.btn.addEventListener(MouseEvent.CLICK, handler);
    }
}
}