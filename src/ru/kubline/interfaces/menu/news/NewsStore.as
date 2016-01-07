package ru.kubline.interfaces.menu.news {
import ru.kubline.model.News;

public class NewsStore {

    private static var initialData:Object = new Object();

    public function NewsStore() {
        
    }

    public static function addNewsToStore(id:uint, news:News):void{
        initialData[id] = news;
    }
     
    public static function getNewsStore():Object{
        return initialData;
    }

    public static function getNewsStoreAsArray():Array{
        var tempArray:Array = new Array();
        for each (var value:News in initialData) {
            tempArray.push(value);
        } 
        return tempArray;
    }

    public static function getNewsById(id:uint):News{
        return initialData[id];
    }

}
}