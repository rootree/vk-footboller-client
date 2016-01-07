package ru.kubline.interfaces.menu.rating {
import ru.kubline.interfaces.menu.shop.teams.TeamPanel;
import ru.kubline.model.News;
import ru.kubline.model.TeamProfiler;

public class RatingStore {

    private static var initialData:Object = new Object();

    public function RatingStore() {
        
    }

    public static function addRatingToStore(id:uint, team:TeamProfiler):void{
        initialData[id] = team;
    }
     
    public static function getRatingStore():Object{
        return initialData;
    }

    public static function getRatindStoreAsArray():Array{
        var tempArray:Array = new Array();
        for each (var value:TeamProfiler in initialData) {
            tempArray.push(value);
        } 
        return tempArray;
    }

    public static function getRatingById(id:uint):TeamProfiler{
        return initialData[id];
    }


    /**
     * Сортировка строений согласно XML
     * @param items
     */
    public static function sort(items:Array):void {
        items.sort(itemsComparator);
    }

    /**
     * Писькомер для массивов, возрашает от меньшего к большему
     * @param a
     * @param b
     * @return ar
     */
    public static function itemsComparator(a:TeamProfiler, b:TeamProfiler):int {

        var compareA:uint = (a.getPlaceInWorld() == 0) ? 1000 : a.getPlaceInWorld();
        var compareB:uint = (b.getPlaceInWorld() == 0) ? 1000 : b.getPlaceInWorld();
    
        if (compareA > compareB ) {
            return 1;
        } else if (compareA < compareB ) {
            return -1;
        } else {
            return 0;
        }
    }

}
}