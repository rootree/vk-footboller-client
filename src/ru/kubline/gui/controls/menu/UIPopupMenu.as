package ru.kubline.gui.controls.menu {
import ru.kubline.gui.core.UIClasses;
import ru.kubline.gui.utils.InterfaceUtils;

import flash.display.MovieClip;
import flash.display.Sprite;
import flash.events.MouseEvent;

import ru.kubline.gui.controls.UIComponent;
import ru.kubline.loader.ClassLoader;

/**
 * контекстное меню
 */
public class UIPopupMenu extends UIComponent {

    /**
     * панель подложки
     */
    private var panel:MovieClip;

    /**
     * отступ от содержимого по вертикали
     */
    private static const h_offset:int = 10;

    /**
     * отступ от содержимого по горизонтали
     */
    private static const w_offset:int = 15;

    private var items:Array = [];

    public function UIPopupMenu() {
        super(new Sprite());
        container.addChild(panel = ClassLoader.getNewInstance(UIClasses.HINT_PANEL));
        panel.width = 100;
        panel.height = h_offset;
    }

    /**
     * добавить пункт меню
     * @param item
     */
    public function addItem(item:UIPopupMenuItem):void {
        item.getContainer().x = w_offset;
        container.addChild(item.getContainer());
        if (panel.width < 2 * w_offset + item.getContainer().width) {
            panel.width = 2 * w_offset + item.getContainer().width;
        }

        var last:UIPopupMenuItem = items.length ? items[items.length - 1] : null;
        if (last) {
            InterfaceUtils.distributeUnder(item.getContainer(), last.getContainer());
        } else {
            item.getContainer().y = h_offset;
        }

        panel.height = item.getContainer().y + item.getContainer().height + h_offset;

        item.setMenu(this);
        items.push(item);
    }

    /**
     * показать меню в координатах (x, y)
     * @param x
     * @param y
     */
    public function showAt(x:int, y:int):void {
        if (x + container.width >= Application.stageWidth) {
            container.x = Application.stageWidth - container.width - 5;
        } else {
            container.x = x - 5;
        }

        if (y + container.height >= Application.stageHeight) {
            container.y = Application.stageHeight - container.height - 5;
        } else {
            container.y = y - 5;
        }

        Application.instance.addChild(container);
        container.addEventListener(MouseEvent.ROLL_OUT, onRollOut);
    }

    public function hide():void {
        container.removeEventListener(MouseEvent.ROLL_OUT, onRollOut);
        Application.instance.removeChild(container);
    }

    private function onRollOut(e:MouseEvent):void {
        hide();
    }
}
}