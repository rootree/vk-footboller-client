package ru.kubline.display {
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;

/**
 * Клас описывает дерево на сцене
 * @author lelka
 */
public class SimpleCup extends AbstractItem{
 
    private var level:uint;
    private var ccode:uint;

    public function SimpleCup(building:ItemResource) {
        super(building);
        init();
    }

    protected function init():void {
        /**initParams
         */
        var params:Object = ItemTypeStore.getItemResourceById(getClassId()).getParams();
        for (var param:String in params) {
            this[param] = params[param];
        }
    }

    public function getLevel():uint {
        return level;
    }

    public function setLevel(value:uint):void {
        level = value;
    }

    public function getCcode():uint {
        return ccode;
    }

    public function setCcode(value:uint):void {
        ccode = value;
    }
}
}