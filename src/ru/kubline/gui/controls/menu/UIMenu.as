package ru.kubline.gui.controls.menu {
import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;
import flash.errors.IllegalOperationError;
import flash.events.Event;
 
import ru.kubline.gui.controls.UIWindow;
import ru.kubline.gui.events.UIEvent;

/**
 * базвой класс одностраничной менюшки с ячейками(типа магазин, арена...)
 *
 * конечный класс должен определить метод createCell - который возвращает инстанс ячейки
 */
public class UIMenu extends UIWindow {

    /**
     * имя мувика который содержит только ячейки меню
     */
    private static const CELLS_CONTAINER_NAME:String = "cells";

    /**
     * текущая выбранная ячейка
     */
    protected var selectedItem:IUIMenuItem;

    /**
     * array of IUIMenuItem
     */
    protected var cells:Array;

    /**
     * мувик который содержит только ячейки меню
     */
    protected var cellsContainer:DisplayObjectContainer;

    public function UIMenu(container:MovieClip) {
        super(container);
        destroyOnRemove = false;
        initCells();
    }

    private function initCells():void {
        cellsContainer = getCellsContainer();
        cells = [];

        var num:int = cellsContainer.numChildren;
        for (var i:int; i < num; i++) {
            var menuItem:IUIMenuItem = createCell(cellsContainer.getChildAt(i));
            cells.push(menuItem);
            menuItem.addEventListener(UIEvent.MENU_ITEM_SELECT, onItemSelect);
        }
    }

    protected function getCellsContainer():DisplayObjectContainer {
        return DisplayObjectContainer(getChildByName(CELLS_CONTAINER_NAME));
    }

    /**
     *  возвращает инстанс ячейки
     * @param cell - мувик ячейки
     * @return
     */
    protected function createCell(cell:DisplayObject):IUIMenuItem {
        throw new IllegalOperationError("try to call abstract method");
    }

    /**
     * возвращает данные из выбранной ячейки, null если ничего не выбранно
     */
    public function getSelected():Object {
        if (selectedItem) {
            return selectedItem.getItem();
        }
        return null;
    }

    /**
     * @return вернет выбраную ячейку меню а не данные из выбранной ячейки
     */
    public function getSelectedMenuItem():IUIMenuItem {
      if (selectedItem) {
            return selectedItem;
        }
        return null;
    }

    private function onItemSelect(event:Event):void {
        var newSelection:IUIMenuItem = IUIMenuItem(event.target);
        setSelectedItem(newSelection);
    }

    /**
     * отменить выделение всех ячеек
     */
    protected function clearSelection():void {
        if (selectedItem) {
            selectedItem.setSelected(false);
        }
        selectedItem = null;
    }

    /**
     * установить выделение элемента
     * @param newSelection
     */
    protected function setSelectedItem(newSelection:IUIMenuItem):void {
        if (newSelection != selectedItem) {
            if (selectedItem) {
                selectedItem.setSelected(false);
            }
            selectedItem = newSelection;
        }

        if (!newSelection.isSelected()) {
            newSelection.setSelected(true);
        }
    }


    override public function destroy():void {
        selectedItem = null;
        cellsContainer = null;

        for each (var item:IUIMenuItem in cells) {
            item.removeEventListener(UIEvent.MENU_ITEM_SELECT, onItemSelect);
            item.destroy();
        }

        super.destroy();
    }
}
}