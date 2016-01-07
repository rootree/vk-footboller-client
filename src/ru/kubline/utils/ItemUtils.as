package ru.kubline.utils {
import flash.display.MovieClip;

import ru.kubline.loader.ClassLoader;
import ru.kubline.loader.ItemTypeStore;

public class ItemUtils {

    public static const TYPE_GOALKEEPER:String = "goalkeeper";
    public static const TYPE_FORWARD:String = "forward";
    public static const TYPE_SAFER:String = "safe";
    public static const TYPE_HALFSAFER:String = "halfsafe";
    public static const TYPE_TEAMLEAD:String = "teamlead";

    public function ItemUtils() {
    }

    public static function converStringTypeToInt(type:String):String{
        switch(type){
            case ItemUtils.TYPE_FORWARD: return ItemTypeStore.TYPE_FORWARD;
            case ItemUtils.TYPE_GOALKEEPER: return ItemTypeStore.TYPE_GOALKEEPER;
            case ItemUtils.TYPE_HALFSAFER: return ItemTypeStore.TYPE_HALFSAFER;
            case ItemUtils.TYPE_SAFER: return ItemTypeStore.TYPE_SAFER;
            case ItemUtils.TYPE_TEAMLEAD: return ItemTypeStore.TYPE_TEAMLEAD;
            default: return type;
        }
    } 

}
}