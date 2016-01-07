package ru.kubline.gui.controls.menu {
import flash.display.MovieClip;
import flash.events.Event;
import flash.events.MouseEvent;

import flash.utils.getTimer;

import ru.kubline.controllers.Singletons;
import ru.kubline.controllers.SoundController;
import ru.kubline.gui.controls.UIComponent;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.utils.MCUtils;

/**
 * базовый класс ячейки меню
 */
public class UIMenuItem extends UIComponent implements IUIMenuItem {

    protected var item:Object = null;

    protected var selected:Boolean;

    private var selection:MovieClip;

    private var lastclick:Number = 0;

    protected var selectable:Boolean = true;

    public function UIMenuItem(container:MovieClip) {
        super(container);
        container.doubleClickEnabled = true   ;
        destroyOnRemove = false;
        this.selection = MovieClip(container.getChildByName("selection"));
        if (selection) {
            setSelected(false);
            MCUtils.enableMouser(MovieClip(container));
        } else {
            selectable = false;
        }
    }

    public function setItem(value:Object):void {
        item = value;
    }

    override protected function initComponent():void {
        container.addEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        container.addEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        container.addEventListener(MouseEvent.CLICK, this.onMouseClick);
        if (selectable) {
            setSelected(selected);
        }
    }

    public function getItem():Object {
        return item;
    }

    private function onMouseOver(event:MouseEvent):void {
        if (!disabled && selectable) {
            highlight(true);
            Singletons.sound.play(SoundController.PLAY_MENU_OVER);
        }
    }

    private function onMouseOut(event:MouseEvent):void {
        if (!selected) {
            highlight(false);
        }
    }

    protected function onMouseClick(event:MouseEvent):void {

        var test:Number = lastclick - (lastclick=getTimer()) + 500;
        if(test > 0){
            this.dispatchEvent(new Event(UIEvent.MENU_ITEM_DOUBLE_CLICK));
        } else {
            this.dispatchEvent(new Event(UIEvent.MENU_ITEM_CLICK));
        }

        prepareToClick();
    }



    private function prepareToClick():void {

        if (!disabled && selectable) {
            if (!selected) {
                this.dispatchEvent(new Event(UIEvent.MENU_ITEM_SELECT));
            }
            setSelected(true);
            Singletons.sound.play(SoundController.PLAY_MENU_ENTER);
        }
    }

    /**
     * подсвечивает ячейку(при наведении/выборе)
     */
    private function highlight(highlight:Boolean):void {
        if (selection) {
            selection.visible = highlight;
        }
    }

    public function setSelected(selected:Boolean):void {
        this.selected = selected;
        highlight(selected);
    }

    public function isSelected():Boolean {
        return selected;
    }

    public function setSelectable(value:Boolean):void {
        selectable = value;
    }

    public function isSelectable():Boolean {
        return selectable;
    }

    override public function destroy():void {
        getContainer().removeEventListener(MouseEvent.MOUSE_OVER, this.onMouseOver);
        getContainer().removeEventListener(MouseEvent.MOUSE_OUT, this.onMouseOut);
        getContainer().removeEventListener(MouseEvent.CLICK, this.onMouseClick);
        item = null;
        super.destroy();
    }
}
}