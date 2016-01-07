package ru.kubline.controllers {
import flash.display.MovieClip;

import flash.events.Event;
 
import ru.kubline.comon.Classes;
import ru.kubline.gui.events.UIEvent;
import ru.kubline.interfaces.menu.shop.ShopMenu;
import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.ItemTypeStore;

public class ShopController {

    /**
     * Полноценный магазин
     */
    private var shopPanel:ShopMenu;

    public function ShopController() {
        this.shopPanel = new ShopMenu(ClassLoader.getNewInstance(Classes.PANEL_SHOP));
    }

    private function initMenu(shopType:String):void { 
      //  shopPanel.redrawMainShop(shopType); 
    }

    /**
     * Показать магазин с определенным набором товара
     * @param shopType Тип товара
     */
    public function showShopMenu(shopType:String):void {
        initMenu(shopType);
        shopPanel.show();
    }

    /**
     * Показать магазин с определенным набором товара
     * @param shopType Тип товара
     */
    public function hideShopMenu():void {
        shopPanel.hide();
    }

    public function updateMoney():void {
        shopPanel.updateMoney()
    }
}
}