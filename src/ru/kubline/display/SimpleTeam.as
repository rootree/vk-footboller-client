package ru.kubline.display {
import ru.kubline.comon.ItemsClasses;
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;

/**
 * Клас описывает дерево на сцене
 * @author lelka
 */
public class SimpleTeam extends AbstractItem{
 
    private var level:uint;
    private var cup:uint;
    private var cupItem:SimpleCup;

    public function SimpleTeam(building:ItemResource) {
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

    public function getCup():SimpleCup{
        if(!cupItem){
            cupItem = SimpleCup(ItemTypeStore.getItemResourceById(cup));
        }
        return cupItem;        
    }
 
}
}