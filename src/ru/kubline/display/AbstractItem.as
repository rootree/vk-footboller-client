package ru.kubline.display {
 
import flash.display.DisplayObject;

import ru.kubline.loader.resources.ItemResource;

/**
 * Абстрактный класс элемента на сцене,
 * содержит общие свойства для всех элементов сцены
 * @author lelka
 */
public class AbstractItem implements IAbstractItem{

    /**
     * classId. уникальный идентификатор класса.
     * Этот параметр уникален для каждого типа объекта на сцене
     */
    private var classId:uint;
 
    /**
     * класс мувика который будет рисоваться на сцене
     */
    private var displayClass:String;


    private var shopType:String;

    private var name:String;

    /**
     * ссылка на инстанс класса,
     * который будет рисоваться на сцене
     */
    protected var instanceDisplayClass:DisplayObject;
 
    public function AbstractItem(building:ItemResource) {
        this.classId = building.getId();
        this.displayClass = building.getDisplayClass(); 
        this.shopType = building.getShopType();
        this.name = building.getName();

    }

    public function getClassId():uint {
        return classId;
    }

    public function getShopType():String {
        return shopType;
    }

    public function getTitle():String {
        return name;
    }



}
}