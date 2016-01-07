package ru.kubline.interfaces.game {
import flash.display.Sprite;
import flash.text.TextField;

import flash.text.TextFieldAutoSize;

import ru.kubline.gui.controls.UIComponent;

public class UIMoney extends UIComponent{

    private var value:TextField;

    public function UIMoney(container:Sprite):void {
        super(container);
        value = TextField(container.getChildByName("value"));
        value.autoSize = TextFieldAutoSize.RIGHT;
    }

    public function setValue(value:int):void {
        this.value.text = value.toString();
    }
}
}