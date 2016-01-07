package ru.kubline.loader.resources {
import ru.kubline.display.AbstractItem;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.model.Price;

/**
 * Класс описывает тип здания
 *
 * @author lelka
 */
public class ItemResource {

    /**
     * уникальный идентификатор каждого типа элемента на сцене.(дорога, дерево, здание.
     */
    private var id:uint;

    /**
     * порядок элементов в магазине
     */
    private var order:uint;
 
    /**
     * прятать или нет данный тип в магазине
     */
    private var hideInShop:Boolean = new Boolean();

    /**
     * название
     */
    private var name:String;

    /**
     * описание
     */
    private var description:String;

    /**
     * класс мувика который будет рисоваться на сцене
     */
    private var displayClass:String; 

    /**
     * класс isoElement для отображения данного здания на сцене
     */
    private var itemClass:Class;

    private var itemXMLClass:String;

    /**
     * цена в магазине
     */
    private var price:Price;

    /**
     * Тип строительства
     */
    private var shopType:String;

    /**
     * Неаобходимый уровень для строительства
     */
    private var requiredLevel:uint;

    /**
     * дополнительные параметры для каждого здания
     */
    private var params:Object;

    public function getDescription():String {
        return description;
    }

    public function setDescription(value:String):void {
        description = value;
    }

    public function getName():String {
        return name;
    }

    public function setName(value:String):void {
        name = value;
    }

    public function getHideInShop():Boolean {
        return hideInShop;
    }

    public function setHideInShop(value:Boolean):void {
        hideInShop = value;
    }

    public function getParams():Object {
        return params;
    }

    public function setParams(value:Object):void {
        params = value;
    }

    public function ItemResource() {
    }

    public function getId():uint {
        return id;
    }

    public function setId(value:uint):void {
        id = value;
    }

    public function getDisplayClass():String {
        return displayClass;
    }

    public function setDisplayClass(value:String):void {
        displayClass = value;
    }
    
    public function getBuildingClass():Class {
        return  itemClass;
    }

    public function setBuildingClass(value:Class):void {
         itemClass = value;
    }

    public function getItemClass():String {
        return  itemXMLClass;
    }

    public function setItemClass(value:String):void {
         itemXMLClass = value;
    }

    public function getPrice():Price {
        return price;
    }

    public function setPrice(priceFreak:int, priceReal:int):void {
        price = new Price(priceFreak, priceReal);
    }
  
    public function getOrder():uint {
        return order;
    }

    public function setOrder(value:uint):void {
        order = value;
    }

    public function getShopType():String {
        return shopType;
    }

    public function setShopType(value:String):void {
        shopType = value;
    }

    public function getRequiredLevel():uint {
        return requiredLevel;
    }

    public function setRequiredLevel(value:uint):void {
        requiredLevel = value;
    }
 
    public function isAvailableToChoose():Boolean {
        return (!(getRequiredLevel() > Application.teamProfiler.getLevel()));
    }

    public function isAvailableToBuy():Boolean { 
        if(price.realPrice && Application.teamProfiler.getRealMoney() >= price.realPrice){
            return true;    
        }
        if(price.price && price.price <= Application.teamProfiler.getMoney()){
            return true;
        }
        return false;
    }

}
}