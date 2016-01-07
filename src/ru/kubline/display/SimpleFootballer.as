package ru.kubline.display {
import ru.kubline.loader.ItemTypeStore;
import ru.kubline.loader.resources.ItemResource;

/**
 * Клас описывает простое здание на сцене
 * @author lelka
 */
public class SimpleFootballer extends AbstractItem{

    private var multiplier:uint;
    private var rating:uint;
    private var level:uint;
    private var team:uint;
    private var year:uint;

    private var teamItem:SimpleTeam;

    public function SimpleFootballer(building:ItemResource) {
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

    public function getTeam():SimpleTeam{
        if(!teamItem){
            teamItem = SimpleTeam(ItemTypeStore.getItemResourceById(team));
        }
        return teamItem; 
    }

}
}