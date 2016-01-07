package ru.kubline.interfaces.battle.groups {
import ru.kubline.interfaces.battle.groups.*;

import flash.display.DisplayObject;
import flash.display.MovieClip; 
import ru.kubline.comon.Classes;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIPagingMenu;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.store.TourIIIStore;

public class GroupsList extends UIPagingMenu  {
 
    public function GroupsList(container:MovieClip) {
        super(container);
    }

    /**
     * Заполняем магазин
     * @param cell
     * @return
     */
    override protected function createCell(cell:DisplayObject):IUIMenuItem {
        var shopItem:GroupsItem = new GroupsItem(MovieClip(cell)); 
        return shopItem;
    }

    public function initStore(tourType:uint):void {
        var data:Array;
        data = TourIIIStore.getStoreByType(tourType);
        setData(data);
        setPage(1);
    }

    /**
     * Если хотим чтобы в магазине не отображались пустые клеточки
     * @param cell
     * @param item
     */
    override protected function initCell(cell:IUIMenuItem, item:Object):void {
        if (item) {
            super.initCell(cell, item);
        }
        cell.setVisible(item != null);
    }

}
}