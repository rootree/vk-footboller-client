package ru.kubline.controllers {

/**
 * Описание
 *
 * User: Ivan Chura
 * Date: Apr 25, 2010
 * Time: 2:03:42 PM
 */

public class Statistics {

    public static const MAIN_MENU_USER_TEAM:String = "UT";
    public static const MAIN_MENU_SHOP:String = "SH";
    public static const MAIN_MENU_SPONSORS:String = "SP";
    public static const MAIN_MENU_MATCH:String = "MT";

    public static const SHOP_ACTION_CLICK:String = "clk";
    public static const SHOP_ACTION_HOVER:String = "hvr";

    private var shopItems:Object;

    private var mainMenu:Object;

    public function Statistics() {
        shopItems = new Object();
        mainMenu = new Object();
    }

    public function increaseShopItem(item:uint, type:String):void{
        if(!shopItems[item]){
            shopItems[item] = new Object();
            shopItems[item][SHOP_ACTION_CLICK] = 0;
            shopItems[item][SHOP_ACTION_HOVER] = 0;
        }
        shopItems[item][type] ++;
    }

    public function increaseMainMenu(what:String):void{
        if(!mainMenu[what]){
            mainMenu[what] = 1;
        }else{
            mainMenu[what] ++;
        }
    }

    public function reset():void{
        shopItems = new Object();
        mainMenu = new Object();
    }

    public function getJSON():Object{
        var forResponce:Object = new Object();

        forResponce = {
            shopItems: shopItems,
            mainMenu: mainMenu
        };
        return forResponce;
    }
}
}