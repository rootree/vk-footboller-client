package ru.kubline.interfaces.menu.shop.teams {
import flash.display.DisplayObject;
import flash.display.MovieClip;

import flash.events.Event;

import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.controls.menu.UIPagingMenu;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;

/**
 * Работа с главным магазином
 */
public class TeamPanel extends UIPagingMenu  {
 
    public function TeamPanel(container:MovieClip) { 
        super(container);
        getSelected();
    }

    public function redraw(cupId:uint):void {
        
        var data:Array;
        data = ItemTypeStore.getStoreByGlobalType(ItemTypeStore.TYPE_LOGO_TEAM);

        var shopItems:Array = new Array();
        for (var i:uint = 0; i < data.length; i++) { 
            if(cupId == data[i].getParams().cup ){
                shopItems.push(data[i]);;
            }
        } 
        setData(shopItems);
        setPage(1); 
    }
 
    /**
     * Заполняем магазин
     * @param cell
     * @return
     */
    override protected function createCell(cell:DisplayObject):IUIMenuItem {
        var shopItem:TeamsItem = new TeamsItem(MovieClip(cell));
        shopItem.addEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick);
        return shopItem;
    }


    /**
     * Действие при шелчке по элементу магазина
     * @param e
     */
    private function onItemClick(e:Event):void { 
        var item:UIMenuItem = UIMenuItem(e.target);
        if(item.getItem() is ItemResource){ 
            var itemRecord:ItemResource = ItemResource(item.getItem()); 
            var event:TeamSelectedEvent = new TeamSelectedEvent(itemRecord);
            dispatchEvent(event); 
        }
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