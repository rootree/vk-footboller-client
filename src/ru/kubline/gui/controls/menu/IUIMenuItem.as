package ru.kubline.gui.controls.menu {
import ru.kubline.gui.controls.IUIComponent;

/**
 * интерфейс ячейки меню
 */
public interface IUIMenuItem extends IUIComponent {

    function setItem(value:Object):void;

    function getItem():Object;

    function setSelected(selected:Boolean):void;

    function isSelected():Boolean;

    function setSelectable(value:Boolean):void;

    function isSelectable():Boolean;
}
}