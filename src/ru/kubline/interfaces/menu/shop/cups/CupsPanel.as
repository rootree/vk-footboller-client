package ru.kubline.interfaces.menu.shop.cups {
import ru.kubline.interfaces.menu.shop.*;
import ru.kubline.interfaces.menu.*;

import com.greensock.TweenMax;

import com.greensock.easing.Expo;

import flash.display.DisplayObject;
import flash.display.DisplayObjectContainer;
import flash.display.MovieClip;

import flash.display.SimpleButton;
import flash.events.Event;

import flash.events.IOErrorEvent;
import flash.events.MouseEvent;
import flash.text.TextField;


import ru.kubline.comon.Colors;
import ru.kubline.controllers.Singletons;
import ru.kubline.controllers.Statistics;
import ru.kubline.gui.controls.QuantityPanel;
import ru.kubline.gui.controls.UIComponent;
import ru.kubline.gui.controls.button.UIButton;
import ru.kubline.gui.controls.button.UISimpleButton;
import ru.kubline.gui.controls.menu.IUIMenuItem;
import ru.kubline.gui.controls.menu.UIMenuItem;
import ru.kubline.gui.controls.menu.UIPagingMenu;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.interfaces.PriceContainer;
import ru.kubline.interfaces.UserPanel;
import ru.kubline.interfaces.game.UIPriceContainer;
import ru.kubline.interfaces.menu.friends.FriendProfilesStore;
import ru.kubline.interfaces.window.message.MessageBox;
import ru.kubline.loader.Gallery;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;
import ru.kubline.model.Footballer;
import ru.kubline.model.MoneyType;
import ru.kubline.model.Price;
import ru.kubline.model.TeamProfiler;
import ru.kubline.model.Trainer;
import ru.kubline.model.UserProfileHelper;
import ru.kubline.net.HTTPConnection;
import ru.kubline.utils.ItemUtils;

/**
 * Работа с главным магазином
 */
public class CupsPanel extends UIPagingMenu  {

    public function CupsPanel(container:MovieClip) {
        super(container);
        getSelected();
    }
 
    public function redraw():void {
        var data:Array;
        data = ItemTypeStore.getStoreByGlobalType(ItemTypeStore.TYPE_CUPS);
        setData(data);
        setPage(1);
    }
 
    /**
     * Заполняем магазин
     * @param cell
     * @return
     */
    override protected function createCell(cell:DisplayObject):IUIMenuItem {
        var shopItem:CupsItem = new CupsItem(MovieClip(cell));
        shopItem.addEventListener(UIEvent.MENU_ITEM_CLICK, onItemClick);
        return shopItem;
    }

    private function onItemClick(e:Event):void {
        var item:UIMenuItem = UIMenuItem(e.target);
        if(item.getItem() is ItemResource){
            var itemRecord:ItemResource = ItemResource(item.getItem());
            var event:CupSelectedEvent = new CupSelectedEvent(itemRecord);
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