package ru.kubline.gui.controls.menu {
import flash.display.Sprite;
import flash.events.MouseEvent;
import flash.filters.GlowFilter;
import flash.text.TextField;

import flash.text.TextFieldAutoSize;
import flash.text.TextFormat;

import ru.kubline.gui.controls.UIComponent;

/**
 *
 * пункт контекстного меню
 */
public class UIPopupMenuItem extends UIComponent {

    private var text:TextField;
    private var textOver:TextField;
    private var handler:Function;
    private var menu:UIPopupMenu;

    public function UIPopupMenuItem(text:String, textFormat:TextFormat, handler:Function) {
        super(new Sprite());

        this.handler = handler;
        this.text = createTextField(text, textFormat);
        this.textOver = createTextField(text, textFormat);

        this.textOver.filters = [new GlowFilter(0xFFFF99)];
        this.container.addEventListener(MouseEvent.MOUSE_OVER, onMouseOver);
        this.container.addEventListener(MouseEvent.MOUSE_OUT, onMouseOut);
        this.container.addEventListener(MouseEvent.CLICK, onClick);

        container.addChild(this.text);
    }

    /**
     * меню которому принадлежит
     * @param value
     */
    public function setMenu(value:UIPopupMenu):void {
        menu = value;
    }

    private function createEmptyTextField(textFormat:TextFormat = null, filters:Array = null):TextField {
        var textField:TextField = new TextField();
        textField.autoSize = TextFieldAutoSize.LEFT;
        if (textFormat) {
            textField.defaultTextFormat = textFormat;
        }
        if (filters) {
            textField.filters = filters;
        }
        textField.selectable = false;
        textField.mouseEnabled = false;
        return textField;
    }

    private function createTextField(text:String, textFormat:TextFormat = null, filters:Array = null):TextField {
        var textField:TextField = createEmptyTextField(textFormat, filters);
        textField.text = text;
        return textField;
    }


    private function onClick(event:MouseEvent):void {
        menu.hide();
        handler();
    }

    private function onMouseOut(event:MouseEvent):void {
        container.removeChild(textOver);
        container.addChild(text);
    }

    private function onMouseOver(event:MouseEvent):void {
        container.removeChild(text);
        container.addChild(textOver);
    }

}
}